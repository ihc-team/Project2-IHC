import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Comienza a cargar las variables de entorno
  await dotenv.load(fileName: ".env");

  // Iniciamos Supabase usando las variables cargadas
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_PUBLISHABLE_KEY']!,
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
