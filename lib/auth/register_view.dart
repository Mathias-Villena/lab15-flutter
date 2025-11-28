import 'package:flutter/material.dart';
import '../core/theme.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: const Center(
        child: Text(
          "Registro (Opcional)",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
