import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/presentation/theme/app_styles.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/image_gallery.dart'; // Use the ImageGallery
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuidelineDetailPage extends StatefulWidget {
  final int guidelineId;

  const GuidelineDetailPage({Key? key, required this.guidelineId})
      : super(key: key);

  @override
  State<GuidelineDetailPage> createState() => _GuidelineDetailPageState();
}

class _GuidelineDetailPageState extends State<GuidelineDetailPage> {
  Guideline? _guideline;
  List<GuidelineImage> _images = [];
  String? _errorMessage;
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    _loadGuidelineData();
  }

  Future<void> _loadGuidelineData() async {
    setState(() {
      _isLoading = true; // Set loading to true
      _errorMessage = null;
    });

    try {
      final guideline = await sl.guidelineLocalDataSource
          .getGuidelinesWithImagesByUserId(
              widget.guidelineId); // Changed to getGuidelineById
      if (mounted) {
        setState(() {
          _guideline = guideline.first.guideline;
          _images = guideline.first.images;
          _isLoading = false; // Set loading to false
        });
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Guideline not found'; // Use localized string
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              "${AppLocalizations.of(context)!.errorLoadingData}: $e"; // Use localized string
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.guidelineDetails,
        backgroundColor:
            AppConstants.primaryColorDark, // Consistent app bar style
        iconTheme: IconThemeData(color: AppConstants.textOnPrimary),
      ),
      body: _isLoading // Check loading status
          ? const Center(
              child: LoadingIndicator(), // Use loading indicator
            )
          : _errorMessage != null
              ? Center(
                  child: Text(_errorMessage!), // Show Error
                )
              : _guideline == null
                  ? const Center(
                      child: Text('Guideline not found'), // Fallback
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(
                          AppConstants.defaultPadding), // Add padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Image Gallery (Using the ImageGallery widget)---
                          if (_images.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0), // Add spacing
                              child: ImageGallery(images: _images),
                            )
                          else
                            Container(
                              height: 200, // Or a more appropriate height
                              decoration: BoxDecoration(
                                color: AppConstants.greyColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants
                                    .borderRadiusMedium), // Add rounded corners
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      color: AppConstants.greyColor,
                                      size: 40,
                                    ),
                                    Text(
                                      localizations.noImagesAvailable,
                                      style: TextStyle(
                                          color:
                                              AppConstants.textColorSecondary,
                                          fontFamily:
                                              AppConstants.defaultFontFamily),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(
                              height: AppConstants.defaultPadding), // Add space
                          // --- Title ---
                          Text(
                            _guideline!.title,
                            style: AppStyles
                                .sectionHeader, // Use a section header style
                          ),
                          const SizedBox(height: AppConstants.smallPadding),

                          // --- Publication Date ---
                          if (_guideline!.publicationDate != null &&
                              _guideline!.publicationDate!.isNotEmpty)
                            Text(
                              '${localizations.noWeatherData}: ${AppDateUtils.formatSimpleDate(context, _guideline!.publicationDate!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppConstants.textColorSecondary,
                                  fontFamily: AppConstants.defaultFontFamily),
                            ),
                          if (_guideline!.publicationDate != null &&
                              _guideline!.publicationDate!.isNotEmpty)
                            const SizedBox(height: AppConstants.defaultPadding),

                          // --- Guideline Text ---
                          Text(
                            _guideline!.guidanceText,
                            style: AppStyles.descriptionBody,
                          ),
                        ],
                      ),
                    ),
    );
  }
}
