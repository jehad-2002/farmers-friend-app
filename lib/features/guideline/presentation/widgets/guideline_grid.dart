import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/guideline/presentation/widgets/guideline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

typedef GuidelineCallback = void Function(Guideline guideline);

class CustomGuidelineGrid extends StatelessWidget {
  final List<GuidelineWithImages> guidelinesWithImages;
  final bool showAdminActions;
  final GuidelineCallback? onGuidelineTap;
  final GuidelineCallback? onEditTap;
  final GuidelineCallback? onDeleteTap;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const CustomGuidelineGrid({
    super.key,
    required this.guidelinesWithImages,
    required this.showAdminActions,
    this.onGuidelineTap,
    this.onEditTap,
    this.onDeleteTap,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return ErrorIndicator(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    if (guidelinesWithImages.isEmpty) {
      return EmptyListIndicator(
        message: localizations.noGuidelinesFound,
        icon: AppConstants.guidelineIcon,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding / 2,
        vertical: AppConstants.smallPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: AppConstants.defaultPadding / 2,
        mainAxisSpacing: AppConstants.defaultPadding / 2,
      ),
      itemCount: guidelinesWithImages.length,
      itemBuilder: (context, index) {
        final item = guidelinesWithImages[index];
        return GuidelineCard(
          key: ValueKey(item.guideline.guidanceId),
          guidelineWithImages: item,
          showAdminActions: showAdminActions,
          onTap: onGuidelineTap,
          onEditTap:
              onEditTap != null ? (guideline) => onEditTap!(guideline) : null,
          onDeleteConfirm: onDeleteTap,
        );
      },
    );
  }
}
