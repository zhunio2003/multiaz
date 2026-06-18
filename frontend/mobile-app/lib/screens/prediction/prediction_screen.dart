import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';
import 'package:mobile_app/core/widgets/secondary_button.dart';

class PredictionScreen extends StatefulWidget {

  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            Text("Prediction"),
            Text("RESULT"),
            Text("Score"),
            PrimaryButton(label: "Ver mas"),
            SecondaryButton(label: "Volver a predicir")
          ],
        )
        ),
    );
  }
  
}