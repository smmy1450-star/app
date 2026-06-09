import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/attendance.dart';

class AttendanceService {
  final supabase = Supabase.instance.client;

  // جلب تحضير حسب ID
  Future<Attendance?> getAttendanceById(String id) async {
    final data = await supabase
        .from('attendance')
        .select()
        .eq('id', id)
        .single();

    return Attendance.fromMap(data);
  }

  // جلب تحضير طالب معيّن
  Future<List<Attendance>> getAttendanceByStudent(String studentId) async {
    final data = await supabase
        .from('attendance')
        .select()
        .eq('student_id', studentId);

    return data.map<Attendance>((map) => Attendance.fromMap(map)).toList();
  }

  // جلب تحضير يوم معيّن لحلقة معيّنة
  Future<List<Attendance>> getAttendanceByDate(
    String halaqaId,
    DateTime date,
  ) async {
    final data = await supabase
        .from('attendance')
        .select('*, students!inner(halaqa_id)')
        .eq('students.halaqa_id', halaqaId)
        .eq('date', date.toIso8601String().substring(0, 10));

    return data.map<Attendance>((map) => Attendance.fromMap(map)).toList();
  }

  // إضافة تحضير جديد
  Future<void> addAttendance(Attendance attendance) async {
    await supabase.from('attendance').insert(attendance.toMap());
  }

  // تحديث تحضير
  Future<void> updateAttendance(String id, Map<String, dynamic> values) async {
    await supabase.from('attendance').update(values).eq('id', id);
  }

  // حذف تحضير
  Future<void> deleteAttendance(String id) async {
    await supabase.from('attendance').delete().eq('id', id);
  }
}
