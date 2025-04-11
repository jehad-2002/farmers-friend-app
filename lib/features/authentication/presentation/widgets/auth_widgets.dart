import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final double logoHeight;

  const AuthHeader({
    super.key,
    required this.title,
    this.logoHeight = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppConstants.logoPath,
          height: logoHeight,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16.0),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontSize: 26.0,
            fontWeight: FontWeight.w600,
            color: theme.hintColor,
            fontFamily: theme.textTheme.bodyMedium?.fontFamily,
          ),
        ),
      ],
    );
  }
}
