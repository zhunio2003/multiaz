import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_typography.dart';
import 'package:mobile_app/core/widgets/app_bottom_bar.dart';
import 'package:mobile_app/core/widgets/model_card.dart';
import 'package:mobile_app/models/ai_model.dart';
import 'package:mobile_app/screens/news/news_screen.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  final String? avatarUrl;
  final String greeting;
  final List<AiModel> models;


  const HomeScreen({
    super.key,
    required this.userName,
    this.avatarUrl,
    required this.greeting,
    required this.models,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              _buildNewsBanner(),
              SizedBox(height: AppSpacing.xs),
              SizedBox(height: AppSpacing.xs),
              _buildCTA(),
              SizedBox(height: AppSpacing.xs),
              _buildCarousel(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomBar(currentIndex: 0,),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                radius: 26,
                backgroundImage: widget.avatarUrl != null
                    ? NetworkImage(widget.avatarUrl!)
                    : null,
                child: widget.avatarUrl == null
                    ? Icon(Icons.person, color: AppColors.onSurface)
                    : null,
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.greeting,
                    style: AppTypography.body.copyWith(
                      color: AppColors.onSurface,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.userName,
                    style: AppTypography.h5.copyWith(
                      color: AppColors.onBackground,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.onSurface,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsBanner() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          child: Stack(
            children: [
              Image.asset(
                'assets/images/news.webp',
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .08),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Nuevo modelo",
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsScreen()),
            );
          },
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                Navigator.pushNamed(context, '/catalog');
              },
              child: Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: .25),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .25),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Nueva predicción",
                        style: AppTypography.h5.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
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
          SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: widget.models.length,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.lg,),
              itemBuilder: (context, index) {
                final model = widget.models[index];
                return ModelCard(model: model);
              },
            ),
          )
        ],
      ),
    );
  }

}
