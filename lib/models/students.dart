class Student {
  final String id;
  final String? userId;
  final String? halaqaId;
  final String? parentPhone;
  final String? notes;

  Student({
    required this.id,
    this.userId,
    this.halaqaId,
    this.parentPhone,
    this.notes,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      userId: map['user_id'],
      halaqaId: map['halaqa_id'],
      parentPhone: map['parent_phone'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'halaqa_id': halaqaId,
      'parent_phone': parentPhone,
      'notes': notes,
    };
  }
}
