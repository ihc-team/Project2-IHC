String? siguienteEstado(String estadoActual) {
  if (estadoActual == 'pendiente') {
    return 'pagado';
  }
  if (estadoActual == 'pagado') {
    return 'cancelado';
  }
  return null;
}

bool esTransicionValida(String actual, String nuevo) {
  return siguienteEstado(actual) == nuevo;
}
