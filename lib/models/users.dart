class AppUser {
  final String id;
  final String fullName;
  final String? phone;
  final String role;
  final String? halaqaId;

  AppUser({
    required this.id,
    required this.fullName,
    this.phone,
    required this.role,
    this.halaqaId,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'],
      fullName: map['full_name'],
      phone: map['phone'],
      role: map['role'],
      halaqaId: map['halaqa_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'halaqa_id': halaqaId,
    };
  }
}
