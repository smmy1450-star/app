class Halaqa {
  final String id;
  final String name;
  final String? mosque;
  final String? sheikhId;

  Halaqa({required this.id, required this.name, this.mosque, this.sheikhId});

  factory Halaqa.fromMap(Map<String, dynamic> map) {
    return Halaqa(
      id: map['id'],
      name: map['name'],
      mosque: map['mosque'],
      sheikhId: map['sheikh_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'mosque': mosque, 'sheikh_id': sheikhId};
  }
}
