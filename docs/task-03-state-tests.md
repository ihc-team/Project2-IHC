# Task 03 — Ciclo completo del movimiento

## Parte 1: Editar movimiento

Se añadio la posibilidad de editar los datos de un movimiento ya existente
desde la pantalla de movimientos.

### Cambios en la capa de servicio

En `services/movements_service.dart` se añadio el metodo `update`, que recibe
el `id` del movimiento y los nuevos valores (`tipo`, `monto`, `categoria`, `fecha`)
y los actualiza en la tabla `movimientos` de Supabase.

### Cambios en la pantalla

En `screens/movements_screen.dart` se añadio:

- La variable `_editingId` (tipo `String?`) para rastrear si el formulario esta
  en modo creacion (`null`) o en modo edicion (contiene el `id` del movimiento).
- La funcion `_prepareEdition(m)` que carga los datos del movimiento seleccionado
  en los controles del formulario al presionar "Editar".
- El metodo `_save()` ahora decide si llamar a `create` o `update` segun el valor
  de `_editingId`.
- Un aviso visible ("Edita este movimiento") con boton "Cancelar" que aparece
  mientras el formulario esta en modo edicion.
- Un boton "Editar" junto a cada elemento de la lista.

---

## Parte 2: Eliminar con confirmacion

Se añadio un dialogo de confirmacion antes de eliminar un movimiento.

### funcion: `_confirmDeletion(id)`

Muestra un `AlertDialog` con el mensaje:
> "¿Estas seguro que quieres eliminar este movimiento?"

El usuario puede elegir:
- **Cancelar:** cierra el dialogo sin borrar nada.
- **Eliminar:** confirma el borrado y llama a `_service.delete(id)` en Supabase.

El boton "Borrar" de cada elemento de la lista ahora llama a `_confirmDeletion`
en lugar de ejecutar el borrado directamente.

---

## Parte 3: Restriccion segun el estado

Se implemento la regla de negocio exigida para el proyecto:

> **Un movimiento `pagado` no permite modificar su monto.**

### Decision de diseño

El estado `confirmado` de la tarea anterior fue renombrado a `pagado` para
representar con claridad que el dinero ya fue transferido o registrado en la
realidad. El flujo de estados quedo:

- `pendiente` → `pagado` → `cancelado`

### funcion: `puedeEditarMonto(estado)`

Ubicada en `lib/utils/estado_movimiento.dart`. Devuelve `true` si el monto
se puede editar, o `false` si el estado es `pagado`.

```dart
bool puedeEditarMonto(String estado) {
  return estado != 'pagado';
}
```

### Comportamiento en la interfaz

Cuando el usuario presiona "Editar" sobre un movimiento `pagado`:
- El campo del monto queda deshabilitado (no se puede tocar).
- Aparece el mensaje explicativo:
  *"No es posible modificar el monto porque el movimiento ya fue pagado"*.
- Los demas campos (tipo, categoria, fecha) siguen siendo editables.

---

## Parte 4: Pruebas unitarias

Archivo: `test/movimiento_test.dart`

Se añadio la prueba 5 para verificar la restriccion de edicion de monto:

| # | Prueba | Que verifica |
|---|--------|--------------|
| 1 | Estado inicial es `pendiente` | Un movimiento nuevo empieza en `pendiente` |
| 2 | La accion hace la transicion esperada | `pendiente → pagado` y `pagado → cancelado` funcionan |
| 3 | Una transicion invalida es rechazada | `cancelado` no puede cambiar otra vez |
| 4 | Los demas datos se conservan | Al cambiar estado, `id`, `tipo`, `monto`, `categoria` y `fecha` no se alteran |
| 5 | Restriccion de monto en estado `pagado` | `puedeEditarMonto('pagado')` devuelve `false`; en `pendiente` y `cancelado` devuelve `true` |

### Como ejecutar

```bash
flutter test test/movimiento_test.dart
```

Resultado esperado:

```
+5: All tests passed!
```
