import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_typography.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // int _selectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: AppSpacing.xs),
              _buildStats(),
              SizedBox(height: AppSpacing.xs),
              _buildBanner(),
              SizedBox(height: AppSpacing.xs),
              _buildCTA(),
              SizedBox(height: AppSpacing.xs),
              _buildCarousel()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Buenos dias",
                style: AppTypography.h6.copyWith(color: AppColors.onSurface),
              ),
              Text(
                "Miguel",
                style: AppTypography.h6.copyWith(color: AppColors.onBackground),
              ),
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: AppColors.surface,
            child: Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    "Predicciones",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    "142",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  Text(
                    "+12 esta semana",
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Text(
                    "Última predicción",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                  Text(
                    "Clasificador v2",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  Text(
                    "Hace 2 horas",
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A2E1E),
          border: Border.all(color: AppColors.secondary, width: 0.3),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(child: Icon(Icons.bolt)),
            Expanded(
              child: Column(
                children: [
                  Text(
                    "Uno",
                    style: AppTypography.body.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    "Clasificador v2",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                  Text(
                    "Hace 2 horas",
                    style: AppTypography.body.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xs,
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/catalog');
        },
        icon: Icon(Icons.bolt),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTypography.button,
          minimumSize: Size(double.infinity, 150),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        label: Text("Nueva predicción"),
      ),
    );
  }

  Widget _buildCarousel() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Modelos disponibles"), Text("Explorar modelos")],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        "Raking",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "Raking universidades",
                        style: AppTypography.body.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                      Text(
                        "+10 mil prediccionesç",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        "Raking",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "Raking universidades",
                        style: AppTypography.body.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                      Text(
                        "+10 mil prediccionesç",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text(
                        "Raking",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        "Raking universidades",
                        style: AppTypography.body.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                      Text(
                        "+10 mil prediccionesç",
                        style: AppTypography.body.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
