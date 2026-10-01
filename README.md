# Presupuesto Estudiantil

Aplicacion de presupuesto personal para estudiantes universitarios, desarrollada con **Flutter** y **Supabase** como proyecto de la materia Interaccion Humano-Computador (IHC).

Permite registrarse, iniciar sesion y gestionar movimientos financieros personales (ingresos y gastos) de forma segura.

---

## Integrantes

- Céspede Rodas Sebastian
- Mendoza Ribera Adolfo

---

## Tecnologías usadas

- [Flutter](https://flutter.dev/) — framework de UI multiplataforma
- [Supabase](https://supabase.com/) — backend como servicio (autenticacion y base de datos)
- [go_router](https://pub.dev/packages/go_router) — navegacion y proteccion de rutas
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) — manejo de variables de entorno

---

## Requisitos previos

Antes de correr el proyecto necesitás tener instalado:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable)
- Git

---

## Configuracion del entorno

El proyecto usa variables de entorno para las credenciales de Supabase. Estas **no están en el repositorio** por seguridad.

1. Crea un archivo `.env` en la raíz del proyecto (al mismo nivel que `pubspec.yaml`)
2. Pedile las credenciales a uno de los integrantes del equipo
3. El archivo debe tener este formato:

```
APP_NAME='Presupuesto Estudiantil'
SUPABASE_URL=https://xxxxxxxxxx.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Sin este archivo, la app no va a iniciar.

---

## Como correr el proyecto

```bash
# 1. Clonar el repositorio
git clone https://github.com/ihc-team/Project2-IHC.git
cd Project2-IHC

# 2. Instalar dependencias
flutter pub get

# 3. Iniciar la aplicacion
flutter run
```

Por defecto corre en Windows de escritorio. Para correr en Android, conectá un dispositivo o iniciá un emulador antes de `flutter run`.

---

## Funcionalidades implementadas

- ✅ Registro de usuario con email y contraseña
- ✅ Inicio de sesion
- ✅ Cierre de sesion
- ✅ Cambio de contraseña (usuario autenticado)
- ✅ Recuperacion de contraseña por email
- ✅ Persistencia de sesion (la app recuerda al usuario al reiniciarla)
- ✅ Rutas privadas protegidas (sin sesion no se puede acceder a movimientos)

---

## Estructura del proyecto

```
lib/
├── main.dart               # Punto de entrada, inicializa Supabase
├── router/
│   └── app_router.dart     # Rutas y redirecciones
├── services/
│   └── auth_service.dart   # Logica de autenticacion
└── screens/
    ├── home_screen.dart
    ├── login_screen.dart
    ├── register_screen.dart
    ├── movements_screen.dart
    ├── change_password_screen.dart
    └── reset_password_screen.dart
```

---

## Notas

- El archivo `.env` nunca debe subirse al repositorio (ya está en `.gitignore`)
- El proyecto de Supabase gratuito se pausa por inactividad; si la app no conecta, revisar que el proyecto esté activo en [supabase.com](https://supabase.com/)
