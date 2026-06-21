import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhAttendancePage extends StatefulWidget {
  const SheikhAttendancePage({super.key});

  @override
  State<SheikhAttendancePage> createState() => _SheikhAttendancePageState();
}

class _SheikhAttendancePageState extends State<SheikhAttendancePage> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> students = [];
  bool loadingStudents = true;

  DateTime selectedDate = DateTime.now();
  String searchQuery = "";

  String getArabicDayName(DateTime date) {
    const days = [
      "الاثنين",
      "الثلاثاء",
      "الأربعاء",
      "الخميس",
      "الجمعة",
      "السبت",
      "الأحد",
    ];
    return days[date.weekday - 1];
  }

  @override
  void initState() {
    super.initState();

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

    loadStudents();
  }

  Future<void> loadStudents() async {
    final data = await supabase
        .from('students')
        .select('id, name')
        .order('name');

    if (data.isNotEmpty) {
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
    }

    setState(() => loadingStudents = false);
  }

  Future<void> loadAttendanceForDate() async {
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

    setState(() {});
  }

  Future<void> saveToSupabase() async {
    final date = DateFormat("yyyy-MM-dd").format(selectedDate);

    for (var student in students) {
      if (student["id"].toString().startsWith("dummy_")) continue;

      final existing = await supabase
          .from('attendance')
          .select()
          .eq('student_id', student['id'])
          .eq('date', date)
          .maybeSingle();

      if (existing == null) {
        await supabase.from('attendance').insert({
          'student_id': student['id'],
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("تم حفظ الحضور بنجاح")));
  }

  Widget buildCell(
    dynamic value,
    Function(dynamic) onChanged,
    Color primaryColor,
  ) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GestureDetector(
        onTap: () => onChanged(value == true ? null : true),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: value == null
                ? Colors.white
                : value == true
                ? primaryColor.withOpacity(0.2)
                : Colors.red.withOpacity(0.2),
          ),
          child: value == null
              ? null
              : Icon(
                  value == true ? Icons.check : Icons.close,
                  color: value == true ? primaryColor : Colors.red,
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    if (loadingStudents) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final filteredStudents = students
        .where((s) => s["name"].contains(searchQuery))
        .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("تسجيل حضور الطلاب"),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
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
                  "${getArabicDayName(selectedDate)} — ${DateFormat("yyyy/MM/dd").format(selectedDate)}",
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

            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                labelText: "بحث عن الطالب",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 40,
                columns: const [
                  DataColumn(label: Text("اسم الطالب")),
                  DataColumn(label: Text("الحضور")),
                  DataColumn(label: Text("الحفظ")),
                  DataColumn(label: Text("المراجعة")),
                  DataColumn(label: Text("التحكم")),
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
                        }, primaryColor),
                      ),

                      DataCell(
                        buildCell(student["hifz"], (v) {
                          setState(() => students[realIndex]["hifz"] = v);
                        }, primaryColor),
                      ),

                      DataCell(
                        buildCell(student["murajaah"], (v) {
                          setState(() => students[realIndex]["murajaah"] = v);
                        }, primaryColor),
                      ),

                      DataCell(
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  bool allTrue =
                                      students[realIndex]["present"] == true &&
                                      students[realIndex]["hifz"] == true &&
                                      students[realIndex]["murajaah"] == true;

                                  setState(() {
                                    if (allTrue) {
                                      students[realIndex]["present"] = null;
                                      students[realIndex]["hifz"] = null;
                                      students[realIndex]["murajaah"] = null;
                                    } else {
                                      students[realIndex]["present"] = true;
                                      students[realIndex]["hifz"] = true;
                                      students[realIndex]["murajaah"] = true;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text("صح للكل"),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  bool allFalse =
                                      students[realIndex]["present"] == false &&
                                      students[realIndex]["hifz"] == false &&
                                      students[realIndex]["murajaah"] == false;

                                  setState(() {
                                    if (allFalse) {
                                      students[realIndex]["present"] = null;
                                      students[realIndex]["hifz"] = null;
                                      students[realIndex]["murajaah"] = null;
                                    } else {
                                      students[realIndex]["present"] = false;
                                      students[realIndex]["hifz"] = false;
                                      students[realIndex]["murajaah"] = false;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text("غ"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: saveToSupabase,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text("حفظ الحضور", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
