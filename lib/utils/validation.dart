import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Validation {
  // Phone number regex (basic international format)
  static final RegExp phoneRegex = RegExp(
    r'^\+?1?[-.\s]?\(?[1-9]\d{2}\)?[-.\s]?\d{3}[-.\s]?\d{4}$',
  );

  static String? validateName(String? value, String? fieldName) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName field can't be empty.";
    }
    return null; // ✅ Valid name
  }

  /// Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email field can't be empty.";
    }

    // Basic email regex pattern
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      // You can differentiate between invalid formats and obviously wrong input
      if (!value.contains('@') || !value.contains('.')) {
        return "Please enter valid email address.";
      }
      return "You have enter invalid email address.";
    }

    return null; // ✅ Valid email
  }

  /// Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password field can't be empty.";
    }

    if (value.length < 8) {
      return "The password must be at least 8 characters.";
    }

    // Regex: at least 1 upper, 1 lower, 1 digit, 1 special char
    final passwordRegex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );

    if (!passwordRegex.hasMatch(value)) {
      return "Password must be at least 8 characters long and contain at least 1 uppercase, 1 lowercase, 1 digit and 1 special character.";
    }

    return null; // ✅ Valid password
  }

  /// Confirm Password Validation
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    debugPrint(originalPassword);
    if (value == null || value.trim().isEmpty) {
      return "Confirm password field can't be empty.";
    }

    if (value.length != originalPassword?.length) {
      debugPrint("password don't match");
      return "Both passwords must be same.";
    }

    return null; // ✅ Passwords match
  }

  static String? validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "OTP field can't be empty.";
    }

    // Remove any spaces from the input
    final trimmedValue = value.trim();

    if (value.trim() != "123456") {
      return "Invalid OTP verification code.";
    }

    // Check if OTP contains exactly 6 digits
    if (trimmedValue.length != 6) {
      return "OTP must be 6 numbers.";
    }

    // Check if OTP contains only numbers
    final digitRegex = RegExp(r'^[0-9]+$');
    if (!digitRegex.hasMatch(trimmedValue)) {
      return "OTP must contain only numbers.";
    }

    return null; // ✅ Valid OTP
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number field can't be empty.";
    }

    if (!phoneRegex.hasMatch(value)) {
      return "Please enter a valid phone number.";
    }

    return null;
  }

  static String extractDigits(String formattedPhone) {
    return formattedPhone.replaceAll(RegExp(r'[^\d]'), '');
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }
}

class USPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;
    final oldText = oldValue.text;

    // If backspace is pressed, allow deletion
    if (newText.length < oldText.length) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newText.replaceAll(RegExp(r'[^\d]'), '');

    // If empty, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '+1(',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    // Limit to 11 digits (1 country code + 10 phone digits)
    if (digitsOnly.length > 11) {
      return oldValue;
    }

    // Format the phone number
    String formatted = '+1(';

    if (digitsOnly.length > 1) {
      formatted += digitsOnly.substring(
        1,
        digitsOnly.length > 4 ? 4 : digitsOnly.length,
      );
    }

    if (digitsOnly.length > 4) {
      formatted +=
          ') ${digitsOnly.substring(4, digitsOnly.length > 7 ? 7 : digitsOnly.length)}';
    }

    if (digitsOnly.length > 7) {
      formatted += '-${digitsOnly.substring(7)}';
    }

    // Calculate cursor position
    int cursorPosition = formatted.length;

    // Adjust cursor position based on input
    if (newText.endsWith(')') ||
        newText.endsWith(' ') ||
        newText.endsWith('-')) {
      cursorPosition = newValue.selection.end;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
