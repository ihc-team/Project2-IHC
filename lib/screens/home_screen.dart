import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';




// Pantalla de bienvenida, se mostrara al entrar a la aplicacion
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
return Scaffold(
    //El "SafeArea" ayuda a que el contenido se muestre correctamente en cualquier dispositivo
    //sin tapar ningun elemento importante de la pantalla
      body: SafeArea(

        // El "Padding" se utiliza para agregar espacio alrededor del contenido
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),

          // El "Column" se utiliza para organizar los elementos en una columna vertical
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mensaje de Bienvenida
              const Text(
                '¡Bienvenido a tu StudShield',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              const Text(
                'una aplicacion para Presupuesto Estudiantil!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(), // Deja un espacio flexible antes de los botones

              // Boton 1 Iniciar Sesion
              ElevatedButton(
                onPressed: () {
                  // Navegacion hacia la Pantalla de Login
                  context.push('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Iniciar Sesion', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 16),

              // Boton 2: Registro
              OutlinedButton(
                onPressed: () {
                  // Navegacion hacia la Pantalla de Registro
                  context.push('/register');
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.deepPurple, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Crear una cuenta',
                  style: TextStyle(fontSize: 16, color: Colors.deepPurple),
                ),
              ),

              const SizedBox(height: 32), // Margen inferior de seguridad
            ],
          ),
        ),
      ),
    );
  }
}

