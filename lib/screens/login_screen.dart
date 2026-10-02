import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'package:presupuesto_estudiantil/design_system/spacing_tokens.dart';
import 'package:presupuesto_estudiantil/design_system/app_text_style.dart';
import 'package:presupuesto_estudiantil/design_system/color_styles.dart';

// Pantalla de Login, se mostrara al pulsar Iniciar Sesion
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Sirve para verificar el estado del formulario
  final _formKey = GlobalKey<FormState>();

  //Variables para obtener el texto escrito por el usuario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //Sirve para el manejo de la autenticacion
  final _authService = AuthService();

  //Variable para controlar el estado de carga cuando esta cargando
  bool _isLoading = false;

  // Mostrar password
  bool _obscureText = true;

  //Metodo para manejar el inicio de sesion
  Future<void> _handleLogin() async {
    //Sirve para validar que el formulario sea correcto
    if (!_formKey.currentState!.validate()) return;
    //Cambia el estado a cargando
    setState(() => _isLoading = true);

    //Maneja errores
    try {
      //Llama al metodo de iniciar sesion
      await _authService.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      //Si el login sale exitoso, navegamos a la pantalla principal
      if (mounted) {
        context.go('/movements');
      }

      //Maneja los errores
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Correo electronico',
                    style: AppTextStyle.boldBodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    floatingLabelBehavior:
                        FloatingLabelBehavior
                            .never, // para evitar que el placeholder suba arriba del borde
                    border: OutlineInputBorder(),
                    hintText: 'ejemplo@gmail.com',
                  ),
                  validator:
                      (val) =>
                          val == null || val.isEmpty
                              ? 'Ingresa tu correo'
                              : null,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Contraseña',
                    style: AppTextStyle.boldBodyLarge,
                    textAlign: TextAlign.start,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: 'password123',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(() => _obscureText = !_obscureText),
                    ),
                  ),
                  validator:
                      (val) =>
                          val == null || val.length < 6
                              ? 'Minimo 6 caracteres'
                              : null,
                ),

                TextButton(
                  onPressed: () => context.push('/reset-password'),
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: AppTextStyle.regularMicro.copyWith(
                      color: ColorStyles.primaryBase,
                    ),
                  ),
                ),

                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.primaryBase,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text(
                    'Iniciar Sesion',
                    style: AppTextStyle.boldBodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
