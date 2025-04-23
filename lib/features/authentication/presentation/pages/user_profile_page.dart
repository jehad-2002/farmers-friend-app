import 'dart:io';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/user_profile_avatar.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/date_utils.dart';
import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/authentication/data/datasources/auth_local_datasource.dart';
import 'package:farmersfriendapp/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/get_user.dart';
import 'package:farmersfriendapp/features/authentication/domain/usecases/update_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:farmersfriendapp/core/database/database_helper.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  DateTime? _selectedDate;
  File? _image;
  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _addressController = TextEditingController();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final dbHelper = DatabaseHelper();
      final authLocalDataSource = AuthLocalDataSourceImpl(dbHelper: dbHelper);
      final authRepository =
          AuthRepositoryImpl(localDataSource: authLocalDataSource);
      final getUser = GetUser(authRepository);
      final userId = await authLocalDataSource.getUserId();

      if (userId != null && mounted) {
        final result = await getUser(userId);
        result.fold(
          (failure) {
            if (mounted) {
              setState(() {
                _errorMessage = failure.message;
                _isLoading = false;
              });
            }
          },
          (user) {
            if (mounted) {
              setState(() {
                _currentUser = user;
                _initializeUserData(user);
                _isLoading = false;
              });
            }
          },
        );
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = "No user logged in.";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              AppLocalizations.of(context)!.unexpectedError(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  void _initializeUserData(User user) {
    _nameController.text = user.name;
    _usernameController.text = user.username;
    _phoneNumberController.text = user.phoneNumber;
    _addressController.text = user.address ?? '';
    if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
      _selectedDate = DateTime.parse(user.dateOfBirth!);
    }
    if (user.profileImage != null && user.profileImage!.isNotEmpty) {
      _image = File(user.profileImage!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppConstants.primaryColorDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_isLoading) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        id: _currentUser!.id,
        name: _nameController.text.trim(),
        username: _currentUser!.username,
        password: _currentUser!.password,
        phoneNumber: _phoneNumberController.text.trim(),
        address: _addressController.text.trim(),
        dateOfBirth: _selectedDate != null
            ? '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
            : null,
        accountStatus: AppConstants.accountStatusActive,
        accountType: _currentUser!.accountType,
        profileImage: _image?.path,
        createdAt: _currentUser!.createdAt,
      );

      final dbHelper = DatabaseHelper();
      final authLocalDataSource = AuthLocalDataSourceImpl(dbHelper: dbHelper);
      final authRepository =
          AuthRepositoryImpl(localDataSource: authLocalDataSource);
      final updateUser = UpdateUser(authRepository);

      try {
        final result = await updateUser(updatedUser);

        if (!mounted) return;
        result.fold(
          (failure) {
            if (mounted) {
              setState(() {
                _errorMessage = failure.message;
                _isLoading = false;
              });
            }
          },
          (user) {
            if (mounted) {
              setState(() {
                _currentUser = user;
                _initializeUserData(user);
                _isLoading = false;
              });
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: AppConstants.successColor),
            );
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.unexpectedError(e.toString());
            _isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.userProfile,
          style: TextStyle(
              fontFamily: AppConstants.defaultFontFamily,
              color: AppConstants.textOnPrimary),
        ),
        backgroundColor: AppConstants.primaryColorDark,
        actions: [
          IconButton(
              onPressed: () async {
                final dbHelper = DatabaseHelper();
                final authLocalDataSource =
                    AuthLocalDataSourceImpl(dbHelper: dbHelper);
                try {
                  await authLocalDataSource.clearUserData();
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {}
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: _buildProfileForm(localizations),
    );
  }

  Widget _buildProfileForm(AppLocalizations localizations) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.secondaryColor.withOpacity(0.7),
            AppConstants.backgroundColor,
          ],
        ),
      ),
      child: Center(
        child: _isLoading
            ? const LoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: UserProfileAvatar(
                          imagePath: _image?.path ?? _currentUser?.profileImage,
                          radius: 60,
                          placeholderAsset:
                              AppConstants.defaultUserProfileImagePath,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      AppTextField(
                        controller: _nameController,
                        label: localizations.fullName,
                        icon: Icons.person_outline,
                        enabled: !_isLoading,
                        validator: (value) => InputValidator.validateName(
                            localizations: localizations, value: value),
                      ),
                      const SizedBox(height: 16.0),
                      AppTextField(
                        controller: _usernameController,
                        label: localizations.username,
                        icon: Icons.alternate_email,
                        enabled: false,
                        textInputAction: TextInputAction.next,
                        readOnly: true,
                      ),
                      const SizedBox(height: 16.0),
                      AppTextField(
                        controller: _phoneNumberController,
                        label: localizations.phoneNumber,
                        icon: Icons.phone_outlined,
                        enabled: !_isLoading,
                        validator: (value) =>
                            InputValidator.validatePhoneNumber(
                                localizations: localizations, value: value),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16.0),
                      AppTextField(
                        controller: _addressController,
                        label: localizations.address,
                        icon: Icons.location_on_outlined,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16.0),
                      GestureDetector(
                        onTap: _isLoading ? null : () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  color: AppConstants.primaryColorDark),
                              const SizedBox(width: 12.0),
                              Text(
                                _selectedDate == null
                                    ? localizations.selectDateOfBirth
                                    : '${localizations.dateOfBirth}: ${AppDateUtils.formatSimpleDate(context, _selectedDate!.toIso8601String())}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _selectedDate == null
                                      ? Colors.grey
                                      : AppConstants.primaryColorDark,
                                  fontFamily: AppConstants.defaultFontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32.0),
                      ErrorMessage(message: _errorMessage),
                      if (_errorMessage != null) const SizedBox(height: 8),
                      AppButton(
                        text: localizations.saveChanges,
                        onPressed: _updateProfile,
                        isLoading: _isLoading,
                        enabled: !_isLoading,
                        icon: AppConstants.saveIcon,
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
