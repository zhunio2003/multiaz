import 'package:flutter/material.dart';
import 'package:mobile_app/core/navigation/app_router.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/widgets/app_text_field.dart';
import 'package:mobile_app/core/widgets/base_layout.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';
import 'package:mobile_app/services/auth_service.dart';
import 'package:mobile_app/services/token_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _ForgotPasswordScreenState();
  
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(ApiClient(() => navigatorKey.currentState?.pushReplacementNamed("/login")), TokenService());

  @override
  Widget build(BuildContext context) {

    return BaseLayout(
      title: 'Recuperar contraseña',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: "email",
              controller: _emailController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'enviar codigo',
              onPressed: _isLoading ? null : _submit,
            ),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      )
    );
  
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.recoverPassword(
        _emailController.text
        );
        Navigator.pushReplacementNamed(context, '/reset-password');
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
    _emailController.dispose();
    super.dispose();
  }
  
  
}