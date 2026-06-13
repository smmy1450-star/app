// TODO Implement this library.
import 'package:flutter/material.dart';
import 'supervisor_reports.dart';

class SupervisorHome extends StatelessWidget {
  const SupervisorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("لوحة المشرف"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            _buildButton(
              context,
              title: "تقارير الحلقات",
              icon: Icons.bar_chart,
              page: const SupervisorReportsPage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "تقارير الطلاب",
              icon: Icons.people,
              page: const SupervisorReportsPage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "حضور الحلقات",
              icon: Icons.check_circle,
              page: const SupervisorReportsPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        textStyle: const TextStyle(fontSize: 20),
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
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
