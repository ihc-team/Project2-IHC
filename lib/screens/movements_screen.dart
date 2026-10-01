import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

// En esta parte de movements (movimientos) es donde el usuario podra ver sus ingresos y gastos

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Movimientos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          // Colocar el boton en la parte derecha para cerrar sesión
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar Sesión',
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                context.go('/'); // Para redirigir a la portada publica
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 16),
              const Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Muestra el correo del usuario autenticado
              Text(
                user?.email ?? 'Correo no disponible',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

            
            ],
          ),
        ),
      ),
    );
  }
}
