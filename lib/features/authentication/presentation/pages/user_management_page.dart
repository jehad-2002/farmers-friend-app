import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Core Imports
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/confirm_dialog.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_search_bar.dart'; // For search functionality
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/user_profile_avatar.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/user_utils.dart';

// Feature Imports
import 'package:farmersfriendapp/features/authentication/domain/usecases/get_all_users.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/update_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/delete_user.dart'; // Optional


// Assume this page is only accessible by Admins
class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  // State Variables
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();

  // Use Cases
  late final GetAllUsers _getAllUsersUseCase;
  late final UpdateUser _updateUserUseCase;
  late final DeleteUser? _deleteUserUseCase; // Optional

  @override
  void initState() {
    super.initState();
    _getAllUsersUseCase = sl.getAllUsers;
    _updateUserUseCase = sl.updateUser;
    _deleteUserUseCase = sl.deleteUser; // Get optional use case

    _fetchUsers(); // Fetch users on init
    _searchController.addListener(_filterUsers); // Listen to search changes
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  /// Fetches the list of users from the repository.
  Future<void> _fetchUsers({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final result = await _getAllUsersUseCase(); // Call use case
      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() {
            _errorMessage = failure.getLocalizedMessage(context);
            _users = [];
            _filteredUsers = [];
            _isLoading = false;
          });
        },
        (users) {
          setState(() {
            _users = users;
            _filterUsers(); // Apply current search filter
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      if (mounted) {
         setState(() {
            _errorMessage = AppLocalizations.of(context)!.unexpectedError(e.toString());
             _users = [];
            _filteredUsers = [];
            _isLoading = false;
          });
      }
    }
  }

  /// Filters the user list based on the search term.
  void _filterUsers() {
    final searchTerm = _searchController.text.toLowerCase();
    setState(() {
      if (searchTerm.isEmpty) {
        _filteredUsers = List.from(_users); // Show all if search is empty
      } else {
        _filteredUsers = _users.where((user) {
          return user.name.toLowerCase().contains(searchTerm) ||
                 user.username.toLowerCase().contains(searchTerm) ||
                 user.phoneNumber.contains(searchTerm); // Search multiple fields
        }).toList();
      }
    });
  }

  /// Updates a user's status or type.
  Future<void> _updateUserField(User user, {int? newStatus, int? newType}) async {
      if (newStatus == null && newType == null) return; // No change

      // Show loading indicator during update
      _showLoadingOverlay();

      final updatedUser = user.copyWith(
        accountStatus: newStatus ?? user.accountStatus,
        accountType: newType ?? user.accountType,
        updatedAt: AppConstants.getCurrentDateFormattedTime(),
      );

      try {
          final result = await _updateUserUseCase(updatedUser);
          if (!mounted) return;

          Navigator.of(context).pop(); // Hide loading overlay

          result.fold(
            (failure){
               _showErrorSnackbar(failure.getLocalizedMessage(context));
            },
            (savedUser){
               _showSuccessSnackbar("User '${savedUser.name}' updated successfully."); // Add localization
               _fetchUsers(showLoading: false); // Refresh list without full loading indicator
            }
          );

      } catch (e) {
         if(mounted) {
            Navigator.of(context).pop(); // Hide loading overlay
           _showErrorSnackbar(AppLocalizations.of(context)!.unexpectedError(e.toString()));
         }
      }
  }

   /// Confirms and deletes a user (Optional).
  Future<void> _confirmAndDeleteUser(User user) async {
    if (_deleteUserUseCase == null) return; // Check if delete is enabled

    final localizations = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        title: localizations.confirmDelete,
        // Add specific confirmation message key
        content: localizations.deleteUserConfirmation(user.name),
        confirmText: localizations.delete,
        cancelText: localizations.cancel,
        confirmTextColor: AppConstants.errorColor,
        onConfirm: () {},
      ),
    );

    if (confirmed == true && user.id != null) {
      _showLoadingOverlay();
      try {
        final result = await _deleteUserUseCase!(user.id!);
        if (!mounted) return;
        Navigator.of(context).pop(); // Hide overlay

        result.fold(
          (failure) => _showErrorSnackbar(failure.getLocalizedMessage(context)),
          (_) {
            _showSuccessSnackbar("User '${user.name}' deleted."); // Add localization
            _fetchUsers(showLoading: false); // Refresh list
          },
        );
      } catch (e) {
         if(mounted) {
            Navigator.of(context).pop(); // Hide overlay
            _showErrorSnackbar(AppLocalizations.of(context)!.unexpectedError(e.toString()));
         }
      }
    }
  }


  // --- Helper UI Methods ---

  /// Shows a simple loading overlay dialog.
  void _showLoadingOverlay() {
     showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: LoadingIndicator(isCentered: true,))
     );
  }

  /// Shows a success snackbar message.
  void _showSuccessSnackbar(String message) {
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.successColor,
        duration: AppConstants.snackBarDuration,
     ));
  }

  /// Shows an error snackbar message.
  void _showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: AppConstants.errorColor,
         duration: AppConstants.snackBarDuration,
     ));
  }

  /// Shows a bottom sheet to change user status.
  void _showStatusChangeSheet(User user) {
     final localizations = AppLocalizations.of(context)!;
     showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.borderRadiusMedium)),
        ),
        builder: (context) {
          return Wrap(
             children: [
                ListTile(title: Text("Change Status for ${user.name}", style: Theme.of(context).textTheme.titleMedium)), // Add localization
                const Divider(height: 1),
                RadioListTile<int>(
                  title: Text(localizations.active),
                  value: AppConstants.accountStatusActive,
                  groupValue: user.accountStatus,
                  onChanged: (value) {
                     Navigator.pop(context); // Close sheet
                     if (value != null) _updateUserField(user, newStatus: value);
                  },
                  activeColor: AppConstants.primaryColor,
                ),
                 RadioListTile<int>(
                  title: Text(localizations.inactive),
                  value: AppConstants.accountStatusInactive,
                  groupValue: user.accountStatus,
                  onChanged: (value) {
                     Navigator.pop(context);
                     if (value != null) _updateUserField(user, newStatus: value);
                  },
                   activeColor: AppConstants.primaryColor,
                ),
             ],
          );
        }
     );
  }

  /// Shows a bottom sheet to change user account type.
  void _showTypeChangeSheet(User user) {
     final localizations = AppLocalizations.of(context)!;
     // List of available account types (excluding admin maybe?)
     final accountTypes = {
        AppConstants.accountTypeFarmer: localizations.farmer,
        AppConstants.accountTypeTrader: localizations.trader,
        AppConstants.accountTypeAgriculturalGuide: localizations.agriculturalGuide,
        AppConstants.accountTypeAdmin: localizations.admin, //?? Maybe admin cannot be set this way
     //   AppConstants.accountTypeVisitor: localizations.visitor,
     };

     showModalBottomSheet(
        context: context,
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.borderRadiusMedium)),
        ),
        builder: (context) {
          return Wrap(
             children: [
                ListTile(title: Text("Change Account Type for ${user.name}", style: Theme.of(context).textTheme.titleMedium)), // Add localization
                const Divider(height: 1),
                ...accountTypes.entries.map((entry) {
                  return RadioListTile<int>(
                     title: Text(entry.value),
                     value: entry.key,
                     groupValue: user.accountType,
                     onChanged: (value) {
                        Navigator.pop(context);
                        if (value != null) _updateUserField(user, newType: value);
                     },
                      activeColor: AppConstants.primaryColor,
                  );
                }).toList(),
             ],
          );
        }
     );
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.manageUsers, // Add localization key
        actions: [
           // Refresh button
           IconButton(
              tooltip: localizations.refresh, // Add localization
              onPressed: _isLoading ? null : () => _fetchUsers(),
              icon: const Icon(Icons.refresh),
            )
        ],
      ),
      body: Container(
         decoration:  BoxDecoration(gradient: AppGradients.pageBackground),
         child: Column(
            children: [
               // --- Search Bar ---
               Padding(
                 padding: const EdgeInsets.all(AppConstants.defaultPadding),
                 child: CustomSearchBar(
                    controller: _searchController,
                    hintText: localizations.searchUsers, // Add localization
                    onChanged: (_) => _filterUsers(), // Trigger filter on change
                    onClear: _filterUsers, // Also filter when cleared
                 ),
               ),
               // --- Content Area ---
               Expanded(
                  child: _buildContent(context, localizations),
               ),
            ],
         ),
      ),
    );
  }

  /// Builds the main content based on the loading/error/data state.
  Widget _buildContent(BuildContext context, AppLocalizations localizations) {
    if (_isLoading) {
      return Center(child: LoadingIndicator(text: localizations.loading,isCentered: true,));
    }

    if (_errorMessage != null) {
      return Center(
          child: ErrorIndicator(
              message: _errorMessage!,
              onRetry: _fetchUsers,
          )
      );
    }

    if (_filteredUsers.isEmpty) {
       // Show different message if search is active vs. no users at all
      final message = _searchController.text.isNotEmpty
           ? localizations.noMatchingUsersFound // Add localization
           : localizations.noUsersFound; // Add localization

      return Center(
          child: EmptyListIndicator(
              message: message,
              icon: Icons.people_outline,
          )
      );
    }

    // --- User List ---
    return RefreshIndicator(
       onRefresh: () => _fetchUsers(showLoading: false), // Allow pull-to-refresh
       color: AppConstants.primaryColor,
       child: ListView.separated(
          itemCount: _filteredUsers.length,
          padding: const EdgeInsets.only(
             left: AppConstants.defaultPadding,
             right: AppConstants.defaultPadding,
             bottom: AppConstants.largePadding, // Space at the bottom
          ),
          separatorBuilder: (_, __) => const SizedBox(height: AppConstants.defaultPadding / 1.5),
          itemBuilder: (context, index) {
            final user = _filteredUsers[index];
            return _buildUserListItem(context, localizations, user);
          },
        ),
    );
  }

   /// Builds a single list item representing a user.
  Widget _buildUserListItem(BuildContext context, AppLocalizations localizations, User user) {
    final theme = Theme.of(context);
    final bool isActive = user.accountStatus == AppConstants.accountStatusActive;
    final String accountType = UserUtils.getAccountTypeName(user.accountType, localizations);
    final String statusText = UserUtils.getAccountStatusText(user.accountStatus, localizations);
    final Color statusColor = isActive ? AppConstants.successColor : AppConstants.warningColor;

    return Card(
       elevation: AppConstants.elevationLow,
       margin: EdgeInsets.zero, // Let ListView handle spacing
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
       ),
       child: InkWell(
          // Optional: Navigate to user detail/edit page on tap
          // onTap: () { /* Navigate to detail page */ },
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            child: Row(
              children: [
                 // --- Avatar ---
                 UserProfileAvatar(
                   imagePath: user.profileImage,
                   radius: 28,
                   placeholderAsset: AppConstants.defaultUserProfileImagePath,
                   badge: buildUserTypeBadge(context, user.accountType), // Show type badge
                 ),
                 const SizedBox(width: AppConstants.defaultPadding),
                 // --- User Info ---
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                        Text(
                           user.name.isNotEmpty ? user.name : localizations.nameNotAvailable,
                           style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppConstants.textColorPrimary,
                              fontFamily: AppConstants.defaultFontFamily
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                        ),
                         Text(
                           user.username.isNotEmpty ? "@${user.username}" : user.phoneNumber, // Show username or phone
                           style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppConstants.textColorSecondary,
                              fontFamily: AppConstants.defaultFontFamily
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.smallPadding / 2),
                         Text(
                            "$accountType • $statusText", // Combine type and status
                            style: theme.textTheme.bodySmall?.copyWith(
                               color: statusColor, // Color code status
                               fontWeight: FontWeight.w500,
                               fontFamily: AppConstants.defaultFontFamily
                            ),
                         ),
                     ],
                   ),
                 ),
                 const SizedBox(width: AppConstants.smallPadding),
                 // --- Action Menu ---
                 PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: AppConstants.brownColor.withOpacity(0.7)),
                    tooltip: "Actions", // Add localization
                    onSelected: (value) {
                       if (value == 'status') {
                          _showStatusChangeSheet(user);
                       } else if (value == 'type') {
                          _showTypeChangeSheet(user);
                       } else if (value == 'delete' && _deleteUserUseCase != null) {
                          _confirmAndDeleteUser(user);
                       }
                       // Add 'edit' option if you have an edit page
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                       PopupMenuItem<String>(
                          value: 'status',
                          child: ListTile(
                             leading: Icon(isActive ? Icons.toggle_off_outlined : Icons.toggle_on_outlined, color: AppConstants.brownColor),
                             title: Text(isActive ? "Deactivate" : "Activate"), // Add localization
                          ),
                       ),
                       PopupMenuItem<String>(
                          value: 'type',
                          child: ListTile(
                              leading: Icon(Icons.switch_account_outlined, color: AppConstants.brownColor),
                              title: Text("Change Type"), // Add localization
                          ),
                       ),
                       // Optional: Edit action
                       // PopupMenuItem<String>(
                       //    value: 'edit',
                       //    child: ListTile(
                       //        leading: Icon(AppConstants.editIcon, color: AppConstants.iconColorDefault),
                       //        title: Text(localizations.edit),
                       //    ),
                       // ),
                       if (_deleteUserUseCase != null) ...[ // Show delete only if enabled
                          const PopupMenuDivider(),
                          PopupMenuItem<String>(
                             value: 'delete',
                             child: ListTile(
                                leading: Icon(AppConstants.deleteIcon, color: AppConstants.errorColor),
                                title: Text(localizations.delete, style: TextStyle(color: AppConstants.errorColor)),
                             ),
                          ),
                       ]
                    ],
                 )
              ],
            ),
          ),
       ),
    );
  }

}
