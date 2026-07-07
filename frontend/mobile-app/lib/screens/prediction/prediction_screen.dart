import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/theme/app_colors.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';
import 'package:mobile_app/core/widgets/secondary_button.dart';
import 'package:mobile_app/models/ai_model.dart';
import 'package:mobile_app/models/prediction_result.dart';
import 'package:mobile_app/services/prediction_service.dart';
import 'package:mobile_app/services/token_service.dart';

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
              _isLoading
                ? CircularProgressIndicator()
                : PrimaryButton(label: "Predecir", onPressed: _predict),
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
    
    void _predict() async {

      if (_titleController.text.isEmpty || _textController.text.isEmpty) return;

      setState(() {
        _isLoading = true;
      });

      final userId = await TokenService().getUserId();

      if (userId == null) return;


      try {
        final result = await PredictionService(ApiClient(null)).predict(widget.aiModel.id, userId, {"title": _titleController.text, "text": _textController.text});
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } catch (e) {
        
      } finally {
        setState(() {
          _isLoading = false;
        });
      }

    
    }
}