import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// Pantalla de Registro, se mostrara al pulsar Crear una cuenta
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: const Center(
        child: Text(
          'Aqui ira el formulario de Registro',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

