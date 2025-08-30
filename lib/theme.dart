// lib/theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primary = Color(0xFF161D32);
  static const loginGreen = Color(0xFF39EF8C);
  static const signupGreen = Color(0xFF39EF8C);
  static const black = Color(0xFF0B0D0F);
  static const grey = Color(0xFF8D9AA8);
}

class AppTextStyles {
  static final headline = GoogleFonts.interTight(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static final label = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static final body = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    height: 2,
  );
}

class AppInputDecoration {
  static InputDecoration textField({
    required String hint,
    bool showPasswordToggle = false,
    bool passwordVisible = false,
    VoidCallback? onTogglePassword,
    Widget? suffix,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hint,
      hintStyle: GoogleFonts.roboto(fontSize: 18, color: AppColors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(24),
      ),
      filled: true,
      fillColor: Colors.white,
      suffixIcon: showPasswordToggle
          ? InkWell(
        onTap: onTogglePassword,
        child: Icon(
          passwordVisible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          size: 24,
          color: AppColors.grey,
        ),
      )
          : suffix,
    );
  }
}
