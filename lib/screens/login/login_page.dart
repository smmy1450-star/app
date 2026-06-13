import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// استيراد الصفحات حسب الأدوار
import 'package:attendance_app/screens/student/student_home.dart';
import 'package:attendance_app/screens/sheikh/sheikh_home.dart';
import 'package:attendance_app/screens/supervisor/supervisor_home.dart';
import 'package:attendance_app/screens/admin/admin_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String errorMessage = "";

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => errorMessage = "الرجاء إدخال الإيميل وكلمة المرور");
      return;
    }

    try {
      // 1) نجيب المستخدم بناءً على الإيميل فقط
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      if (response == null) {
        setState(() => errorMessage = "الإيميل غير موجود");
        return;
      }

      // 2) نتحقق من كلمة المرور داخل Flutter
      if (response['password'] != password) {
        setState(() => errorMessage = "كلمة المرور غير صحيحة");
        return;
      }

      final role = response['role'];

      if (!mounted) return;

      // 3) نوجّه المستخدم حسب الدور
      if (role == 'student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const StudentHome()),
        );
      } else if (role == 'sheikh') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SheikhHome()),
        );
      } else if (role == 'supervisor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SupervisorHome()),
        );
      } else if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );
      } else {
        setState(() => errorMessage = "دور المستخدم غير معروف");
      }
    } catch (e) {
      setState(() => errorMessage = "حدث خطأ أثناء تسجيل الدخول");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "تسجيل الدخول",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "الإيميل",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "كلمة المرور",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: login,
                child: const Text("تسجيل الدخول"),
              ),

              const SizedBox(height: 15),

              Text(errorMessage, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
