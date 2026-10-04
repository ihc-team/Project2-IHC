String? siguienteEstado(String estadoActual) {
  if (estadoActual == 'pendiente') {
    return 'confirmado';
  }
  if (estadoActual == 'confirmado') {
    return 'cancelado';
  }
  return null;
}

bool esTransicionValida(String actual, String nuevo) {
  return siguienteEstado(actual) == nuevo;
}
