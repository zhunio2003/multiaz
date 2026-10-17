import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/theme/app_typography.dart';
import 'package:mobile_app/models/ai_model.dart';

class ModelCard extends StatelessWidget {

  final AiModel model;

  const ModelCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.type,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.body.copyWith(color: AppColors.primary),
          ),
          Text(
            model.name,
            style: AppTypography.body.copyWith(color: AppColors.onBackground),
          ),
          Text(
            model.description,
            style: AppTypography.body.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
