import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';

// Pantalla para cambiar la contraseña del usuario autenticado
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

// Es una clase estado para guardar la nueva contraseña del usuario
class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  // Este metodo que se ejecuta cuando el usuario presiona el boton de cambiar contraseña
  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.updatePassword(_passwordController.text.trim());

      // Si el widget no se ha desmontado, es decir que la pantalla sigue existiendo
      // entonces se muestra un mensaje de exito y vuelve a "Mis Movimientos"
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Contraseña actualizada con éxito!')),
        );
        context.go('/movements'); // vuelve a "Mis Movimientos"
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

  // Este metodo se ejecuta cuando el widget se elimina de la pantalla
  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  // Este metodo devuelve el widget a mostrar
  // este widget es la pantalla con un formulario para cambiar la contraseña
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña',
                  hintText: 'Ingresa tu nueva clave',
                ),
                validator: (val) =>
                    val == null || val.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleChangePassword,
                      child: const Text('Actualizar Contraseña'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
