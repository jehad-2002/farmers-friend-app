import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_image.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/image_gallery.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGuidelineData();
  }

  Future<void> _loadGuidelineData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final guideline = await sl.guidelineLocalDataSource
          .getGuidelinesWithImagesByUserId(widget.guidelineId);
      if (mounted) {
        setState(() {
          _guideline = guideline.first.guideline;
          _images = guideline.first.images;
          _isLoading = false;
        });
      } else {
        if (mounted) {
          setState(() {
            _errorMessage = 'Guideline not found';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              "${AppLocalizations.of(context)!.errorLoadingData}: $e";
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
        backgroundColor: theme.colorScheme.primary,
        iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
      ),
      body: _isLoading
          ? const Center(
              child: LoadingIndicator(),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                )
              : _guideline == null
                  ? Center(
                      child: Text(
                        localizations.guidelineNotFound(_errorMessage ?? ''),
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_images.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: ImageGallery(images: _images),
                            )
                          else
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      color: theme.iconTheme.color?.withOpacity(0.6),
                                      size: 40,
                                    ),
                                    Text(
                                      localizations.noImagesAvailable,
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          const SizedBox(height: AppConstants.defaultPadding),
                          Text(
                            _guideline!.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.smallPadding),
                          if (_guideline!.publicationDate != null &&
                              _guideline!.publicationDate!.isNotEmpty)
                            Text(
                              '${localizations.publicationDate}: ${AppDateUtils.formatSimpleDate(context, _guideline!.publicationDate!)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                              ),
                            ),
                          if (_guideline!.publicationDate != null &&
                              _guideline!.publicationDate!.isNotEmpty)
                            const SizedBox(height: AppConstants.defaultPadding),
                          Text(
                            _guideline!.guidanceText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
