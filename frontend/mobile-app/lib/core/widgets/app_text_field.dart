import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class AppTextField extends StatelessWidget{

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });


  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        errorText: errorText,
        floatingLabelStyle: AppTypography.body.copyWith(color: AppColors.primary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 23),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.primary) 
        ),
      ),
    );
  }

  
}