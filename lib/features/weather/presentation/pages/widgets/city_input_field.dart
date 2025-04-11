import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CityInputField extends StatefulWidget {
  final ValueChanged<String> onCitySubmitted;
  final bool enabled;
  final String? initialValue;

  const CityInputField({
    super.key,
    required this.onCitySubmitted,
    this.enabled = true,
    this.initialValue,
  });

  @override
  State<CityInputField> createState() => _CityInputFieldState();
}

class _CityInputFieldState extends State<CityInputField> {
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _cityController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  void _submitCity() {
    if (widget.enabled && _cityController.text.trim().isNotEmpty) {
      FocusScope.of(context).unfocus();
      widget.onCitySubmitted(_cityController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: AppTextField(
            controller: _cityController,
            label: localizations.city,
            hintText: localizations.search,
            icon: AppConstants.accountCircleIcon,
            enabled: widget.enabled,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => _submitCity(),
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        SizedBox(
          height: 58,
          child: IconButton(
            icon: const Icon(AppConstants.searchIcon),
            color: theme.colorScheme.onPrimary, // Use theme's onPrimary color
            tooltip: localizations.search,
            padding: const EdgeInsets.all(12),
            style: IconButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1), // Use theme's primary color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium,
                ),
              ),
            ),
            onPressed: widget.enabled ? _submitCity : null,
          ),
        )
      ],
    );
  }
}
