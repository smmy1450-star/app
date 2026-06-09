class Attendance {
  final String id;
  final String studentId;
  final DateTime date;
  final String status;
  final String? hifz;
  final String? murajaah;
  final String? notes;
  final bool approvedBySheikh;

  Attendance({
    required this.id,
    required this.studentId,
    required this.date,
    required this.status,
    this.hifz,
    this.murajaah,
    this.notes,
    required this.approvedBySheikh,
  });

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'],
      studentId: map['student_id'],
      date: DateTime.parse(map['date']),
      status: map['status'],
      hifz: map['hifz'],
      murajaah: map['murajaah'],
      notes: map['notes'],
      approvedBySheikh: map['approved_by_sheikh'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'date': date.toIso8601String(),
      'status': status,
      'hifz': hifz,
      'murajaah': murajaah,
      'notes': notes,
      'approved_by_sheikh': approvedBySheikh,
    };
  }
}
