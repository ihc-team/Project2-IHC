import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://glgmxspheajpbutpmvxy.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdsZ214c3BoZWFqcGJ1dHBtdnh5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA4MTE3MjYsImV4cCI6MjEwNjM4NzcyNn0.6p3O8nIj62wEWwB2AqrKb248yUuvuSwvX0BdziYfwrk',
  );

  runApp(const StudShieldApp());
}

class StudShieldApp extends StatelessWidget {
  const StudShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // <--- Conecta nuestro mapa de rutas
      title: 'Presupuesto Estudiantil',
      debugShowCheckedModeBanner: false,
    );
  }
}
