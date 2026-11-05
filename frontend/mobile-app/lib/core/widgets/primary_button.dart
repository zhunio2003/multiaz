import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors_dark.dart';
import 'package:mobile_app/core/theme/app_typography.dart';


class PrimaryButton extends StatelessWidget{

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark  .primary,
        foregroundColor: AppColorsDark.onPrimary,
        textStyle: AppTypography.button,
        minimumSize: Size(double.infinity, 60)
      ), 
      child: isLoading? 
      CircularProgressIndicator(): 
      Text(label),
      );
      
  }  
}