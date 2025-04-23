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

    // --- تحديد الألوان المتناسقة مع الخلفية الفاتحة ---
    // استخدام الألوان الأساسية من AppConstants التي تناسب الخلفيات الفاتحة
    final Color dialogTextColorPrimary = AppConstants.textColorPrimary; // اللون الأساسي للنص (أسود/رمادي داكن)
    final Color dialogTextColorSecondary = AppConstants.textColorSecondary; // اللون الثانوي للنص (بني)
    final Color dialogIconColor = AppConstants.brownColor; // لون الأيقونات (بني)
    final Color dialogDividerColor = AppConstants.brownColor.withOpacity(0.3); // لون الفاصل (بني فاتح شفاف)
    // لون زر الإغلاق يمكن أن يكون اللون الأساسي الداكن للتطبيق
    final Color dialogCloseButtonBgColor = AppConstants.primaryColorDark;
    final Color dialogCloseButtonFgColor = AppConstants.whiteColor; // نص أبيض على الزر الداكن
    // لون إطار الصورة يمكن أن يكون البني الفاتح أو الأبيض
    final Color avatarBorderColor = AppConstants.brownColor.withOpacity(0.6);


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

          // 1. حالة الانتظار
          if (snapshot.connectionState == ConnectionState.waiting) {
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.largePadding),
                // استخدام مؤشر التحميل الافتراضي (يفترض أن يستخدم primaryColorDark)
                child: LoadingIndicator(text: localizations.loading,isCentered: true,),
              ),
            );
          }
          // 2. حالة الخطأ
          else if (snapshot.hasError) {
            final failure = snapshot.error as Failure;
            content = Padding(
              padding: const EdgeInsets.all(AppConstants.mediumPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AppConstants.errorOutlineIcon,
                    color: AppConstants.errorColor, // لون الخطأ يبقى كما هو
                    size: 50,
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  Text(
                    localizations.errorLoadingData,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppConstants.errorColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.smallPadding),
                  Text(
                    failure.getLocalizedMessage(context),
                    style: theme.textTheme.bodyMedium?.copyWith(
                       color: AppConstants.textColorSecondary.withOpacity(0.9), // استخدام لون النص الثانوي
                       fontFamily: AppConstants.defaultFontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.mediumPadding * 1.5),
                  SizedBox(
                    width: 120,
                    child: AppButton(
                      text: localizations.ok,
                      onPressed: () => Navigator.of(context).pop(),
                      backgroundColor: AppConstants.errorColor, // زر الخطأ
                      foregroundColor: AppConstants.whiteColor,
                    ),
                  ),
                ],
              ),
            );
          }
          // 3. حالة النجاح
          else if (snapshot.hasData) {
            final user = snapshot.data!;
            content = SingleChildScrollView(
              padding: const EdgeInsets.only(
                 top: AppConstants.mediumPadding,
                 bottom: AppConstants.defaultPadding,
                 left: AppConstants.defaultPadding,
                 right: AppConstants.defaultPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserProfileAvatar(
                    imagePath: user.profileImage,
                    radius: 55,
                    borderColor: avatarBorderColor, // استخدام اللون المحدد للإطار
                    borderWidth: 2.0, // تقليل عرض الإطار قليلاً
                    badge: buildUserTypeBadge(context, user.accountType),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  // استخدام لون النص الأساسي الداكن للاسم
                  Text(
                    user.name.isNotEmpty
                        ? user.name
                        : localizations.nameNotAvailable,
                    style: AppStyles.sectionHeader.copyWith(
                      color: dialogTextColorPrimary, // اللون الأساسي الداكن
                      fontSize: 20,
                      fontFamily: AppConstants.defaultFontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // استخدام لون النص الثانوي لاسم المستخدم
                  if (user.username.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppConstants.smallPadding / 2),
                      child: Text(
                        '@${user.username}',
                        style: AppStyles.descriptionBody.copyWith(
                          color: dialogTextColorSecondary, // اللون الثانوي (البني)
                          fontSize: 14,
                          fontFamily: AppConstants.defaultFontFamily,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Divider(color: dialogDividerColor, thickness: 0.8, indent: 20, endIndent: 20), // زيادة سمك الفاصل قليلاً
                  const SizedBox(height: AppConstants.smallPadding),
                  // تمرير الألوان الداكنة للدالة المساعدة
                  _buildUserInfoDetails(context, localizations, user,
                      titleColor: dialogTextColorPrimary,
                      valueColor: dialogTextColorSecondary,
                      iconColor: dialogIconColor),
                  const SizedBox(height: AppConstants.mediumPadding),
                  Divider(color: dialogDividerColor, thickness: 0.8, indent: 20, endIndent: 20),
                  const SizedBox(height: AppConstants.defaultPadding),
                  // زر الإغلاق باللون الأساسي الداكن
                  SizedBox(
                    width: 150,
                    child: AppButton(
                      text: localizations.close,
                      backgroundColor: dialogCloseButtonBgColor, // اللون الأساسي الداكن
                      foregroundColor: dialogCloseButtonFgColor, // النص الأبيض
                      elevation: AppConstants.elevationLow, // إضافة ظل بسيط
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            );
          }
          // 4. حالة عدم وجود بيانات
          else {
            content = Center(
                child: Text(
                    localizations.noData,
                    style: TextStyle(color: dialogTextColorSecondary), // استخدام اللون الثانوي
                )
             );
          }

          return StyledDialogBackground(
             padding: EdgeInsets.zero,
             child: content
          );
        },
      ),
    );
  }

  /// دالة مساعدة لبناء قسم تفاصيل معلومات المستخدم مع تمرير الألوان الداكنة.
  Widget _buildUserInfoDetails(
      BuildContext context,
      AppLocalizations localizations,
      User user,
      {required Color titleColor, required Color valueColor, required Color iconColor}) {

    // استخدام الأنماط الأساسية وتطبيق الألوان الممررة (الداكنة)
    final titleStyle = AppStyles.userInfoLabel.copyWith(
        color: titleColor, // اللون الأساسي الداكن
        fontWeight: FontWeight.w600,
        fontFamily: AppConstants.defaultFontFamily);
    final valueStyle = AppStyles.userInfoValue.copyWith(
        color: valueColor, // اللون الثانوي (بني)
        fontFamily: AppConstants.defaultFontFamily);

    // ألوان الحالة تبقى كما هي (أخضر للنشط، أصفر/برتقالي لغير النشط)
    final Color activeStatusColor = AppConstants.successColor;
    final Color inactiveStatusColor = AppConstants.warningColor; // استخدام درجة أغمق للتحذير

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoRow(
            icon: AppConstants.personIcon,
            iconColor: iconColor, // لون الأيقونة (بني)
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
                iconColor: iconColor,
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
                iconColor: iconColor,
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
                iconColor: iconColor,
                title: localizations.accountStatus,
                titleStyle: titleStyle,
                value: UserUtils.getAccountStatusText(
                    user.accountStatus, localizations),
                valueStyle: valueStyle.copyWith( // تطبيق لون الحالة
                    fontWeight: FontWeight.w500,
                    color: user.accountStatus == AppConstants.accountStatusActive
                        ? activeStatusColor
                        : inactiveStatusColor),
              ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: AppConstants.smallPadding / 1.5),
             child: InfoRow(
                icon: AppConstants.accountCircleIcon,
                iconColor: iconColor,
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
                iconColor: iconColor,
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
                iconColor: iconColor,
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