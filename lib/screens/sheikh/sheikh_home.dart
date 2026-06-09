import 'package:flutter/material.dart';
import 'sheikh_attendance.dart';
import 'sheikh_hifz.dart';
import 'sheikh_reports.dart';

class SheikhHome extends StatelessWidget {
  const SheikhHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("لوحة الشيخ"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            const SizedBox(height: 20),

            _buildButton(
              context,
              title: "تسجيل حضور الطلاب",
              icon: Icons.check_circle,
              page: const SheikhAttendancePage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "تسجيل الحفظ والمراجعة",
              icon: Icons.menu_book,
              page: const SheikhHifzPage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "تقارير الطلاب",
              icon: Icons.bar_chart,
              page: const SheikhReportsPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String title, required IconData icon, required Widget page}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
    );
  }
}
