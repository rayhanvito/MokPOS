import 'package:intl/intl.dart';

import '../constants/app_strings.dart';

/// Currency formatter utilities for Indonesian Rupiah
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format number to Rupiah currency
  /// Example: 50000 -> "Rp 50.000"
  static String format(num amount, {bool withSymbol = true}) {
    final formatter = NumberFormat.currency(
      locale: AppStrings.currencyLocale,
      symbol: withSymbol ? '${AppStrings.currencySymbol} ' : '',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  /// Format number to compact Rupiah
  /// Example: 1500000 -> "Rp 1,5 Jt"
  static String formatCompact(num amount) {
    if (amount >= 1000000000) {
      return '${AppStrings.currencySymbol} ${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) {
      return '${AppStrings.currencySymbol} ${(amount / 1000000).toStringAsFixed(1)} Jt';
    } else if (amount >= 1000) {
      return '${AppStrings.currencySymbol} ${(amount / 1000).toStringAsFixed(1)} Rb';
    }
    return format(amount);
  }

  /// Parse Rupiah string to number
  /// Example: "Rp 50.000" -> 50000
  static num parse(String value) {
    final cleanValue = value
        .replaceAll(AppStrings.currencySymbol, '')
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();
    return num.tryParse(cleanValue) ?? 0;
  }

  /// Format as user types (for input fields)
  /// Example: "50000" -> "50.000"
  static String formatAsTyping(String value) {
    if (value.isEmpty) return '';

    final cleanValue = value.replaceAll('.', '');
    final number = num.tryParse(cleanValue);
    if (number == null) return value;

    final formatter = NumberFormat('#,###', AppStrings.currencyLocale);
    return formatter.format(number).replaceAll(',', '.');
  }
}
