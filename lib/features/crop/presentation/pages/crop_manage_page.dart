import 'dart:async';
import 'dart:io';
import 'package:farmersfriendapp/core/models/crop.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/presentation/widgets/single_image_picker.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/category/presentation/widgets/category_selection_dropdown.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/add_crop.dart';
import 'package:farmersfriendapp/features/crop/domain/usecases/update_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class ManageCropPage extends StatefulWidget {
  final Crop? crop;

  const ManageCropPage({super.key, this.crop});

  @override
  State<ManageCropPage> createState() => _ManageCropPageState();
}

class _ManageCropPageState extends State<ManageCropPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  int? _selectedCategoryId;
  File? _newImageFile;
  String? _initialImagePath;
  bool _isLoading = false;
  String? _errorMessage;

  late final AddCrop _addCrop;
  late final UpdateCrop _updateCrop;

  bool get _isEditing => widget.crop != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop?.cropName ?? '');
    _descriptionController =
        TextEditingController(text: widget.crop?.cropDescription ?? '');
    _selectedCategoryId = widget.crop?.categoryId;
    _initialImagePath = widget.crop?.cropImage;

    _addCrop = sl.addCrop;
    _updateCrop = sl.updateCrop;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (_isLoading) return;
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _newImageFile = File(pickedFile.path);
          _initialImagePath = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.imagePickerError),
            backgroundColor: AppConstants.warningColor));
      }
    }
  }

  void _removeImage() {
    if (_isLoading) return;
    setState(() {
      _newImageFile = null;
      _initialImagePath = null;
    });
  }

  Future<void> _saveCrop() async {
    if (_isLoading) return;

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    if (_selectedCategoryId == null) {
      if (mounted) {
        setState(() {
          _errorMessage = AppLocalizations.of(context)!.pleaseSelectCategory;
          _isLoading = false;
        });
      }
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final String? finalImagePath = _newImageFile?.path ?? _initialImagePath;

      final cropData = Crop(
        cropId: widget.crop?.cropId,
        cropName: _nameController.text.trim(),
        cropDescription: _descriptionController.text.trim(),
        categoryId: _selectedCategoryId!,
        cropImage: finalImagePath,
      );

      try {
        final result =
            _isEditing ? await _updateCrop(cropData) : await _addCrop(cropData);

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() {
              _errorMessage = failure.getLocalizedMessage(context);
            });
          },
          (_) {
            _showSuccessAndPop();
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage =
                AppLocalizations.of(context)!.unexpectedError(e.toString());
          });
        }
      } finally {
        if (mounted) {
          setState(() {
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

  void _showSuccessAndPop() {
    final localizations = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.cropSavedSuccessfully),
        backgroundColor: AppConstants.successColor,
        duration: AppConstants.snackBarDuration,
      ),
    );
    Timer(AppConstants.snackBarDuration + const Duration(milliseconds: 100),
        () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final String title =
        _isEditing ? localizations.editCrop : localizations.addCrop;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Container(
        decoration: BoxDecoration(gradient: AppGradients.pageBackground),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: _CropForm(
            formKey: _formKey,
            nameController: _nameController,
            descriptionController: _descriptionController,
            selectedCategoryId: _selectedCategoryId,
            initialImagePath: _initialImagePath,
            newImageFile: _newImageFile,
            isLoading: _isLoading,
            errorMessage: _errorMessage,
            isEditing: _isEditing,
            onSavePressed: _saveCrop,
            onPickImagePressed: _pickImage,
            onRemoveImagePressed: _removeImage,
            onCategoryChanged: (value) {
              setState(() => _selectedCategoryId = value);
            },
          ),
        ),
      ),
    );
  }
}

class _CropForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final int? selectedCategoryId;
  final String? initialImagePath;
  final File? newImageFile;
  final bool isLoading;
  final String? errorMessage;
  final bool isEditing;

  final VoidCallback onSavePressed;
  final VoidCallback onPickImagePressed;
  final VoidCallback onRemoveImagePressed;
  final ValueChanged<int?> onCategoryChanged;

  const _CropForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.selectedCategoryId,
    this.initialImagePath,
    this.newImageFile,
    required this.isLoading,
    required this.errorMessage,
    required this.isEditing,
    required this.onSavePressed,
    required this.onPickImagePressed,
    required this.onRemoveImagePressed,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SingleImagePicker(
              key: const ValueKey('crop_image_picker'),
              initialImagePath: initialImagePath,
              selectedImageFile: newImageFile,
              onPickImage: onPickImagePressed,
              onRemoveImage: onRemoveImagePressed,
              enabled: !isLoading,
              radius: 60,
              placeholderAsset: AppConstants.defaultCropImagePath,
            ),
            const SizedBox(height: AppConstants.mediumPadding),
            AppTextField(
              controller: nameController,
              label: localizations.cropName,
              icon: AppConstants.cropIcon,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              validator: (value) => InputValidator.validateGenericRequiredField(
                localizations: localizations,
                value: value,
                emptyErrorMessageProvider: () =>
                    localizations.pleaseEnterCropName,
              ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            AppTextField(
              controller: descriptionController,
              label: localizations.description,
              icon: AppConstants.descriptionIcon,
              enabled: !isLoading,
              textInputAction: TextInputAction.next,
              maxLines: 3,
              minLines: 2,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            CategorySelectionDropdown(
              initialValue: selectedCategoryId,
              onChanged: onCategoryChanged,
              enabled: !isLoading,
              validator: (value) =>
                  value == null ? localizations.pleaseSelectCategory : null,
            ),
            const SizedBox(height: AppConstants.largePadding),
            ErrorMessage(message: errorMessage),
            if (errorMessage != null)
              const SizedBox(height: AppConstants.smallPadding),
            AppButton(
              text:
                  isEditing ? localizations.saveChanges : localizations.addCrop,
              onPressed: onSavePressed,
              isLoading: isLoading,
              enabled: !isLoading,
              icon: AppConstants.saveIcon,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
          ],
        ),
      ),
    );
  }
}
