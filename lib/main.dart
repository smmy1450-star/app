import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_page.dart';
import 'screens/student/student_home.dart';
import 'screens/student/student_attendance.dart';
import 'screens/student/student_hifz.dart';
import 'screens/student/student_calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zlbvjprsbjopdooasrty.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpsYnZqcHJzYmpvcGRvb2FzcnR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4MjA2MDYsImV4cCI6MjA5NjM5NjYwNn0.CUD-CJNsk9bwQyaju8x0RRWrp31fDa2DDT3fqTv3NCU',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // أول صفحة تظهر
      home: LoginPage(),

      routes: {
        "/studentHome": (_) => StudentHome(),
        "/studentAttendance": (_) => StudentAttendancePage(studentId: "TEMP"),
        "/studentHifz": (_) => StudentHifzPage(studentId: "TEMP"),
        "/studentCalendar": (_) => StudentCalendarPage(halaqaId: "TEMP"),
      },
    );
  }
}
