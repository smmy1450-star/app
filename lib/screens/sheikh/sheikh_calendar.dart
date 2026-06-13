/*import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhCalendarPage extends StatefulWidget {
  const SheikhCalendarPage({super.key});

  @override
  State<SheikhCalendarPage> createState() => _SheikhCalendarPageState();
}

class _SheikhCalendarPageState extends State<SheikhCalendarPage> {
  bool loading = true;
  List<dynamic> events = [];

  @override
  void initState() {
    super.initState();
    loadCalendar();
  }

  Future<void> loadCalendar() async {
    final supabase = Supabase.instance.client;
    final authUser = supabase.auth.currentUser;

    if (authUser == null) return;

    // جلب بيانات الشيخ لمعرفة halaqa_id
    final sheikhData = await supabase
        .from('users')
        .select()
        .eq('id', authUser.id)
        .single();

    final halaqaId = sheikhData['halaqa_id'];

    // جلب أحداث الحلقة من جدول calendar
    final data = await supabase
        .from('calendar')
        .select()
        .eq('halaqa_id', halaqaId)
        .order('date', ascending: true);

    setState(() {
      events = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تقويم الحلقة"), centerTitle: true),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? const Center(
              child: Text(
                "لا يوجد أحداث في التقويم",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];

                return Card(
                  child: ListTile(
                    title: Text(event['title'] ?? "حدث بدون عنوان"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("التاريخ: ${event['date']}"),
                        if (event['description'] != null)
                          Text("الوصف: ${event['description']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
*/
