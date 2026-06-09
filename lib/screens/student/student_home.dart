import 'package:flutter/material.dart';

class StudentHome extends StatelessWidget {
  final String? studentName;

  const StudentHome({super.key, this.studentName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("واجهة الطالب"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحبًا ${studentName ?? "بالطالب"} 👋",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/studentAttendance");
              },
              child: Text("عرض التحضير"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/studentHifz");
              },
              child: Text("جدول الحفظ"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/studentCalendar");
              },
              child: Text("التقويم"),
            ),
          ],
        ),
      ),
    );
  }
}
