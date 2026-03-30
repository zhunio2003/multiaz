import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';

class AppCard extends StatelessWidget{
  final Widget child;
  final double? padding;

  const AppCard({
    super.key,
    required this.child,
    this.padding
  });
  
  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding ?? AppSpacing.lg),
        child: child,
        ),
    );
  }


}