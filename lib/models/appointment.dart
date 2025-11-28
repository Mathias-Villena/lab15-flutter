class AppointmentFields {
  static const tableName = 'appointments';

  static const id = '_id';
  static const patientName = 'patient_name';
  static const doctorName = 'doctor_name';
  static const date = 'date';
  static const notes = 'notes';

  static const values = [
    id,
    patientName,
    doctorName,
    date,
    notes,
  ];
}

class AppointmentModel {
  int? id;
  final String patientName;
  final String doctorName;
  final DateTime date;
  final String notes;

  AppointmentModel({
    this.id,
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.notes,
  });

  Map<String, Object?> toJson() => {
        AppointmentFields.id: id,
        AppointmentFields.patientName: patientName,
        AppointmentFields.doctorName: doctorName,
        AppointmentFields.date: date.toIso8601String(),
        AppointmentFields.notes: notes,
      };

  static AppointmentModel fromJson(Map<String, Object?> json) => AppointmentModel(
        id: json[AppointmentFields.id] as int?,
        patientName: json[AppointmentFields.patientName] as String,
        doctorName: json[AppointmentFields.doctorName] as String,
        date: DateTime.parse(json[AppointmentFields.date] as String),
        notes: json[AppointmentFields.notes] as String,
      );

  AppointmentModel copy({
    int? id,
    String? patientName,
    String? doctorName,
    DateTime? date,
    String? notes,
  }) =>
      AppointmentModel(
        id: id ?? this.id,
        patientName: patientName ?? this.patientName,
        doctorName: doctorName ?? this.doctorName,
        date: date ?? this.date,
        notes: notes ?? this.notes,
      );
}
