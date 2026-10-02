import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presupuesto_estudiantil/design_system/app_text_style.dart';
import 'package:presupuesto_estudiantil/design_system/color_styles.dart';
import 'package:presupuesto_estudiantil/widgets/app_drawer.dart';
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

  bool _showPassword1 = false;
  // bool _showPassword2 = false;

  // Este metodo devuelve el widget a mostrar
  // este widget es la pantalla con un formulario para cambiar la contraseña
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: const Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Ingresa tu nueva contraseña',
                  style: AppTextStyle.boldBodyLarge,
                  textAlign: TextAlign.start,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _showPassword1,
                decoration: InputDecoration(
                  floatingLabelBehavior:
                      FloatingLabelBehavior
                          .never, // para evitar que el placeholder suba arriba del borde
                  border: OutlineInputBorder(),
                  hintText: 'password123',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword1 ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () => setState(() => _showPassword1 = !_showPassword1),
                  ),
                ),
                validator:
                    (val) =>
                        val == null || val.length < 6
                            ? 'Minimo 6 caracteres'
                            : null,
              ),
              ElevatedButton(
                onPressed: _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorStyles.primaryBase,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('Actualizar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
