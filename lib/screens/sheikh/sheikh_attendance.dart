import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhAttendancePage extends StatefulWidget {
  const SheikhAttendancePage({super.key});

  @override
  State<SheikhAttendancePage> createState() => _SheikhAttendancePageState();
}

class _SheikhAttendancePageState extends State<SheikhAttendancePage> {
  List<dynamic> students = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final supabase = Supabase.instance.client;

    // جلب الطلاب من جدول users حسب الدور
    final data = await supabase
        .from('users')
        .select()
        .eq('role', 'student');

    setState(() {
      students = data;
      loading = false;
    });
  }

  Future<void> saveAttendance(String studentId, String status) async {
    final supabase = Supabase.instance.client;

    await supabase.from('attendance').insert({
      'student_id': studentId,
      'status': status,
      'date': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم تسجيل $status")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل حضور الطلاب"),
        centerTitle: true,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];

                return Card(
                  child: ListTile(
                    title: Text(student['name']),
                    subtitle: Text(student['email']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle, color: Colors.green),
                          onPressed: () => saveAttendance(student['id'], "حاضر"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => saveAttendance(student['id'], "غائب"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time, color: Colors.orange),
                          onPressed: () => saveAttendance(student['id'], "متأخر"),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
