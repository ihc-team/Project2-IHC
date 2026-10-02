import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import 'package:presupuesto_estudiantil/design_system/spacing_tokens.dart';
import 'package:presupuesto_estudiantil/design_system/app_text_style.dart';
import 'package:presupuesto_estudiantil/design_system/color_styles.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ColorStyles.primaryBase),
            child: Text(
              'Menú',
              style: AppTextStyle.boldBodyLarge.copyWith(
                color: ColorStyles.textInverse,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Movimientos'),
            onTap: () {
              Navigator.pop(context); // cierra el drawer
              context.go('/movements');
            },
          ),
          ListTile(
            leading: const Icon(Icons.key),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              Navigator.pop(context);
              context.go('/change-password');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              Navigator.pop(context);
              await AuthService().signOut();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
