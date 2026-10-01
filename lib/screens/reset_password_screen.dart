import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// Esto es para recuperar la contraseña del usuario, el usuario introduce su correo y se le envia un correo para recuperar su contraseña
// Si el usuario no existe, se le envia un correo de todas formas
// Si el usuario existe, se le envia un correo de todas formas
// Si el usuario existe y tiene una sesion iniciada, se le envia un correo de todas formas
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

// En esta clase se maneja la logica de la pantalla de recuperación de contraseña
class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.resetPasswordForEmail(_emailController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Si el correo esta registrado, recibiras las instrucciones.',
            ),
          ),
        );
        context.go('/login'); // Regresa al Login tras solicitar la recuperación
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electronico',
                  hintText: 'Ingresa tu correo registrado',
                ),
                validator:
                    (val) =>
                        val == null || val.isEmpty ? 'Ingresa tu correo' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: _handleResetPassword,
                    child: const Text('Enviar Solicitud'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
