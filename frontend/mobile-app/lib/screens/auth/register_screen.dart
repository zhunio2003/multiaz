import 'package:flutter/material.dart';
import 'package:mobile_app/core/network/api_client.dart';
import 'package:mobile_app/core/widgets/app_bar_widget.dart';
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

    return Scaffold(
      appBar: AppBarWidget(title: 'Register'),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                validator: (value) => value!.isEmpty?  'Campo requerido' : null,
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) => value!.isEmpty?  'Campo requerido' : null,
              ),
              TextFormField(
                controller: _passwordController,
                validator: (value) => value!.isEmpty?  'Campo requerido' : null,
                obscureText: true,
              ),
              PrimaryButton(
                label: 'Register',
                onPressed: _isLoading ? null : _submit,
                )
            ],
          ),
        )
      ),
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