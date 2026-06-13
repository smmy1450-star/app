import 'package:flutter/material.dart';
import 'manage_users.dart';
import 'manage_halaqat.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("لوحة المدير"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            _buildButton(
              context,
              title: "إدارة المستخدمين",
              icon: Icons.people,
              page: const ManageUsersPage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "إدارة الحلقات",
              icon: Icons.school,
              page: const ManageHalaqatPage(),
            ),

            const SizedBox(height: 15),

            _buildButton(
              context,
              title: "التقارير العامة",
              icon: Icons.bar_chart,
              page: const ManageHalaqatPage(), // placeholder
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
