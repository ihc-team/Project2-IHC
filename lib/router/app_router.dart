import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // <--- Importante
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/movements_screen.dart';
import '../screens/change_password_screen.dart';


final appRouter = GoRouter(
  initialLocation: '/',

  // Esto sirve para redirigir al usuario a la ruta que intenta acceder si no tiene sesion
  redirect: (context, state) {
    // Verifica si hay sesion activa en Supabase
    final session = Supabase.instance.client.auth.currentSession;

    // Comprueba si el usuario intenta ir a una ruta privada
    final isGoingPrivate = state.matchedLocation == '/movements' || state.matchedLocation == '/change-password';


    // Comprueba si el usuario intenta ir a una ruta publica
    final isGoingPublicAuth = state.matchedLocation == '/' ||
      state.matchedLocation == '/login' ||
      state.matchedLocation == '/register';

    // Si intenta ir a ruta privada sin iniciar sesion, vuelve al login
    if (session == null && isGoingPrivate) {
      return '/login';
    }

    // Si intenta ir a ruta publica con sesion iniciada, vuelve a movimientos
    if (session != null && isGoingPublicAuth) {
      return '/movements';
    }

    return null; 
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/movements',
      builder: (context, state) => const MovementsScreen(),
    ),
  ],
);
