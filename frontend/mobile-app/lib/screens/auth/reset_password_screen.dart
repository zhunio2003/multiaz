import 'package:flutter/material.dart';
import 'package:mobile_app/core/navigation/app_router.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/widgets/app_text_field.dart';
import 'package:mobile_app/core/widgets/base_layout.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _ResetPasswordScreenState();
  
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(ApiClient(() => navigatorKey.currentState?.pushReplacementNamed("/login")), TokenService());

  @override
  Widget build(BuildContext context) {

    return BaseLayout(
      title: 'Cambiar contraseña',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: "Token",
              controller: _tokenController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: "New password",
              controller: _newPasswordController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'cambiar contraseña',
              onPressed: _isLoading ? null : _submit,
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      )
    );
  
  }

  Future<void>_submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPassword(
        _tokenController.text, 
        _newPasswordController.text,
        );
        Navigator.pushReplacementNamed(context, '/login');
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error  ${e.toString()}'))
      );
    } finally {
      setState(() => _isLoading = false);
    }

  }

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  
}