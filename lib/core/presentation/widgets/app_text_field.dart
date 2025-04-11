import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final IconData? icon;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onSaved;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;
  final Color? fillColor;
  final bool readOnly;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.icon,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.onChanged,
    this.onSaved,
    this.onTap,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.suffixIcon,
    this.fillColor,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveLabelStyle = (enabled
            ? AppStyles.inputLabel(context)
            : AppStyles.inputLabel(context).copyWith(color: theme.disabledColor))
        .copyWith(fontFamily: theme.textTheme.bodyMedium?.fontFamily);
    final effectiveTextStyle = theme.textTheme.bodyLarge?.copyWith(
          color: enabled ? theme.textTheme.bodyLarge?.color : theme.disabledColor,
          fontFamily: theme.textTheme.bodyMedium?.fontFamily,
        ) ??
        TextStyle(
          color: enabled ? theme.textTheme.bodyLarge?.color : theme.disabledColor,
          fontFamily: theme.textTheme.bodyMedium?.fontFamily,
        );
    final effectiveHintStyle = AppStyles.hintText(context);
    final effectiveErrorStyle = AppStyles.errorText(context);

    final effectiveIconColor =
        enabled ? theme.iconTheme.color : theme.disabledColor;
    final effectiveFillColor = fillColor ?? 
        (enabled
            ? theme.colorScheme.surface.withOpacity(0.8) // Use theme's surface color
            : theme.disabledColor.withOpacity(0.1));

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      borderSide: BorderSide(
          color: enabled
              ? theme.dividerColor.withOpacity(0.6) // Use theme's divider color
              : Colors.transparent,
          width: 1),
    );

    final focusedBorder = border.copyWith(
      borderSide: BorderSide(
        color: theme.colorScheme.primary, // Use theme's primary color
        width: 1.3,
      ),
    );

    final errorBorder = border.copyWith(
      borderSide: BorderSide(
        color: theme.colorScheme.error, // Use theme's error color
        width: 1.3,
      ),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      style: effectiveTextStyle,
      validator: validator,
      onChanged: onChanged,
      onSaved: onSaved,
      onTap: onTap,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      cursorColor: theme.colorScheme.primary, // Use theme's primary color
      decoration: InputDecoration(
        labelText: label,
        labelStyle: effectiveLabelStyle,
        hintText: hintText,
        hintStyle: effectiveHintStyle,
        errorStyle: effectiveErrorStyle,
        prefixIcon: icon != null
            ? Icon(icon, color: effectiveIconColor, size: 21)
            : null,
        suffixIcon: suffixIcon,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        disabledBorder: border.copyWith(borderSide: BorderSide.none),
        filled: true,
        fillColor: effectiveFillColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppConstants.defaultPadding * 0.7,
          horizontal: AppConstants.defaultPadding,
        ),
        counterText: "",
      ),
    );
  }
}

