import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final IconThemeData? iconTheme;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.titleTextStyle,
    this.iconTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        title: Text(
          title,
          style: titleTextStyle ??
              TextStyle(
                color: AppConstants.whiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 21,
                fontFamily: AppConstants.defaultFontFamily,
              ),
        ),
        backgroundColor: backgroundColor ?? AppConstants.primaryColorDark,
        elevation: 1,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppConstants.borderRadiusSmall),
          ),
        ),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
        iconTheme:
            iconTheme ?? const IconThemeData(color: AppConstants.whiteColor),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

