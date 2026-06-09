import 'package:flutter/material.dart';
import '../../services/calendar_service.dart';
import '../../models/calendar.dart';

class StudentCalendarPage extends StatefulWidget {
  final String halaqaId;

  const StudentCalendarPage({super.key, required this.halaqaId});

  @override
  _StudentCalendarPageState createState() => _StudentCalendarPageState();
}

class _StudentCalendarPageState extends State<StudentCalendarPage> {
  List<CalendarEvent> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final data = await CalendarService().getEventsByHalaqa(widget.halaqaId);

    setState(() {
      events = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تقويم الحلقة")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return Card(
                  child: ListTile(
                    title: Text(event.title ?? "حدث بدون عنوان"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "التاريخ: ${event.date.toString().substring(0, 10)}",
                        ),
                        if (event.description != null)
                          Text("الوصف: ${event.description}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
