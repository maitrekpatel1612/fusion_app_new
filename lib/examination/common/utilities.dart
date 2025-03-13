// lib/examination/common/utilities.dart
import 'package:intl/intl.dart';

class Utilities {
  /// Formats a [DateTime] to a readable string.
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Capitalizes the first letter of a given string.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
