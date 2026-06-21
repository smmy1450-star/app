import 'package:attendance_app/screens/supervisor/supervisor_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// صفحة الشيخ
import 'screens/sheikh/sheikh_attendance.dart';
// صفحة المشرف
import 'screens/supervisor/supervisor_home.dart';

// إضافة المتغير هنا فوق MyApp
ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

Future<void> main() async {
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
    // الاستماع لتغييرات الثيم (نهاري / ليلي)
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance App',

          // الثيمات
          themeMode: currentMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),

          // الصفحة الرئيسية
          home: const SheikhAttendancePage(),
        );
      },
    );
  }
}
