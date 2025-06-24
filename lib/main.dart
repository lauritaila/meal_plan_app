import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:meal_plan_app/config/config.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Enviroment.initEnv();
  await Supabase.initialize(
    url: Enviroment.supabaseUrl,
    anonKey: Enviroment.supabaseKey,
  );
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

