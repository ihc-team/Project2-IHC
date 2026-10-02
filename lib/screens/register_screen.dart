import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_service.dart';
import 'package:presupuesto_estudiantil/design_system/spacing_tokens.dart';
import 'package:presupuesto_estudiantil/design_system/app_text_style.dart';
import 'package:presupuesto_estudiantil/design_system/color_styles.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _showPassword = false;

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Cuenta creada exitosamente!')),
        );
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
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
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
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    floatingLabelBehavior:
                        FloatingLabelBehavior
                            .never, // para evitar que el placeholder suba arriba del borde
                    border: OutlineInputBorder(),
                    hintText: 'password123',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed:
                          () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator:
                      (val) =>
                          val == null || val.length < 6
                              ? 'Minimo 6 caracteres'
                              : null,
                ),
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorStyles.primaryBase,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: const Text(
                    'Registrarse',
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
