import 'package:flutter/material.dart';
import 'package:presupuesto_estudiantil/global/initial_route.dart';
import 'package:presupuesto_estudiantil/theme/app_theme.dart';
import 'router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();

  // Iniciamos Supabase usando las variables cargadas
  await Supabase.initialize(
    url: Env.supabaseUrl,
    publishableKey: Env.supabasePublishableKey,
  );

  // // obtener code dela url
  // final codigo = Uri.base.queryParameters['code'];
  // if (codigo != null) {
  //   try {
  //     // inicio de sesión temporal
  //     await Supabase.instance.client.auth.exchangeCodeForSession(codigo);
  //     initialRoute = '/change-password';
  //     print("Se configuro /change-password");
  //   } catch (e) {
  //     print('Error canjeando code: $e');
  //   }
  // }
  final uri = Uri.base;
  final tokenHash = uri.queryParameters['token_hash'];
  final type = uri.queryParameters['type'];

  if (tokenHash != null && type == 'recovery') {
    try {
      await Supabase.instance.client.auth.verifyOTP(
        tokenHash: tokenHash,
        type: OtpType.recovery,
      );
      initialRoute = '/change-password';
    } catch (e) {
      print('Error verificando OTP: $e');
    }
  }
  runApp(const StudShieldApp());
}

class StudShieldApp extends StatelessWidget {
  const StudShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter, // <--- Conecta nuestro mapa de rutas
      title: Env.appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
    );
  }
}
