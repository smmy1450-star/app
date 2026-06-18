import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupervisorReportsPage extends StatefulWidget {
  const SupervisorReportsPage({super.key});

  @override
  State<SupervisorReportsPage> createState() => _SupervisorReportsPageState();
}

class _SupervisorReportsPageState extends State<SupervisorReportsPage> {
  bool loading = true;

  List<dynamic> halaqat = [];
  List<dynamic> students = [];
  List<dynamic> sheikhs = [];

  List<dynamic> attendance = [];
  List<dynamic> hifz = [];

  String? selectedHalaqa;
  String? selectedStudent;
  String? selectedSheikh;

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  Future<void> loadFilters() async {
    final supabase = Supabase.instance.client;

    final hData = await supabase.from('halaqat').select();
    final sData = await supabase.from('users').select().eq('role', 'student');
    final shData = await supabase.from('users').select().eq('role', 'sheikh');

    setState(() {
      halaqat = hData;
      students = sData;
      sheikhs = shData;
      loading = false;
    });
  }

  Future<void> loadReports() async {
    final supabase = Supabase.instance.client;

    var queryAttendance = supabase.from('attendance').select();
    var queryHifz = supabase.from('hifz').select();

    if (selectedHalaqa != null) {
      queryAttendance = queryAttendance.eq('halaqa_id', selectedHalaqa!);
      queryHifz = queryHifz.eq('halaqa_id', selectedHalaqa!);
    }

    if (selectedStudent != null) {
      queryAttendance = queryAttendance.eq('student_id', selectedStudent!);
      queryHifz = queryHifz.eq('student_id', selectedStudent!);
    }

    if (selectedSheikh != null) {
      queryAttendance = queryAttendance.eq('sheikh_id', selectedSheikh!);
      queryHifz = queryHifz.eq('sheikh_id', selectedSheikh!);
    }

    final att = await queryAttendance;
    final h = await queryHifz;

    setState(() {
      attendance = att;
      hifz = h;
    });
  }

  Widget _buildDropdown({
    required String label,
    required List<dynamic> items,
    required String? value,
    required Function(String?) onChanged,
    required String valueKey,
    required String textKey,
  }) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item[valueKey].toString(),
          child: Text(item[textKey]),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تقارير المشرف"), centerTitle: true),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDropdown(
                    label: "اختر الحلقة",
                    items: halaqat,
                    value: selectedHalaqa,
                    valueKey: 'id',
                    textKey: 'name',
                    onChanged: (v) {
                      setState(() => selectedHalaqa = v);
                      loadReports();
                    },
                  ),

                  const SizedBox(height: 15),

                  _buildDropdown(
                    label: "اختر الطالب",
                    items: students,
                    value: selectedStudent,
                    valueKey: 'id',
                    textKey: 'name',
                    onChanged: (v) {
                      setState(() => selectedStudent = v);
                      loadReports();
                    },
                  ),

                  const SizedBox(height: 15),

                  _buildDropdown(
                    label: "اختر الشيخ",
                    items: sheikhs,
                    value: selectedSheikh,
                    valueKey: 'id',
                    textKey: 'name',
                    onChanged: (v) {
                      setState(() => selectedSheikh = v);
                      loadReports();
                    },
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      children: [
                        const Text(
                          "سجل الحضور",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...attendance.map((att) {
                          return Card(
                            child: ListTile(
                              title: Text("التاريخ: ${att['date']}"),
                              subtitle: Text("الحالة: ${att['status']}"),
                            ),
                          );
                        }).toList(),

                        const SizedBox(height: 25),

                        const Text(
                          "سجل الحفظ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        ...hifz.map((h) {
                          return Card(
                            child: ListTile(
                              title: Text("التاريخ: ${h['date']}"),
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
