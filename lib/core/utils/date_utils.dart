// lib/core/utils/app_date_utils.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppDateUtils {
  static String formatSimpleDate(BuildContext context, String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return AppLocalizations.of(context)!.notAvailable;
    }
    try {
      final DateTime date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context).languageCode;
      return DateFormat.yMMMd(locale).format(date);
    } catch (e) {
      return AppLocalizations.of(context)!.invalidDate;
    }
  }
}
