import 'package:flutter/material.dart';
import 'package:mobile_app/models/ai_model.dart';
import 'package:mobile_app/screens/auth/forgot_password_screen.dart';
import 'package:mobile_app/screens/auth/login_screen.dart';
import 'package:mobile_app/screens/auth/register_screen.dart';
import 'package:mobile_app/screens/auth/reset_password_screen.dart';
import 'package:mobile_app/screens/catalog/model_catalog_screen.dart';
import 'package:mobile_app/screens/home/home_screen.dart';
import 'package:mobile_app/screens/prediction/prediction_screen.dart';

class AppRouter {

  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>(); 
  static final List<AiModel> _mockModels = [
  AiModel(id: '1', name: 'Ranking de universidades', description: 'Predice la posición de una universidad', type: 'Ranking', status: 'ACTIVE'),
  AiModel(id: '2', name: 'Rendimiento académico', description: 'Estima el promedio de un estudiante', type: 'Educación', status: 'ACTIVE'),
  AiModel(id: '3', name: 'Deserción estudiantil', description: 'Riesgo de abandono de carrera', type: 'Educación', status: 'ACTIVE'),
  AiModel(id: '4', name: 'Demanda laboral', description: 'Tendencia de empleo por carrera', type: 'Empleo', status: 'ACTIVE'),
  AiModel(id: '5', name: 'Costo de matrícula', description: 'Proyección de costos por año', type: 'Finanzas', status: 'ACTIVE'),
];

  static final Map<String, WidgetBuilder> routes = {
    '/register': (context) => RegisterScreen(),
    '/home': (context) => HomeScreen(userName: 'Miguel Zhunio', greeting: 'Hola 👋', models: _mockModels,),
    '/login': (context) => LoginScreen(),
    '/forgot-password': (context) => ForgotPasswordScreen(),
    '/reset-password': (context) => ResetPasswordScreen(),
    '/catalog': (context) => ModelCatalogScreen(),
    '/predict': (context) {
      final model = ModalRoute.of(context)!.settings.arguments as AiModel;
      return PredictionScreen(aiModel: model);
    }
  };

}

