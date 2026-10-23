import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_typography.dart';
import 'package:mobile_app/core/widgets/base_layout.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';

class NewsScreen extends StatelessWidget{

  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(title: "Prediccion", 
      child: SingleChildScrollView(
         child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              ClipRRect(
                child: Image.asset(
                  "assets/images/logo-multiaz.png",
                  width: 80,
                  height: 50,
                  fit: BoxFit.cover,
                ),

              ),
              SizedBox(height: AppSpacing.md,), 
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/logo-multiaz.jpg',
                  width: double.infinity,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: AppSpacing.md,), 
              Text(
                "Nuevo modelo disponible",
                textAlign: TextAlign.center,
                style: AppTypography.h3.copyWith(color: AppColors.primary),
              ),
              SizedBox(height: AppSpacing.md,),
              Text(
                "Texto de prueba de una o dos líneas que explica la noticia.",
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: AppColors.onSurface),
              ),
              SizedBox(height: AppSpacing.xxxl,),
              PrimaryButton(
                label: "Probar Ahora",
                onPressed: () => Navigator.pop(context),
              )
            ],
          ),
        ),
      )
    );
  }

}