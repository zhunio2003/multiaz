import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class SecondaryButton extends StatelessWidget {
  
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.secondary),
        foregroundColor: AppColors.secondary,
        textStyle: AppTypography.button
      ),
      onPressed: onPressed, 
      child: isLoading?
        CircularProgressIndicator():
        Text(label)
    );

  }

}