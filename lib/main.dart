import 'package:flutter/material.dart';
import 'package:meal_plan_app/config/config.dart';

void main() async{
  await Enviroment.initEnv();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      title: 'Meal Plan App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme()
    );
  }
}

class AppRouter {
}

