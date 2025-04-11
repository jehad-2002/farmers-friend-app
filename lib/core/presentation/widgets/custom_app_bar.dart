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
    final theme = Theme.of(context);

    return SafeArea(
      child: AppBar(
        title: Text(
          title,
          style: titleTextStyle ??
              theme.appBarTheme.titleTextStyle ?? // Use AppBarTheme's titleTextStyle
              TextStyle(
                color: AppConstants.textOnPrimary, // Fallback to AppConstants
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: AppConstants.defaultFontFamily,
              ),
        ),
        backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor ?? AppConstants.primaryColor,
        elevation: theme.appBarTheme.elevation ?? 1, // Use AppBarTheme's elevation
        centerTitle: true,
        shape: theme.appBarTheme.shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(AppConstants.borderRadiusSmall),
              ),
            ),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
        iconTheme: iconTheme ?? theme.appBarTheme.iconTheme ?? IconThemeData(color: AppConstants.textOnPrimary),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

