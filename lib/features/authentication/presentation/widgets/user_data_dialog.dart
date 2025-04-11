import 'package:farmersfriendapp/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Core Imports
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/product.dart';
import 'package:farmersfriendapp/core/models/user.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/user_utils.dart';

// Presentation Imports
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/info_row.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/styled_dialog_background.dart';
import 'package:farmersfriendapp/core/presentation/widgets/user_profile_avatar.dart';

Future<void> showUserDataDialog(BuildContext context, Product product) async {
  await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => UserDataDialogContent(userId: product.userId),
  );
}

class UserDataDialogContent extends StatefulWidget {
  final int userId;
  const UserDataDialogContent({Key? key, required this.userId})
      : super(key: key);

  @override
  State<UserDataDialogContent> createState() => _UserDataDialogContentState();
}

class _UserDataDialogContentState extends State<UserDataDialogContent> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<User> _fetchUser() async {
    final userOrFailure = await sl.getUser(widget.userId);
    return userOrFailure.fold(
      (failure) {
        print("Error fetching user data in dialog: ${failure.message}");
        throw failure;
      },
      (user) {
        return user;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding * 1.5,
        vertical: AppConstants.largePadding,
      ),
      child: FutureBuilder<User>(
        future: _userFuture,
        builder: (context, snapshot) {
          Widget content;

          if (snapshot.connectionState == ConnectionState.waiting) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                child: LoadingIndicator(
                  text: localizations.loading,
                  isCentered: true,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            content = Padding(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AppConstants.errorOutlineIcon,
                    color: theme.colorScheme.error,
                    size: 50,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    localizations.errorLoadingData,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    failure.getLocalizedMessage(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumPadding * 1.5),
                  SizedBox(
                    width: 120,
                    child: AppButton(
                      text: localizations.ok,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            content = SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.defaultPadding,
                horizontal: AppConstants.defaultPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserProfileAvatar(
                    imagePath: user.profileImage,
                    radius: 55,
                    borderColor: theme.dividerColor.withOpacity(0.6),
                    borderWidth: 2.0,
                    badge: buildUserTypeBadge(context, user.accountType),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    user.name.isNotEmpty
                        ? user.name
                        : localizations.nameNotAvailable,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (user.username.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppConstants.smallPadding / 2),
                      child: Text(
                        '@${user.username}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Divider(
                    color: theme.dividerColor.withOpacity(0.3),
                    thickness: 0.8,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  _buildUserInfoDetails(context, localizations, user, theme),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Divider(
                    color: theme.dividerColor.withOpacity(0.3),
                    thickness: 0.8,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  SizedBox(
                    width: 150,
                    child: AppButton(
                      text: localizations.close,
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: AppConstants.elevationLow,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            content = Center(
              child: Text(
                localizations.noData,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            );
          }

          return StyledDialogBackground(
            padding: EdgeInsets.zero,
            child: content,
          );
        },
      ),
    );
  }

  Widget _buildUserInfoDetails(
    BuildContext context,
    AppLocalizations localizations,
    User user,
    ThemeData theme,
  ) {
    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
    );
    final valueStyle = theme.textTheme.bodyMedium;

    final Color activeStatusColor = theme.colorScheme.secondary;
    final Color inactiveStatusColor = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(
            icon: AppConstants.personIcon,
            iconColor: theme.iconTheme.color,
            title: localizations.userId,
            titleStyle: titleStyle,
            value: user.id?.toString() ?? localizations.notAvailable,
            valueStyle: valueStyle,
          ),
          if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
              child: InfoRow(
                icon: AppConstants.cakeIcon,
                iconColor: theme.iconTheme.color,
                title: localizations.dateOfBirth,
                titleStyle: titleStyle,
                value: AppDateUtils.formatSimpleDate(context, user.dateOfBirth),
                valueStyle: valueStyle,
              ),
            ),
          if (user.address != null && user.address!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
              child: InfoRow(
                icon: AppConstants.locationOnIcon,
                iconColor: theme.iconTheme.color,
                title: localizations.address,
                titleStyle: titleStyle,
                value: user.address!,
                valueStyle: valueStyle,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
            child: InfoRow(
              icon: AppConstants.verifiedUserIcon,
              iconColor: theme.iconTheme.color,
              title: localizations.accountStatus,
              titleStyle: titleStyle,
              value: UserUtils.getAccountStatusText(
                  user.accountStatus, localizations),
              valueStyle: valueStyle?.copyWith(
                fontWeight: FontWeight.w500,
                color: user.accountStatus == AppConstants.accountStatusActive
                    ? activeStatusColor
                    : inactiveStatusColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
            child: InfoRow(
              icon: AppConstants.accountCircleIcon,
              iconColor: theme.iconTheme.color,
              title: localizations.accountType,
              titleStyle: titleStyle,
              value: UserUtils.getAccountTypeName(user.accountType, localizations),
              valueStyle: valueStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
            child: InfoRow(
              icon: AppConstants.phoneIcon,
              iconColor: theme.iconTheme.color,
              title: localizations.phoneNumber,
              titleStyle: titleStyle,
              value: user.phoneNumber,
              valueStyle: valueStyle,
            ),
          ),
          if (user.createdAt != null)
            Padding(
              padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
              child: InfoRow(
                icon: AppConstants.calendarTodayIcon,
                iconColor: theme.iconTheme.color,
                title: localizations.memberSince,
                titleStyle: titleStyle,
                value: AppDateUtils.formatSimpleDate(context, user.createdAt),
                valueStyle: valueStyle,
              ),
            ),
        ],
      ),
    );
  }
}