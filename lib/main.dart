import 'package:attendance_app/screens/login/login_page.dart';
import 'package:attendance_app/screens/supervisor/supervisor_home.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// صفحات الطالب
import 'screens/student/student_home.dart';
import 'screens/student/student_attendance.dart';
import 'screens/student/student_hifz.dart';
import 'screens/student/student_calendar.dart';

// صفحة الشيخ
import 'screens/supervisor/supervisor_home.dart';

// متحكم عام لتغيير الوضع (الشمس والقمر) في كامل التطبيق
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

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
    // استخدام ValueListenableBuilder للاستماع لتغييرات زر الشمس والقمر
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Attendance App',
          
          // تحديد الوضع الحالي للتطبيق
          themeMode: currentMode,

          // 1. ثيم الوضع الفاتح (درجات الأزرق الفاتح والملكي والأبيض)
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF8FAFC), // خلفية بيضاء مائلة للزرقة ناعمة
            primaryColor: const Color(0xFF0284C7), // أزرق سماوي ملوكي
            cardColor: Colors.white, // بطاقات بيضاء نقية
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF0F172A),
              elevation: 0,
            ),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0284C7),
              secondary: Color(0xFF38BDF8),
              surface: Colors.white,
            ),
          ),

          // 2. ثيم الوضع الداكن الفخم (درجات الكحلي والأزرق الداكن الملكي)
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF0A192F), // كحلي غامق فخم جداً (Midnight)
            primaryColor: const Color(0xFF00B4D8), // أزرق مضيء للعناصر الحيوية
            cardColor: const Color(0xFF112240), // كحلي أفتح للبطاقات والقوائم
            appBarTheme: const ColorScheme.dark().brightness == Brightness.dark
                ? const AppBarTheme(
                    backgroundColor: Color(0xFF0A192F),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  )
                : const AppBarTheme(),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00B4D8),
              secondary: Color(0xFF172A45),
              surface: Color(0xFF112240),
            ),
          ),

          // أول صفحة تظهر
          home: const SupervisorHome(),

          routes: {
            "/studentHome": (_) => StudentHome(),
            "/studentAttendance": (_) => StudentAttendancePage(studentId: "TEMP"),
            "/studentHifz": (_) => StudentHifzPage(studentId: "TEMP"),
            "/studentCalendar": (_) => StudentCalendarPage(halaqaId: "TEMP"),
          },
        );
      },
    );
  }
}