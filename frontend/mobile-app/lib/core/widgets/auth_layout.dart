import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/core/theme/app_colors_dark.dart';
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
      backgroundColor: AppColorsDark.background,
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSpacing.lg,),
              Image.asset(
                'assets/images/logo.png',
                height: 130,
              ),
              SizedBox(height: AppSpacing.sm,),
              Text(
                title,
                style: AppTypography.h1.copyWith(color: AppColorsDark.onBackground),
              ),
              SizedBox(height: AppSpacing.xl,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "If You Nedd Any Support ",
                    style: AppTypography.caption.copyWith(color: AppColorsDark.onSurface, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, "/help"),
                    child: Text(
                      "Click Here",
                      style: AppTypography.caption.copyWith(color: AppColorsDark.primary, fontSize: 12),
                    ),
                  )
                ],
              ),
              SizedBox(height: AppSpacing.xl,),
              child,
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColorsDark.onSurface.withAlpha(50),
                    ),
                  ),
                  Text(
                    " Or ",
                    style:  AppTypography.caption.copyWith(color: AppColorsDark.onSurface.withAlpha(50)),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColorsDark.onSurface.withAlpha(50),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xxl,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColorsDark.onSurface.withAlpha(50)
                        ),
                      ),
                      child: FaIcon(FontAwesomeIcons.google),
                    ),
      
                  ),
                  SizedBox(width: AppSpacing.xl,),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColorsDark.onSurface.withAlpha(50)
                        ),
                      ),
                      child: FaIcon(FontAwesomeIcons.github),
                    ),
      
                  ),

                ],
              ),
              SizedBox(height: AppSpacing.xxxl,),
              subtitle != null ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    subtitle!,
                    style: AppTypography.caption.copyWith(color: AppColorsDark.onSurface),
                  ),
                  GestureDetector(
                    onTap: subtitleLinkTap,
                    child: Text(
                      subtitleLink!,
                      style: AppTypography.caption.copyWith(color: AppColorsDark.primary),
                    ),
                  )
                ],
              ): SizedBox.shrink(),
            ],
          ),
        )
        ),
    );
  }


}