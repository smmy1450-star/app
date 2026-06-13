import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhAttendancePage extends StatefulWidget {
  const SheikhAttendancePage({super.key});

  @override
  State<SheikhAttendancePage> createState() => _SheikhAttendancePageState();
}

class _SheikhAttendancePageState extends State<SheikhAttendancePage> {
  List<Map<String, dynamic>> students = [];
  bool loadingStudents = true;

  DateTime selectedDate = DateTime.now();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  // -----------------------------
  // جلب الطلاب من Supabase + صفوف افتراضية
  // -----------------------------
  Future<void> loadStudents() async {
    final supabase = Supabase.instance.client;

    final data = await supabase
        .from('students')
        .select('id, name')
        .order('name');

    if (data.isEmpty) {
      // صفوف افتراضية إذا ما فيه طلاب
      students = List.generate(
        5,
        (i) => {
          "id": "dummy_$i",
          "name": "—",
          "present": null,
          "hifz": null,
          "murajaah": null,
        },
      );

      setState(() {
        loadingStudents = false;
      });

      return;
    }

    students = data
        .map(
          (s) => {
            "id": s['id'],
            "name": s['name'],
            "present": null,
            "hifz": null,
            "murajaah": null,
          },
        )
        .toList();

    await loadAttendanceForDate();

    if (mounted) {
      setState(() {
        loadingStudents = false;
      });
    }
  }

  // -----------------------------
  // جلب الحضور حسب التاريخ
  // -----------------------------
  Future<void> loadAttendanceForDate() async {
    final supabase = Supabase.instance.client;
    final date = DateFormat("yyyy-MM-dd").format(selectedDate);

    final data = await supabase.from('attendance').select().eq('date', date);

    for (var student in students) {
      final record = data.firstWhere(
        (row) => row['student_id'] == student['id'],
        orElse: () => {},
      );

      if (record.isNotEmpty) {
        student["present"] = record["status"];
        student["hifz"] = record["hifz"];
        student["murajaah"] = record["murajaah"];
      } else {
        student["present"] = null;
        student["hifz"] = null;
        student["murajaah"] = null;
      }
    }

    if (mounted) setState(() {});
  }

  // -----------------------------
  // حفظ الحضور
  // -----------------------------
  Future<void> saveToSupabase() async {
    final supabase = Supabase.instance.client;
    final date = DateFormat("yyyy-MM-dd").format(selectedDate);

    for (var student in students) {
      if (student["id"].toString().startsWith("dummy_")) continue;

      final studentId = student["id"];

      final existing = await supabase
          .from('attendance')
          .select()
          .eq('student_id', studentId)
          .eq('date', date)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('attendance').insert({
          'student_id': studentId,
          'date': date,
          'status': student["present"] ?? false,
          'hifz': student["hifz"] ?? false,
          'murajaah': student["murajaah"] ?? false,
        });
      } else {
        await supabase
            .from('attendance')
            .update({
              'status': student["present"] ?? false,
              'hifz': student["hifz"] ?? false,
              'murajaah': student["murajaah"] ?? false,
            })
            .eq('id', existing['id']);
      }
    }

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم حفظ الحضور بنجاح")));
  }

  // -----------------------------
  // تصميم الخانة
  // -----------------------------
  Widget buildCell(dynamic value, Function(dynamic) onChanged) {
    if (value == true) {
      return Checkbox(
        value: true,
        onChanged: (_) => onChanged(null),
        activeColor: Colors.green,
      );
    }

    return GestureDetector(
      onTap: () => onChanged(true),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
      ),
    );
  }

  // -----------------------------
  // صح للكل
  // -----------------------------
  void markAll(int index) {
    setState(() {
      students[index]["present"] = true;
      students[index]["hifz"] = true;
      students[index]["murajaah"] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadingStudents) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredStudents = students
        .where((s) => s["name"].contains(searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل حضور الطلاب"),
        centerTitle: true,
        backgroundColor: Colors.pink,
      ),

      body: Column(
        children: [
          // التاريخ + السابق + التالي + اختيار التاريخ
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async {
                    setState(() {
                      selectedDate = selectedDate.subtract(
                        const Duration(days: 1),
                      );
                    });
                    await loadAttendanceForDate();
                  },
                ),

                Text(
                  "تاريخ اليوم: ${DateFormat("yyyy/MM/dd").format(selectedDate)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                    });
                    await loadAttendanceForDate();
                  },
                ),

                const SizedBox(width: 20),

                ElevatedButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );

                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                      await loadAttendanceForDate();
                    }
                  },
                  child: const Text("اختيار تاريخ"),
                ),
              ],
            ),
          ),

          // البحث
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: "بحث عن الطالب",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),
          ),

          const SizedBox(height: 10),

          // الجدول
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 40,
                columns: const [
                  DataColumn(label: Text("اسم الطالب")),
                  DataColumn(label: Text("الحضور")),
                  DataColumn(label: Text("الحفظ")),
                  DataColumn(label: Text("المراجعة")),
                  DataColumn(label: Text("صح للكل")),
                ],
                rows: List.generate(filteredStudents.length, (index) {
                  final student = filteredStudents[index];
                  final realIndex = students.indexOf(student);

                  return DataRow(
                    cells: [
                      DataCell(Text(student["name"])),

                      DataCell(
                        buildCell(student["present"], (v) {
                          setState(() => students[realIndex]["present"] = v);
                        }),
                      ),

                      DataCell(
                        buildCell(student["hifz"], (v) {
                          setState(() => students[realIndex]["hifz"] = v);
                        }),
                      ),

                      DataCell(
                        buildCell(student["murajaah"], (v) {
                          setState(() => students[realIndex]["murajaah"] = v);
                        }),
                      ),

                      DataCell(
                        ElevatedButton(
                          onPressed: () => markAll(realIndex),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("صح للكل"),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),

          // زر حفظ
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              onPressed: saveToSupabase,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text("حفظ الحضور", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
