import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../database/user_database.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  void register() async {
    if (nameCtrl.text.isEmpty ||
        emailCtrl.text.isEmpty ||
        passCtrl.text.isEmpty ||
        confirmPassCtrl.text.isEmpty) {
      setState(() => errorMessage = 'Completa todos los campos');
      return;
    }

    if (passCtrl.text != confirmPassCtrl.text) {
      setState(() => errorMessage = 'Las contraseñas no coinciden');
      return;
    }

    if (passCtrl.text.length < 4) {
      setState(() => errorMessage = 'La contraseña debe tener mínimo 4 caracteres');
      return;
    }

    setState(() => isLoading = true);

    final newUser = await UserDatabase.instance.register(
      emailCtrl.text,
      passCtrl.text,
      nameCtrl.text,
    );

    if (!mounted) return;

    if (newUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Registro exitoso! Ahora inicia sesión')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    } else {
      setState(() => errorMessage = 'Este correo ya está registrado');
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 80, color: AppTheme.primary),
            const SizedBox(height: 20),
            const Text(
              "Crear Cuenta",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            buildInput(nameCtrl, "Nombre Completo", Icons.person),
            const SizedBox(height: 15),
            buildInput(emailCtrl, "Correo", Icons.email),
            const SizedBox(height: 15),
            buildInput(passCtrl, "Contraseña", Icons.lock, isPass: true),
            const SizedBox(height: 15),
            buildInput(confirmPassCtrl, "Confirmar Contraseña", Icons.lock, isPass: true),
            const SizedBox(height: 10),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoading ? null : register,
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Registrarse",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("¿Ya tienes cuenta? ",
                    style: TextStyle(color: Colors.white54)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    "Inicia sesión",
                    style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController ctrl, String text, IconData icon,
      {bool isPass = false}) {
    return TextField(
      controller: ctrl,
      obscureText: isPass,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.primary),
        hintText: text,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: AppTheme.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmPassCtrl.dispose();
    super.dispose();
  }
}
