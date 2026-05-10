import 'package:intl/intl.dart';

/// Date formatter utilities for Indonesian locale
class DateFormatter {
  DateFormatter._();

  static const String _locale = 'id_ID';

  /// Format date to Indonesian format
  /// Example: "10 Mei 2026"
  static String formatDate(DateTime date) {
    return DateFormat('d MMMM yyyy', _locale).format(date);
  }

  /// Format date with day name
  /// Example: "Minggu, 10 Mei 2026"
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy', _locale).format(date);
  }

  /// Format time only
  /// Example: "14:30"
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm', _locale).format(date);
  }

  /// Format date and time
  /// Example: "10 Mei 2026, 14:30"
  static String formatDateTime(DateTime date) {
    return DateFormat('d MMMM yyyy, HH:mm', _locale).format(date);
  }

  /// Format date short
  /// Example: "10/05/2026"
  static String formatDateShort(DateTime date) {
    return DateFormat('dd/MM/yyyy', _locale).format(date);
  }

  /// Format relative time
  /// Example: "2 jam yang lalu", "Kemarin", "Hari ini"
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Baru saja';
        }
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks minggu yang lalu';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months bulan yang lalu';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years tahun yang lalu';
    }
  }

  /// Get greeting based on time
  /// Example: "Selamat pagi", "Selamat siang", etc.
  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Selamat pagi';
    } else if (hour < 15) {
      return 'Selamat siang';
    } else if (hour < 18) {
      return 'Selamat sore';
    } else {
      return 'Selamat malam';
    }
  }

  /// Format month and year
  /// Example: "Mei 2026"
  static String formatMonthYear(DateTime date) {
    return DateFormat('MMMM yyyy', _locale).format(date);
  }

  /// Format for transaction ID
  /// Example: "20260510143045"
  static String formatForTransactionId(DateTime date) {
    return DateFormat('yyyyMMddHHmmss').format(date);
  }
}
