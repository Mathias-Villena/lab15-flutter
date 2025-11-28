import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'appointment_list_view.dart';
import 'profile_view.dart';
import '../auth/login_view.dart';

class HomeView extends StatefulWidget {
  final int userId;

  const HomeView({super.key, required this.userId});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int index = 0;

  late final screens = [
    AppointmentsListView(userId: widget.userId),
    ProfileView(userId: widget.userId),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppTheme.card,
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.white54,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Citas",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.logout),
            label: "Salir",
            tooltip: "Cerrar sesión",
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si el índice cambia a 2, hacer logout
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginView()),
      );
    }
  }
}
