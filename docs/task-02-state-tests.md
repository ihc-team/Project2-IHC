# Task 02 - Cambio de estado y pruebas

## Parte 1: Nueva funcionalidad

Se agregó el campo `estado` a la tabla `movimientos` con los valores
`pendiente`, `confirmado` y `cancelado`.

Desde la pantalla de movimientos, cada elemento tiene un botón que
cambia su estado. El cambio se guarda en Supabase y se refleja
después de recargar la aplicación.

### función: cambiarEstado

Recibe el estado actual y devuelve el siguiente estado válido, o `null`
si ya no se puede cambiar.

- pendiente  → confirmado
- confirmado → cancelado
- cancelado  → (ninguno)

## Parte 2: Pruebas unitarias

Archivo: `estado_movimiento_test.dart`

### prueba 1:
estado inicial es `pendiente`

### prueba 2:
`pendiente` → `confirmado`

### prueba 3:
un movimiento ya `cancelado` no cambia otra vez

### prueba 4:
los demás datos se conservan al cambiar de estado

| # | Prueba | Qué verifica |
|---|--------|--------------|
| 1 | Estado inicial es el correcto | Un movimiento nuevo empieza en `pendiente` |
| 2 | La acción realiza la transición esperada | `pendiente → confirmado` funciona |
| 3 | Una transición inválida resulta rechazada | `cancelado` no cambia otra vez |
| 4 | Los demás datos se conservan | Al cambiar estado, `id`, `tipo`, `monto`, `categoria` y `fecha` no se alteran |

### Cómo ejecutar

```bash
flutter test test/estado_movimiento_test.dart