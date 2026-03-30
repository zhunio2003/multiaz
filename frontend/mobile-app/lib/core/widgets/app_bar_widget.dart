import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{

  final String title;

  const AppBarWidget({
    super.key,
    required this.title,
  });
  
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.surface,
      titleTextStyle: AppTypography.h6,
    );
  }
  

}