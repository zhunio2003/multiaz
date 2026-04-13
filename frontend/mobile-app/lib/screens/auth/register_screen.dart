import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/widgets/app_text_field.dart';
import 'package:mobile_app/core/widgets/base_layout.dart';
import 'package:mobile_app/core/widgets/primary_button.dart';
import 'package:mobile_app/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
  
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService(ApiClient(null));

  @override
  Widget build(BuildContext context) {

    return BaseLayout(
      title: 'Register',
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              label: "name",
              controller: _nameController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: "email",
              controller: _emailController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
            ),
            SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: "password",
              controller: _passwordController,
              validator: (value) => value!.isEmpty?  'Campo requerido' : null,
              obscureText: true,
            ),
            SizedBox(height: AppSpacing.lg),
            PrimaryButton(
              label: 'Register',
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
      await _authService.register(
        _nameController.text, 
        _emailController.text, 
        _passwordController.text,
        );
        Navigator.pushReplacementNamed(context, '/home');
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  
  
}