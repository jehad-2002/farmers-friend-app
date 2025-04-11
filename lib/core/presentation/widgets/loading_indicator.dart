import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingIndicator extends StatelessWidget {
  final String? text;
  final bool isCentered;

  const LoadingIndicator({super.key, this.text, this.isCentered = false});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final loadingText = text ?? localizations.loading;

    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
            color: theme.textTheme.bodyMedium?.color, // Use theme's bodyMedium color
        ),
        const SizedBox(height: 12),
        Text(
          loadingText,
          style: TextStyle(
            fontFamily: AppConstants.defaultFontFamily, // Use AppConstants font
            color: theme.textTheme.bodyMedium?.color, // Use theme's bodyMedium color
            fontSize: 14,
          ),
        ),
      ],
    );

    if (isCentered) {
      return Center(child: content);
    }
    return content;
  }
}

