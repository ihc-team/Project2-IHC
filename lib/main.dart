import 'package:flutter/material.dart';
import 'router/app_router.dart';

void main() {
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
