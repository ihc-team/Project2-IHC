import 'package:flutter/material.dart';
import 'package:presupuesto_estudiantil/utils/estado_movimiento.dart';
import 'package:presupuesto_estudiantil/widgets/app_drawer.dart';
import '../services/movements_service.dart';

class MovementsScreen extends StatefulWidget {
  const MovementsScreen({super.key});

  @override
  State<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends State<MovementsScreen> {
  final _formularioId = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _service = MovementsService();

  String _tipo = 'gasto';
  String _categoria = 'Transporte';
  DateTime _fecha = DateTime.now();
  List<Map<String, dynamic>> _movimientos = [];
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final data = await _service.getAll();
    setState(() => _movimientos = data);
  }

  Future<void> _save() async {
    if (!_formularioId.currentState!.validate()) return;
    final monto = double.tryParse(_montoController.text) ?? 0;

    try {
      if (_editingId == null) {
        //Se esta creando un uno
        await _service.create(
          tipo: _tipo,
          monto: monto,
          categoria: _categoria,
          fecha: _fecha,
        );
      } else {
        // Se esta editando uno movimiento existente
        await _service.update(
          id: _editingId!,
          tipo: _tipo,
          monto: monto,
          categoria: _categoria,
          fecha: _fecha,
        );
        _editingId = null;
      }

      if (mounted) {
        // Se vuevle a cargar la lista
        _load();
      }
    } catch (_) {}

    _montoController.text = "";
  }

  Future<void> _delete(String id) async {
    try {
      await _service.delete(id);
      if (mounted) {
        _load();
      }
    } catch (_) {}
  }

  Future<void> _prepareEdition(Map<String, dynamic> m) async {
    setState(() {
      _editingId = m['id'] as String;
      _montoController.text = m['monto'].toString();
      _tipo = m['tipo'] as String;
      _categoria = m['categoria'] as String;
      _fecha = DateTime.parse(m['fecha'] as String);
    });
  }

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

  String _fechaTexto(String iso) {
    final d = DateTime.parse(iso);
    return '${d.day} de ${meses[d.month - 1]}';
  }

  Future<void> _cambiarEstado(Map<String, dynamic> m) async {
    final actual = m['estado'];
    final siguiente = siguienteEstado(actual);
    if (siguiente == null) return;
    await _service.cambiarEstado(m['id'], siguiente);
    _load();
  }

  final Map<String, Color> _estadoXColor = {
    'pendiente': Colors.blue,
    'pagado': Colors.green,
    'cancelado': Colors.red,
  };

  Color escoger(String entrada) {
    return _estadoXColor[entrada]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Movimientos')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ..._movimientos.map((m) {
                  final tipo = m['tipo'] as String;
                  final monto = m['monto'];
                  final categoria = m['categoria'];
                  final fecha = _fechaTexto(m['fecha'] as String);
                  final etiqueta = tipo == 'gasto' ? 'Gasto' : 'Ingreso';

                  return ListTile(
                    title: Text('$etiqueta - $monto Bs - $categoria - $fecha'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton(
                          onPressed: () => _cambiarEstado(m),
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll<Color>(
                              escoger(m['estado']),
                            ),
                            side: WidgetStatePropertyAll(
                              BorderSide(
                                color: escoger(m['estado']),
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text('${m['estado']}'),
                        ),
                        ElevatedButton(
                          onPressed: () => _delete(m['id'] as String),
                          child: const Text('Borrar'),
                        ),

                        TextButton(
                          onPressed: () => _prepareEdition(m),
                          child: const Text('Editar'),
                        ),
                      ],
                    ),
                  );
                }),
                Form(
                  key: _formularioId,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          // Si _editingId NO es nulo, mostramos este aviso:
                          if (_editingId != null) ...[
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Edita este movimiento',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _editingId = null;
                                        _montoController.clear();
                                      });
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],

                          SizedBox(
                            width: double.infinity,
                            child: Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceAround,
                              children: [
                                DropdownButton<String>(
                                  value: _tipo,
                                  items: [
                                    DropdownMenuItem(
                                      value: 'gasto',
                                      child: Text('Gasto'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'ingreso',
                                      child: Text('Ingreso'),
                                    ),
                                  ],
                                  onChanged: (v) => setState(() => _tipo = v!),
                                ),
                                DropdownButton<String>(
                                  value: _categoria,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Transporte',
                                      child: Text('Transporte'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Comida',
                                      child: Text('Comida'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Estudios',
                                      child: Text('Estudios'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Ocio',
                                      child: Text('Ocio'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Otros',
                                      child: Text('Otros'),
                                    ),
                                  ],
                                  onChanged:
                                      (v) => setState(() => _categoria = v!),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(_fechaTexto(_fecha.toIso8601String())),
                                    TextButton(
                                      onPressed: () async {
                                        final picked = await showDatePicker(
                                          context: context,
                                          initialDate: _fecha,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime(2100),
                                          initialEntryMode:
                                              DatePickerEntryMode.input,
                                        );
                                        if (picked != null) {
                                          setState(() => _fecha = picked);
                                        }
                                      },
                                      child: Text('Cambiar fecha'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            controller: _montoController,
                            decoration: InputDecoration(hintText: 'Monto (Bs)'),
                            validator: (texto) {
                              if (texto == null || texto.isEmpty) {
                                return 'El campo no puede estar vacío';
                              }
                              final n = double.tryParse(texto);
                              if (n == null) {
                                return 'Formato numérico inválido';
                              }
                              if (n <= 0) {
                                return 'El monto debe ser mayor a 0';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: _save,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 52),
                            ),
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
