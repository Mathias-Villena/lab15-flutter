import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../database/appointment_database.dart';
import '../models/appointment.dart';

class AppointmentDetailsView extends StatefulWidget {
  final AppointmentModel? appointment;

  const AppointmentDetailsView({super.key, this.appointment});

  @override
  State<AppointmentDetailsView> createState() =>
      _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState extends State<AppointmentDetailsView> {
  final patientCtrl = TextEditingController();
  final doctorCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  DateTime selectedDate = DateTime.now();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    if (widget.appointment != null) {
      isEditing = true;
      patientCtrl.text = widget.appointment!.patientName;
      doctorCtrl.text = widget.appointment!.doctorName;
      notesCtrl.text = widget.appointment!.notes;
      selectedDate = widget.appointment!.date;
    }
  }

  save() async {
    if (isEditing) {
      await AppointmentDatabase.instance.update(
        AppointmentModel(
          id: widget.appointment!.id,
          patientName: patientCtrl.text,
          doctorName: doctorCtrl.text,
          notes: notesCtrl.text,
          date: selectedDate,
        ),
      );
    } else {
      await AppointmentDatabase.instance.create(
        AppointmentModel(
          patientName: patientCtrl.text,
          doctorName: doctorCtrl.text,
          notes: notesCtrl.text,
          date: selectedDate,
        ),
      );
    }
    Navigator.pop(context);
  }

  delete() async {
    await AppointmentDatabase.instance.delete(widget.appointment!.id!);
    Navigator.pop(context);
  }

  pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: delete,
            ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: save,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInput(patientCtrl, "Paciente", Icons.person),
            const SizedBox(height: 16),
            buildInput(doctorCtrl, "Doctor", Icons.medical_services),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Fecha: ${selectedDate.toString().split(" ")[0]}",
                  style: const TextStyle(color: Colors.white),
                ),
                IconButton(
                  onPressed: pickDate,
                  icon: const Icon(Icons.calendar_month, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: notesCtrl,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: "Notas...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: AppTheme.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppTheme.primary),
        hintText: label,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: AppTheme.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
