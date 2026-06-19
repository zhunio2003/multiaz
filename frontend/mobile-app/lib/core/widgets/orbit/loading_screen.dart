import 'package:flutter/material.dart';
import 'dart:math';
import 'orb_painter.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // loop largo
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A12),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                size: const Size(260, 260),
                painter: OrbPainter(_ctrl.value * 2 * pi * 60),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'We are creating\nyour digital art.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFE0D8FF), fontSize: 22),
            ),
            const SizedBox(height: 12),
            Text(
              'Please stand by...',
              style: TextStyle(color: Colors.purple.shade300, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}