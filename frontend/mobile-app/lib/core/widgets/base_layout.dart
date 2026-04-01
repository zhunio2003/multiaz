import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_spacing.dart';
import 'package:mobile_app/core/widgets/app_bar_widget.dart';

class BaseLayout extends StatelessWidget{
  
  final String title;
  final Widget child;

  const BaseLayout({
    super.key,
    required this.title,
    required this.child
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: title),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: child,
      ),
    );
  }

}