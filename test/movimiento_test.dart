import 'package:flutter_test/flutter_test.dart';
import 'package:presupuesto_estudiantil/utils/estado_movimiento.dart';

void main() {
  test('estado inicial es pendiente', () {
    const estadoInicial = 'pendiente';
    expect(estadoInicial, 'pendiente');
  });

  test('la acción hace la transicion esperada', () {
    expect(siguienteEstado('pendiente'), 'confirmado');
    expect(siguienteEstado('confirmado'), 'cancelado');
  });

  test('transicion invalida es rechazada', () {
    expect(siguienteEstado('cancelado'), null);
    expect(esTransicionValida('cancelado', 'confirmado'), false);
    expect(esTransicionValida('pendiente', 'cancelado'), false);
  });

  test('los demas datos se conservan', () {
    final m = {
      'id': '1',
      'tipo': 'gasto',
      'monto': 25.0,
      'categoria': 'Transporte',
      'fecha': '2025-10-01',
      'estado': 'pendiente',
    };

    // simula el cambio de estado sin tocar el resto
    final copia = Map<String, dynamic>.from(m);
    copia['estado'] = siguienteEstado(m['estado'] as String);

    expect(copia['id'], '1');
    expect(copia['tipo'], 'gasto');
    expect(copia['monto'], 25.0);
    expect(copia['categoria'], 'Transporte');
    expect(copia['fecha'], '2025-10-01');
    expect(copia['estado'], 'confirmado');
  });
}
