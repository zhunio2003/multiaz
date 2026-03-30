import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget{

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
  });


  
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        label: Text(label),
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder()
      ),
    );
  }

  
}