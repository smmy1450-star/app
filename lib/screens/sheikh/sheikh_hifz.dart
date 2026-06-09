import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SheikhHifzPage extends StatefulWidget {
  const SheikhHifzPage({super.key});

  @override
  State<SheikhHifzPage> createState() => _SheikhHifzPageState();
}

class _SheikhHifzPageState extends State<SheikhHifzPage> {
  List<dynamic> students = [];
  bool loading = true;

  String? selectedStudent;
  final hifzController = TextEditingController();
  final murajaahController = TextEditingController();
  final notesController = TextEditingController();

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

  Future<void> saveHifz() async {
    if (selectedStudent == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("الرجاء اختيار الطالب")),
      );
      return;
    }

    final supabase = Supabase.instance.client;

    try {
      await supabase.from('hifz').insert({
        'student_id': selectedStudent,
        'hifz': hifzController.text.trim(),
        'murajaah': murajaahController.text.trim(),
        'notes': notesController.text.trim(),
        'date': DateTime.now().toIso8601String(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ بيانات الحفظ بنجاح")),
      );

      hifzController.clear();
      murajaahController.clear();
      notesController.clear();
      setState(() => selectedStudent = null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء الحفظ: $e")),
      );
    }
  }

  @override
  void dispose() {
    hifzController.dispose();
    murajaahController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تسجيل الحفظ والمراجعة"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
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
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: hifzController,
                      decoration: const InputDecoration(
                        labelText: "مقدار الحفظ",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: murajaahController,
                      decoration: const InputDecoration(
                        labelText: "مقدار المراجعة",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "ملاحظات",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: saveHifz,
                        child: const Text("حفظ البيانات", style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}