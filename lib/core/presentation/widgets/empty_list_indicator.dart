import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmptyListIndicator extends StatelessWidget {
  final String? message;
  final IconData? icon;
  final Widget? action;

  const EmptyListIndicator({
    super.key,
    this.message,
    this.icon = Icons.inventory_2_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 60,
                color: AppConstants.brownColor,
              ),
              const SizedBox(height: AppConstants.defaultPadding),
            ],
            Text(
              message ?? localizations.noData,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppConstants.textColorSecondary.withOpacity(0.8),
                  fontFamily: AppConstants.defaultFontFamily),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: AppConstants.mediumPadding),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

