import 'package:flutter/material.dart';
import 'package:mobile_app/screens/auth/forgot_password_screen.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';
import 'package:mobile_app/screens/auth/register_screen.dart';
import 'package:mobile_app/screens/auth/reset_password_screen.dart';
import 'package:mobile_app/screens/catalog/model_catalog_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';

class AppRouter {

  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>(); 

  static final Map<String, WidgetBuilder> routes = {
    '/register': (context) => RegisterScreen(),
    '/home': (context) => HomeScreen(),
    '/login': (context) => LoginScreen(),
    '/forgot-password': (context) => ForgotPasswordScreen(),
    '/reset-password': (context) => ResetPasswordScreen(),
    '/catalog': (context) => ModelCatalogScreen(),
  };

}

