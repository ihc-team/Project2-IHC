// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../services/auth_service.dart';

// // En esta parte de movements (movimientos) es donde el usuario podra ver sus ingresos y gastos

// class MovementsScreen extends StatelessWidget {
//   const MovementsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authService = AuthService();
//     final user = authService.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mis Movimientos'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         actions: [
//           // Colocar el boton en la parte derecha para cerrar sesión
//           IconButton(
//             icon: const Icon(Icons.logout),
//             tooltip: 'Cerrar Sesión',
//             onPressed: () async {
//               await authService.signOut();
//               if (context.mounted) {
//                 context.go('/'); // Para redirigir a la portada publica
//               }
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.account_circle,
//                 size: 80,
//                 color: Colors.deepPurple,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 '¡Bienvenido!',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),

//               // Muestra el correo del usuario autenticado
//               Text(
//                 user?.email ?? 'Correo no disponible',
//                 style: const TextStyle(fontSize: 16, color: Colors.grey),
//               ),

//               const SizedBox(height: 24),

//               OutlinedButton.icon(
//                 onPressed: () => context.push('/change-password'),
//                 icon: const Icon(Icons.key),
//                 label: const Text('Cambiar Contraseña'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/movements_service.dart';

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key});

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  final _auth = AuthService();
  final _service = MovementsService();
  final _monto = TextEditingController();

  String _tipo = 'gasto';
  String _categoria = 'Transporte';
  DateTime _fecha = DateTime.now();
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _monto.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await _service.getAll();
    setState(() => _items = data);
  }

  Future<void> _save() async {
    final monto = double.tryParse(_monto.text) ?? 0;
    if (monto <= 0) return;

    await _service.create(
      tipo: _tipo,
      monto: monto,
      categoria: _categoria,
      fecha: _fecha,
    );
    _monto.clear();
    _load();
  }

  Future<void> _delete(String id) async {
    await _service.delete(id);
    _load();
  }

  String _fechaTexto(String iso) {
    final meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final d = DateTime.parse(iso);
    return '${d.day} de ${meses[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movimientos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children:
                  _items.map((m) {
                    final tipo = m['tipo'] as String;
                    final monto = m['monto'];
                    final categoria = m['categoria'];
                    final fecha = _fechaTexto(m['fecha'] as String);
                    final etiqueta = tipo == 'gasto' ? 'Gasto' : 'Ingreso';

                    return ListTile(
                      title: Text(
                        '$etiqueta · $monto Bs · $categoria · $fecha',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(m['id'] as String),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _tipo,
                  items: const [
                    DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
                    DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                  ],
                  onChanged: (v) => setState(() => _tipo = v!),
                ),
                TextField(
                  controller: _monto,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monto (Bs)'),
                ),
                DropdownButton<String>(
                  value: _categoria,
                  items: const [
                    DropdownMenuItem(
                      value: 'Transporte',
                      child: Text('Transporte'),
                    ),
                    DropdownMenuItem(value: 'Comida', child: Text('Comida')),
                    DropdownMenuItem(
                      value: 'Estudios',
                      child: Text('Estudios'),
                    ),
                    DropdownMenuItem(value: 'Ocio', child: Text('Ocio')),
                    DropdownMenuItem(value: 'Otros', child: Text('Otros')),
                  ],
                  onChanged: (v) => setState(() => _categoria = v!),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_fechaTexto(_fecha.toIso8601String())),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _fecha,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _fecha = picked);
                      },
                      child: const Text('Cambiar fecha'),
                    ),
                  ],
                ),
                ElevatedButton(onPressed: _save, child: const Text('Guardar')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
