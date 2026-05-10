import '../constants/app_strings.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Validate required field
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName ${AppStrings.fieldRequired.toLowerCase()}'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  /// Validate Indonesian phone number
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    // Remove spaces and dashes
    final cleanValue = value.replaceAll(RegExp(r'[\s-]'), '');

    // Must start with 08 or +628
    if (!cleanValue.startsWith('08') && !cleanValue.startsWith('+628')) {
      return AppStrings.invalidPhone;
    }

    // Must be 10-13 digits
    if (cleanValue.length < 10 || cleanValue.length > 13) {
      return AppStrings.invalidPhone;
    }

    return null;
  }

  /// Validate password strength
  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value != password) {
      return AppStrings.passwordNotMatch;
    }

    return null;
  }

  /// Validate PIN (numeric only)
  static String? pin(String? value, {int length = 6}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length != length) {
      return 'PIN harus $length digit';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'PIN harus berupa angka';
    }

    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (num.tryParse(value) == null) {
      return fieldName != null
          ? '$fieldName harus berupa angka'
          : 'Harus berupa angka';
    }

    return null;
  }

  /// Validate minimum value
  static String? minValue(String? value, num min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Harus berupa angka';
    }

    if (number < min) {
      return fieldName != null
          ? '$fieldName minimal $min'
          : 'Nilai minimal $min';
    }

    return null;
  }

  /// Validate maximum value
  static String? maxValue(String? value, num max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Harus berupa angka';
    }

    if (number > max) {
      return fieldName != null
          ? '$fieldName maksimal $max'
          : 'Nilai maksimal $max';
    }

    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int min, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < min) {
      return fieldName != null
          ? '$fieldName minimal $min karakter'
          : 'Minimal $min karakter';
    }

    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int max, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length > max) {
      return fieldName != null
          ? '$fieldName maksimal $max karakter'
          : 'Maksimal $max karakter';
    }

    return null;
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
