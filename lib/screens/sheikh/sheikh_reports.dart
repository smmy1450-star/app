import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhReportsPage extends StatefulWidget {
  const SheikhReportsPage({super.key});

  @override
  State<SheikhReportsPage> createState() => _SheikhReportsPageState();
}

class _SheikhReportsPageState extends State<SheikhReportsPage> {
  List<dynamic> students = [];
  List<dynamic> attendance = [];
  List<dynamic> hifz = [];

  bool loading = true;
  String? selectedStudent;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('users')
        .select()
        .eq('role', 'student');

    setState(() {
      students = data;
      loading = false;
    });
  }

  Future<void> loadReports() async {
    final studentId = selectedStudent;
    if (studentId == null) return;

    final supabase = Supabase.instance.client;

    final att = await supabase
        .from('attendance')
        .select()
        .eq('student_id', studentId);

    final hifzData = await supabase
        .from('hifz')
        .select()
        .eq('student_id', studentId);

    setState(() {
      attendance = att;
      hifz = hifzData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تقارير الطلاب"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  DropdownButtonFormField<dynamic>(
                    decoration: const InputDecoration(
                      labelText: "اختر الطالب",
                      border: OutlineInputBorder(),
                    ),
                    value: selectedStudent,
                    items: students.map((student) {
                      return DropdownMenuItem(
                        value: student['id'],
                        child: Text(student['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectedStudent = value as String?);
                      loadReports();
                    },
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          "سجل الحضور",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...attendance.map((att) {
                          return Card(
                            child: ListTile(
                              title: Text("التاريخ: ${att['date'].toString().substring(0, 10)}"),
                              subtitle: Text("الحالة: ${att['status']}"),
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 25),
                        const Text(
                          "سجل الحفظ والمراجعة",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...hifz.map((h) {
                          return Card(
                            child: ListTile(
                              title: Text("التاريخ: ${h['date'].toString().substring(0, 10)}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("الحفظ: ${h['hifz']}"),
                                  Text("المراجعة: ${h['murajaah']}"),
                                  if (h['notes'] != null)
                                    Text("ملاحظات: ${h['notes']}"),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}