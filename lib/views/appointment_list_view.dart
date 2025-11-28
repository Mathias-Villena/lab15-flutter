import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../database/appointment_database.dart';
import '../widgets/appointment_card.dart';
import '../models/appointment.dart';
import 'appointment_details_view.dart';

class AppointmentsListView extends StatefulWidget {
  final int userId;

  const AppointmentsListView({super.key, required this.userId});

  @override
  State<AppointmentsListView> createState() => _AppointmentsListViewState();
}

class _AppointmentsListViewState extends State<AppointmentsListView> {
  List<AppointmentModel> appointments = [];

  loadData() async {
    appointments = await AppointmentDatabase.instance.readAllByUser(widget.userId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Mis Citas"),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailsView(userId: widget.userId),
            ),
          );
          loadData();
        },
        child: const Icon(Icons.add),
      ),
      body: appointments.isEmpty
          ? const Center(
              child: Text("No hay citas registradas",
                  style: TextStyle(color: Colors.white70)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (_, i) {
                final appt = appointments[i];
                return AppointmentCard(
                  appointment: appt,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            AppointmentDetailsView(appointment: appt, userId: widget.userId),
                      ),
                    );
                    loadData();
                  },
                );
              },
            ),
    );
  }
}
