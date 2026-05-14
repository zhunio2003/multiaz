import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class AuthLayout extends StatelessWidget {

  final String title;
  final String? subtitle;
  final String? subtitleLink;
  final VoidCallback? subtitleLinkTap;
  final Widget child;

  const AuthLayout({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.subtitleLink,
    this.subtitleLinkTap
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              Text(
                title,
                style: AppTypography.h1.copyWith(color: AppColors.onBackground),
              ),
              subtitle != null ? Row(
                children: [
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(color: AppColors.onSurface),
                  ),
                  GestureDetector(
                    onTap: subtitleLinkTap,
                    child: Text(
                      subtitleLink!,
                      style: AppTypography.caption.copyWith(color: AppColors.primary),
                    ),
                  )
                ],
              ): SizedBox.shrink(),
              child,
            ],
          ),
        )
        ),
    );
  }


}