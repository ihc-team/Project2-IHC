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

  //Este metodo sirve para iniciar sesion
  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //Este metodo sirve para cerrar sesion
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Obtiene el usuario actual
  User? get currentUser => _supabase.auth.currentUser;

  // Método para cambiar la contraseña del usuario autenticado (RF-05)
  Future<UserResponse> updatePassword(String newPassword) async {
    return await _supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );
}

}
