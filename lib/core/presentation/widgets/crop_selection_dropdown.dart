import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/get_all_crops.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CropSelectionDropdown extends StatefulWidget {
  final int? initialValue;
  final ValueChanged<int?> onChanged;
  final FormFieldValidator<int>? validator;
  final bool enabled;
  final String? labelText;

  const CropSelectionDropdown({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.enabled = true,
    this.labelText,
  });

  @override
  State<CropSelectionDropdown> createState() => _CropSelectionDropdownState();
}

class _CropSelectionDropdownState extends State<CropSelectionDropdown> {
  List<Crop>? _crops;
  bool _isLoading = true;
  String? _error;
  late final GetAllCrops _getAllCrops;

  @override
  void initState() {
    super.initState();
    _getAllCrops = sl.getAllCrops;
    _fetchCrops();
  }

  Future<void> _fetchCrops() async {
    if (!_isLoading) setState(() => _isLoading = true);
    _error = null;

    try {
      final result = await _getAllCrops();
      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() => _error = failure.getLocalizedMessage(context));
        },
        (crops) {
          setState(() => _crops = crops);
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _error =
            AppLocalizations.of(context)!.unexpectedError(e.toString()));
      }
      print("Error fetching crops for dropdown: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final effectiveLabel = widget.labelText ?? localizations.crop;

    final InputDecoration decoration = InputDecoration(
      labelText: effectiveLabel,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: widget.enabled
            ? theme.textTheme.bodyMedium?.color?.withOpacity(0.8)
            : theme.disabledColor,
        fontFamily: AppConstants.defaultFontFamily,
      ),
      prefixIcon: Icon(AppConstants.cropIcon,
          color: widget.enabled
              ? theme.colorScheme.primary
              : theme.disabledColor,
          size: 21),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: theme.dividerColor.withOpacity(0.6),
          width: 1.1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: theme.dividerColor.withOpacity(0.6),
          width: 1.1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 1.3,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        borderSide: BorderSide(
          color: theme.colorScheme.error,
          width: 1.5,
        ),
      ),
      filled: true,
      fillColor: widget.enabled
          ? theme.colorScheme.surface.withOpacity(0.9)
          : theme.disabledColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppConstants.defaultPadding * 0.7,
        horizontal: AppConstants.defaultPadding * 0.8,
      ),
    );

    if (_isLoading) {
      return InputDecorator(
        decoration: decoration.copyWith(
          labelText: null,
          hintText: localizations.loadingCrops,
        ),
        child: const SizedBox(
            height: 24, child: Center(child: LoadingIndicator())),
      );
    }

    if (_error != null) {
      return InputDecorator(
        decoration: decoration.copyWith(
          labelText: null,
          errorText: _error,
          errorMaxLines: 3,
        ),
        child: Row(
          children: [
            Icon(AppConstants.errorOutlineIcon,
                color: theme.colorScheme.error, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                localizations.errorLoadingCrops,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, size: 22),
              tooltip: localizations.retry,
              onPressed: widget.enabled ? _fetchCrops : null,
            ),
          ],
        ),
      );
    }

    if (_crops == null || _crops!.isEmpty) {
      return InputDecorator(
        decoration: decoration,
        child: Text(
          localizations.noCropsAvailable,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color,
            fontFamily: AppConstants.defaultFontFamily,
          ),
        ),
      );
    }

    return DropdownButtonFormField<int>(
      value: widget.initialValue,
      items: !widget.enabled
          ? []
          : _crops!.map((crop) {
              return DropdownMenuItem<int>(
                value: crop.cropId,
                child: Text(
                  crop.cropName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: AppConstants.defaultFontFamily,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
      onChanged: widget.enabled ? widget.onChanged : null,
      validator: widget.validator ??
          (value) => value == null ? localizations.pleaseSelectCrop : null,
      decoration: decoration,
      disabledHint: widget.initialValue != null &&
              (_crops?.any((c) => c.cropId == widget.initialValue) ?? false)
          ? Text(
              _crops!
                  .firstWhere((c) => c.cropId == widget.initialValue!)
                  .cropName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: AppConstants.defaultFontFamily,
              ),
            )
          : null,
      isExpanded: true,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: widget.enabled
            ? theme.textTheme.bodyMedium?.color
            : theme.disabledColor,
        fontFamily: AppConstants.defaultFontFamily,
        fontSize: 16,
      ),
    );
  }
}

