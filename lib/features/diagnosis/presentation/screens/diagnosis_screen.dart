import 'dart:io';
import 'package:farmersfriendapp/core/presentation/widgets/app_button.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart'; // To get the use case via sl
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/diagnosis/domain/usecases/diagnose_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // For localization

// Enum to represent the different states of the screen's UI
enum DiagnosisScreenStatus { initial, imageSelected, loading, success, error }

class DiagnosisScreen extends StatefulWidget {
  const DiagnosisScreen({super.key});

  @override
  State<DiagnosisScreen> createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  // --- State Variables ---
  File? _imageFile; // Holds the selected image file
  DiagnosisScreenStatus _status =
      DiagnosisScreenStatus.initial; // Current UI status
  String? _diagnosisResult; // Stores the success result string
  String? _errorMessage; // Stores the error message string

  // --- Dependencies ---
  // Get the use case instance from the Service Locator
  late final DiagnoseImage _diagnoseImageUseCase;

  @override
  void initState() {
    super.initState();
    // Retrieve the use case from the Service Locator (sl)
    _diagnoseImageUseCase = sl.diagnoseImage;
  }

  // --- UI Logic Methods ---

  /// Picks an image from the specified source (gallery or camera).
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        // Optional: Adjust image quality/size during picking
        // imageQuality: 80,
        // maxHeight: 1024,
        // maxWidth: 1024,
      );

      if (pickedFile != null) {
        // Update state if an image was successfully picked
        setState(() {
          _imageFile = File(pickedFile.path);
          _status = DiagnosisScreenStatus.imageSelected; // Ready for diagnosis
          _diagnosisResult = null; // Clear previous results
          _errorMessage = null; // Clear previous errors
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      if (mounted) {
        // Show error if image picking fails
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _status = DiagnosisScreenStatus.error;
          // Use a specific localization key for image picking errors
          _errorMessage = localizations.errorPickingImage;
        });
      }
    }
  }

  /// Shows a bottom sheet to choose between camera and gallery.
  void _showImageSourceActionSheet() {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        // Optional styling
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadiusMedium)),
      ),
      builder: (BuildContext ctx) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(localizations.chooseFromGallery),
                  onTap: () {
                    Navigator.of(ctx).pop(); // Close the bottom sheet
                    _pickImage(ImageSource.gallery);
                  }),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(localizations.takePhoto),
                onTap: () {
                  Navigator.of(ctx).pop(); // Close the bottom sheet
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Runs the diagnosis process using the selected image file.
  Future<void> _runDiagnosis() async {
    // Ensure an image is selected and we are not already loading
    if (_imageFile == null || _status == DiagnosisScreenStatus.loading) return;

    // Update UI to show loading state
    setState(() {
      _status = DiagnosisScreenStatus.loading;
      _errorMessage = null;
      _diagnosisResult = null;
    });

    // Execute the diagnosis use case
    final result = await _diagnoseImageUseCase(_imageFile!);

    // Check if the widget is still mounted before updating state
    if (!mounted) return;

    // Process the result (Either Failure or Success)
    result.fold(
      (failure) {
        // Handle Failure case
        setState(() {
          _status = DiagnosisScreenStatus.error;
          _errorMessage =
              failure.getLocalizedMessage(context); // Get localized error
        });
      },
      (diagnosisResult) {
        // Handle Success case
        setState(() {
          _status = DiagnosisScreenStatus.success;
          _diagnosisResult = diagnosisResult; // Store the result
        });
      },
    );
  }

  /// Resets the state to its initial values.
  void _clearState() {
    setState(() {
      _imageFile = null;
      _status = DiagnosisScreenStatus.initial;
      _diagnosisResult = null;
      _errorMessage = null;
    });
  }

  // --- Build Method ---

  @override
  Widget build(BuildContext context) {
    // Get localization instance for easy access in build methods
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      // Use localized title
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Image Display/Selection Area
            Expanded(
              flex: 3, // Takes more vertical space
              child: Container(
                alignment: Alignment.center, // Center content
                padding: const EdgeInsets.all(AppConstants.smallPadding),
                decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.3),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(
                        color: AppConstants.primaryColor.withOpacity(0.5))),
                child:
                    _buildImageArea(localizations), // Delegate to helper method
              ),
            ),
            const SizedBox(height: AppConstants.mediumPadding),

            // 2. Result/Loading/Error Display Area
            Expanded(
                flex: 2, // Takes less vertical space than image
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(AppConstants.smallPadding),
                  child: _buildResultArea(
                      localizations), // Delegate to helper method
                )),
            const SizedBox(height: AppConstants.mediumPadding),

            // 3. Action Buttons Area
            _buildActionButtons(localizations), // Delegate to helper method
          ],
        ),
      ),
    );
  }

  // --- Helper Build Methods ---

  /// Builds the widget for the image display area based on the current state.
  Widget _buildImageArea(AppLocalizations localizations) {
    if (_imageFile != null) {
      // Display the selected image
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium -
            AppConstants.smallPadding), // Adjust for container padding
        child: Image.file(
          _imageFile!,
          fit: BoxFit.contain, // Fit image within the container
          errorBuilder: (context, error, stackTrace) {
            // Optional: Handle image loading errors specifically
            return Center(child: Text(localizations.errorLoadingImage));
          },
        ),
      );
    } else {
      // Show placeholder and button to choose an image
      return SingleChildScrollView(
        // Allow scrolling if content overflows
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search_outlined,
                size: 70,
                color: AppConstants.primaryColorDark.withOpacity(0.6)),
            const SizedBox(height: AppConstants.defaultPadding),
            Text(localizations.selectImageForDiagnosis,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: AppConstants.textColorSecondary)),
            const SizedBox(height: AppConstants.mediumPadding),
            AppButton(
              minWidth: 220, // Adjust width as needed
              text: localizations.chooseImage,
              icon: Icons.add_photo_alternate_outlined,
              onPressed:
                  _showImageSourceActionSheet, // Trigger image source selection
            )
          ],
        ),
      );
    }
  }

  /// Builds the widget for the result display area based on the current status.
  Widget _buildResultArea(AppLocalizations localizations) {
    switch (_status) {
      case DiagnosisScreenStatus.loading:
        return const LoadingIndicator(
            isCentered: true); // Show loading indicator

      case DiagnosisScreenStatus.success:
        // Display the successful diagnosis result
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.diagnosisResult,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppConstants.primaryColorDark)),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              _diagnosisResult ??
                  localizations.unknown, // Show result or "Unknown"
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: AppConstants.brownColor),
              textAlign: TextAlign.center,
            ),
          ],
        );

      case DiagnosisScreenStatus.error:
        // Display error icon and message
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(AppConstants.errorOutlineIcon,
                  color: AppConstants.errorColor, size: 45),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                localizations.errorOccurred, // Generic error title
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppConstants.errorColor,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppConstants.smallPadding / 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.smallPadding),
                  child: Text(
                    _errorMessage!, // Show detailed error message
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.errorColor.withOpacity(0.9)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ]
            ],
          ),
        );

      case DiagnosisScreenStatus.initial:
        // Initial state message
        return Text(localizations.noImageSelectedYet,
            style: TextStyle(color: AppConstants.textColorSecondary));

      case DiagnosisScreenStatus.imageSelected:
        // Message shown after image is selected but before diagnosis starts
        return Text(localizations.readyToDiagnose,
            style: TextStyle(
                color: AppConstants.textColorSecondary, fontSize: 16));
    }
  }

  /// Builds the action buttons at the bottom based on the current state.
  Widget _buildActionButtons(AppLocalizations localizations) {
    // Determine if the "Start Diagnosis" button should be enabled
    bool canDiagnose =
        _imageFile != null && _status != DiagnosisScreenStatus.loading;
    // Determine if the "Clear" or "Diagnose Another" button should be shown
    bool showClearButton = _imageFile != null ||
        _status == DiagnosisScreenStatus.error ||
        _status == DiagnosisScreenStatus.success;

    return Column(
      mainAxisSize: MainAxisSize.min, // Take minimum vertical space
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Stretch buttons horizontally
      children: [
        // "Start Diagnosis" Button
        AppButton(
          text: localizations.startDiagnosis,
          onPressed: canDiagnose
              ? _runDiagnosis
              : () {}, // Provide an empty callback for null case
          isLoading: _status ==
              DiagnosisScreenStatus.loading, // Show loading indicator inside
          icon: Icons.biotech_outlined, // Relevant icon
        ),

        // "Clear" / "Diagnose Another" Button (conditionally shown)
        // Use Visibility for cleaner conditional rendering
        Visibility(
          visible: showClearButton,
          child: Padding(
            padding: const EdgeInsets.only(
                top: AppConstants.smallPadding), // Add space above
            child: TextButton(
              onPressed: _clearState, // Reset the screen state
              child: Text(
                // Change button text based on whether diagnosis was successful
                _status == DiagnosisScreenStatus.success
                    ? localizations.diagnoseAnotherImage
                    : localizations.clear,
                style: TextStyle(
                    color: AppConstants.primaryColorDark, fontSize: 15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
