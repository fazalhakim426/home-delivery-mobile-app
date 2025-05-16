// app_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Text Styles
  static const TextStyle inputLabelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle dropdownItemStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle hintTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.red,
  );

  static const TextStyle dangerTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.red,
  );

  static const TextStyle chipTextStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // Button Styles
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 0,
    shadowColor: Colors.transparent,
    textStyle: buttonTextStyle,
  );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    side: BorderSide(
      color: Colors.grey[300]!,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    textStyle: buttonTextStyle,
  );
  // Text Styles
  static const TextStyle grayText1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.gray700,
  );

  // Button Styles
  static ButtonStyle get outlinedButtonStyle => OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 18),
    side: BorderSide(
      color: Colors.grey[400]!,
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: Colors.grey[50],
    elevation: 1,
    shadowColor: Colors.grey.withOpacity(0.1),
  );

  // You can also create variations
  static ButtonStyle get primaryOutlinedButtonStyle => OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 18),
    side: BorderSide(
      color: AppColors.primary, // Use your primary color
      width: 1.5,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    backgroundColor: AppColors.primary.withOpacity(0.1),
    elevation: 1,
    shadowColor: AppColors.primary.withOpacity(0.1),
  );
}