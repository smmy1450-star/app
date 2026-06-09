class CalendarEvent {
  final String id;
  final String? title;
  final String? description;
  final DateTime date;
  final String halaqaId;

  CalendarEvent({
    required this.id,
    this.title,
    this.description,
    required this.date,
    required this.halaqaId,
  });

  factory CalendarEvent.fromMap(Map<String, dynamic> map) {
    return CalendarEvent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.parse(map['date']),
      halaqaId: map['halaqa_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'halaqa_id': halaqaId,
    };
  }
}
