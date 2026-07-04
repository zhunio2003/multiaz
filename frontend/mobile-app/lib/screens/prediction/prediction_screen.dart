  import 'package:flutter/material.dart';
  import 'package:mobile_app/core/theme/app_colors.dart';
  import 'package:mobile_app/core/widgets/primary_button.dart';
  import 'package:mobile_app/core/widgets/secondary_button.dart';
import 'package:mobile_app/models/ai_model.dart';
import 'package:mobile_app/models/prediction_result.dart';

  class PredictionScreen extends StatefulWidget {

    final AiModel aiModel;


    const PredictionScreen({
      super.key, 
      required this.aiModel,
    });

    @override
    State<PredictionScreen> createState() => _PredictionScreenState();
  }

  class _PredictionScreenState extends State<PredictionScreen> {

    bool _isLoading = false;
    PredictionResult? _result = null;

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _textController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              TextField(controller: _titleController, decoration: InputDecoration(labelText: "title")),
              TextField(controller: _textController, decoration: InputDecoration(labelText: "text")),
              PrimaryButton(label: "Predecir", onPressed: () {}),
              SecondaryButton(label: "Volver a predicir", onPressed: () {}),
              _result != null ? Text("Resultado: ${_result?.result}, Score: ${_result?.confidence}") : const SizedBox.shrink(),
            ],
          )
          ),
      );
    }

    @override
    dispose() {
      _titleController.dispose();
      _textController.dispose();
      super.dispose();
    }
    
  }