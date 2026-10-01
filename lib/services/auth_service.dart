import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Aqui hace referencia a la instancia global del cliente de Supabase
  final SupabaseClient _supabase = Supabase.instance.client;

  // Es el metodo para registrar a un nuevo usuario
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    // Aqui se envian los datos para el registro
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }
}
