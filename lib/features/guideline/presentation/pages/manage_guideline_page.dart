import 'dart:async';
import 'dart:io';

import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/app_text_field.dart';
import 'package:farmersfriendapp/core/presentation/widgets/crop_selection_dropdown.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_message.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/multi_image_picker.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/validators/input_validator.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/add_guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/add_guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/delete_guideline_image.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guideline_images.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/update_guideline.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageGuidelinePage extends StatefulWidget {
  final Guideline? guideline;

  const ManageGuidelinePage({Key? key, this.guideline}) : super(key: key);

  @override
  State<ManageGuidelinePage> createState() => _ManageGuidelinePageState();
}

class _ManageGuidelinePageState extends State<ManageGuidelinePage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  int? _selectedCropId;
  List<GuidelineImage> _existingImages = [];
  final List<File> _newImageFiles = [];
  final List<GuidelineImage> _imagesToRemove = [];
  int? _currentUserId;

  bool _isLoadingData = true;
  bool _isSaving = false;
  String? _pageError;
  String? _saveError;

  late final AddGuideline _addguideline;
  late final UpdateGuideline _updateguideline;
  late final GetGuidelineImages _getguidelineImages;
  late final AddGuidelineImage _addguidelineImage;
  late final DeleteGuidelineImage _deleteguidelineImage;

  bool get _isEditing => widget.guideline != null;

  @override
  void initState() {
    super.initState();
    _resolveUseCases();
    _initializeControllers();
    _loadInitialData();
  }

  void _resolveUseCases() {
    _addguideline = sl.addGuideline;
    _updateguideline = sl.updateGuideline;
    _getguidelineImages = sl.getGuidelineImages;
    _addguidelineImage = sl.addGuidelineImage;
    _deleteguidelineImage = sl.deleteGuidelineImage;
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.guideline?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.guideline?.guidanceText ?? '');
    _selectedCropId = widget.guideline?.cropId;
    _existingImages.clear();
    _newImageFiles.clear();
    _imagesToRemove.clear();
  }

  Future<void> _loadInitialData() async {
    if (!_isLoadingData) setState(() => _isLoadingData = true);
    _pageError = null;

    try {
      _currentUserId = await sl.authLocalDataSource.getUserId();
      if (_currentUserId == null && mounted) {
        throw Exception(AppLocalizations.of(context)!.userNotLoggedIn);
      }

      if (_isEditing && widget.guideline!.guidanceId != null) {
        final imagesResult =
            await _getguidelineImages(widget.guideline!.guidanceId!);
        if (!mounted) return;
        imagesResult.fold(
          (f) => throw f,
          (images) => _existingImages = images.cast<GuidelineImage>(),
        );
      }

      if (mounted) setState(() => _isLoadingData = false);
    } on Failure catch (f) {
      if (mounted) {
        setState(() {
          _pageError = f.getLocalizedMessage(context);
          _isLoadingData = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _pageError = AppLocalizations.of(context)!.errorLoadingData;
          _isLoadingData = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleNewFilesAdded(List<File> files) {
    setState(() {
      _newImageFiles.addAll(files);
    });
  }

  void _handleExistingImageRemoved(dynamic existingImageSource) {
    if (existingImageSource is GuidelineImage) {
      setState(() {
        _existingImages
            .removeWhere((img) => img.imageGuidelineId == existingImageSource.imageGuidelineId);
        if (existingImageSource.imageGuidelineId != null &&
            !_imagesToRemove
                .any((img) => img.imageGuidelineId == existingImageSource.imageGuidelineId)) {
          _imagesToRemove.add(existingImageSource);
        }
      });
    }
  }

  void _handleNewFileRemoved(File file) {
    setState(() {
      _newImageFiles.removeWhere((f) => f.path == file.path);
    });
  }

  Future<void> _saveguidance() async {
    if (_isLoadingData || _isSaving) return;
    setState(() => _saveError = null);

    if (_currentUserId == null) {
      if (mounted) {
        _handleSaveError(AppLocalizations.of(context)!.userNotLoggedIn);
      }
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCropId == null) {
      if (mounted) {
        _handleSaveError(AppLocalizations.of(context)!.pleaseSelectCrop);
      }
      return;
    }

    setState(() => _isSaving = true);

    final guidanceData = Guideline(
      guidanceId: widget.guideline?.guidanceId,
      userId: _currentUserId!,
      title: _titleController.text.trim(),
      guidanceText: _descriptionController.text.trim(),
      cropId: _selectedCropId!,
      publicationDate:
          widget.guideline?.publicationDate ?? AppConstants.getCurrentDateFormatted(),
    );

    try {
      final guidanceResult = _isEditing
          ? await _updateguideline(guidanceData)
          : await _addguideline(guidanceData);
      await guidanceResult.fold((f) async => throw f, (savedguidance) async {
        if (savedguidance.guidanceId == null) throw Exception("Saved ID null");
        List<Future> ops = [];
        if (_newImageFiles.isNotEmpty) {
          ops.add(_uploadNewImages(savedguidance.guidanceId!));
        }
        if (_imagesToRemove.isNotEmpty) ops.add(_deleteMarkedImages());
        if (ops.isNotEmpty) await Future.wait(ops);
        _newImageFiles.clear();
        _imagesToRemove.clear();
        if (mounted) _showSuccessAndPop();
        return Future.value();
      });
    } on Failure catch (f) {
      if (mounted) _handleSaveError(f.getLocalizedMessage(context));
    } catch (e) {
      if (mounted) {
        _handleSaveError(
            "${AppLocalizations.of(context)!.unexpectedError}: $e");
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _uploadNewImages(int guidanceId) async {
    List<String> fails = [];
    final futures = _newImageFiles.map((f) async {
      try {
        await _addguidelineImage(
                GuidelineImage(guidanceId: guidanceId, imagePath: f.path))
            .then((r) =>
                r.fold((f) => fails.add(f.message.split('/').last), (_) {}));
      } catch (e) {
        fails.add(f.path.split('/').last);
      }
    }).toList();
    await Future.wait(futures);
    if (fails.isNotEmpty && mounted) {
      final m =
          "${AppLocalizations.of(context)!.imageUploadFailedWarning}: ${fails.join(', ')}";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(m), backgroundColor: AppConstants.warningColor));
          setState(() => _saveError = "${_saveError ?? ''}\n$m".trim());
        }
      });
    }
  }

  Future<void> _deleteMarkedImages() async {
    List<String> fails = [];
    final futures =
        _imagesToRemove.where((i) => i.imageGuidelineId != null).map((i) async {
      try {
        await _deleteguidelineImage(i.imageGuidelineId!).then(
            (r) => r.fold((f) => fails.add(i.imageGuidelineId.toString()), (_) {}));
      } catch (e) {
        fails.add(i.imageGuidelineId.toString());
      }
    }).toList();
    await Future.wait(futures);
    if (fails.isNotEmpty && mounted) {
      final m =
          "${AppLocalizations.of(context)!.imageDeletionError} (IDs: ${fails.join(', ')})";
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(m), backgroundColor: AppConstants.errorColor));
          setState(() => _saveError = "${_saveError ?? ''}\n$m".trim());
        }
      });
    }
  }

  void _handleSaveError(String message) {
    if (mounted) setState(() => _saveError = message);
  }

  void _showSuccessAndPop() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.productSavedSuccessfully),
        backgroundColor: AppConstants.successColor,
        duration: AppConstants.snackBarDuration));
    Timer(AppConstants.snackBarDuration + const Duration(milliseconds: 100),
        () {
      if (mounted) Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final title =
        _isEditing ? localizations.editProduct : localizations.addGuideline;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.secondary.withOpacity(0.7),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: _buildBody(localizations),
      ),
    );
  }

  Widget _buildBody(AppLocalizations localizations) {
    if (_isLoadingData) return const LoadingIndicator(isCentered: true);

    String? initialError = _pageError ?? 
        (_currentUserId == null ? localizations.userNotLoggedIn : null);
    if (initialError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ErrorMessage(message: initialError),
              const SizedBox(height: AppConstants.mediumPadding),
              if (_currentUserId != null)
                AppButton(
                  text: localizations.retry,
                  onPressed: _loadInitialData,
                ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildguidelineFormFields(context, localizations),
              const SizedBox(height: AppConstants.defaultPadding),
              MultiImagePicker(
                key: ValueKey('guideline${widget.guideline?.guidanceId}_images'),
                initialExistingImages: _existingImages,
                newlySelectedFiles: _newImageFiles,
                onNewFilesAdded: _handleNewFilesAdded,
                onExistingImageRemoved: _handleExistingImageRemoved,
                onNewFileRemoved: _handleNewFileRemoved,
                enabled: !_isSaving,
                maxImages: 5,
                itemBuilder: (context, imageSource, isExisting) {
                  ImageProvider imageProvider;
                  try {
                    if (isExisting && imageSource is GuidelineImage) {
                      imageProvider = FileImage(File(imageSource.imagePath));
                    } else if (!isExisting && imageSource is File) {
                      imageProvider = FileImage(imageSource);
                    } else {
                      throw '_';
                    }
                  } catch (e) {
                    imageProvider =
                        const AssetImage(AppConstants.defaultguidelineImagePath);
                  }
                  return Image(image: imageProvider, fit: BoxFit.cover);
                },
              ),
              const SizedBox(height: AppConstants.largePadding),
              ErrorMessage(message: _saveError),
              if (_saveError != null)
                const SizedBox(height: AppConstants.smallPadding),
              AppButton(
                text: _isSaving
                    ? localizations.saving
                    : (_isEditing
                        ? localizations.saveChanges
                        : localizations.addGuideline),
                onPressed: _saveguidance,
                isLoading: _isSaving,
                enabled: !_isSaving,
                icon: AppConstants.saveIcon,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildguidelineFormFields(
      BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _titleController,
          label: localizations.productTitle,
          icon: AppConstants.titleIcon,
          enabled: !_isSaving,
          textInputAction: TextInputAction.next,
          validator: (v) => InputValidator.validateGenericRequiredField(
            localizations: localizations,
            value: v,
            emptyErrorMessageProvider: () => localizations.pleaseEnterTitle,
          ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        AppTextField(
          controller: _descriptionController,
          label: localizations.description,
          icon: AppConstants.descriptionIcon,
          enabled: !_isSaving,
          textInputAction: TextInputAction.next,
          maxLines: 3,
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        CropSelectionDropdown(
          initialValue: _selectedCropId,
          enabled: !_isSaving,
          onChanged: (value) {
            if (!_isSaving) setState(() => _selectedCropId = value);
          },
          validator: (v) => v == null ? localizations.pleaseSelectCrop : null,
        ),
      ],
    );
  }
}
