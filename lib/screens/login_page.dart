import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/user_service.dart';
import '../../models/users.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    try {
      // تسجيل الدخول من Supabase Auth
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final authUser = response.user;

      if (authUser == null) {
        throw Exception("Login failed");
      }

      // جلب بيانات المستخدم من جدول users
      final userData = await UserService().getUserById(authUser.id);

      if (userData == null) {
        throw Exception("User not found in database");
      }

      // التوجيه حسب الدور
      navigateByRole(userData);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ في تسجيل الدخول")));
    }

    setState(() => isLoading = false);
  }

  void navigateByRole(AppUser user) {
    if (user.role == "student") {
      Navigator.pushReplacementNamed(context, "/studentHome");
    } else if (user.role == "sheikh") {
      Navigator.pushReplacementNamed(context, "/sheikhHome");
    } else if (user.role == "supervisor") {
      Navigator.pushReplacementNamed(context, "/supervisorHome");
    } else if (user.role == "admin") {
      Navigator.pushReplacementNamed(context, "/adminHome");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تسجيل الدخول",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "الإيميل"),
            ),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "كلمة المرور"),
            ),

            SizedBox(height: 20),

            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: Text("تسجيل الدخول")),
          ],
        ),
      ),
    );
  }
}
