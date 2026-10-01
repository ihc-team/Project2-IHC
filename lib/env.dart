import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get appName =>
      dotenv.env['APP_NAME'] ?? 'Presupuesto Estudiantil';

  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';

  static String get supabasePublishableKey =>
      dotenv.env['SUPABASE_PUBLISHABLE_KEY'] ?? '';

  static Future<void> init() async {
    await dotenv.load(fileName: ".env");
  }
}
