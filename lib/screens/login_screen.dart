import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Pantalla de Login, se mostrara al pulsar Iniciar Sesion
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesion')),
      body: const Center(
        child: Text(
          'Aqui va el formulario de Login',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
