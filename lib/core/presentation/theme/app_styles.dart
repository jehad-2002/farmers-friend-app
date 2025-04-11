import 'package:flutter/material.dart';

class AppStyles {
  static TextStyle baseStyle(BuildContext context) => TextStyle(
        fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
        fontSize: 16,
      );

  static TextStyle appBarTitle(BuildContext context) =>
      Theme.of(context).appBarTheme.titleTextStyle ??
      baseStyle(context).copyWith(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 21,
      );

  static TextStyle sectionHeader(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        height: 1.2,
      );

  static TextStyle productTitleLarge(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
        height: 1.2,
        letterSpacing: -0.5,
      );

  static TextStyle productTitleMedium(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 19,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.bodyMedium?.color,
        height: 1.3,
      );

  static TextStyle priceLarge(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle priceMedium(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.secondary,
      );

  static TextStyle dateStyle(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 13,
        color: Theme.of(context).hintColor,
      );

  static TextStyle descriptionBody(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 16,
        height: 1.6,
        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.85),
        letterSpacing: 0.2,
      );

  static TextStyle buttonTextStyle(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle inputLabel(BuildContext context) =>
      baseStyle(context).copyWith(
        color: Theme.of(context).textTheme.bodyMedium?.color,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  static TextStyle hintText(BuildContext context) =>
      baseStyle(context).copyWith(
        color: Theme.of(context).hintColor,
        fontSize: 15,
        fontStyle: FontStyle.italic,
      );

  static TextStyle errorText(BuildContext context) =>
      baseStyle(context).copyWith(
        color: Theme.of(context).colorScheme.error,
        fontSize: 13,
      );

  static TextStyle userInfoLabel(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.bodySmall?.color,
      );

  static TextStyle userInfoValue(BuildContext context) =>
      baseStyle(context).copyWith(
        fontSize: 16,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      );
}

