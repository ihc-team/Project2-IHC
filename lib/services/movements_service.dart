import 'package:supabase_flutter/supabase_flutter.dart';

class MovementsService {
  final _db = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getAll() async {
    final user = _db.auth.currentUser;
    if (user == null) return [];

    final data = await _db
        .from('movimientos')
        .select()
        .eq('user_id', user.id)
        .order('fecha', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> create({
    required String tipo,
    required double monto,
    required String categoria,
    required DateTime fecha,
  }) async {
    final user = _db.auth.currentUser;
    if (user == null) return;

    await _db.from('movimientos').insert({
      'user_id': user.id,
      'tipo': tipo,
      'monto': monto,
      'categoria': categoria,
      'fecha': fecha.toIso8601String().split('T').first,
    });
  }

  Future<void> delete(String id) async {
    await _db.from('movimientos').delete().eq('id', id);
  }
}
