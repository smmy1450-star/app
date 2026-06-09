import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/students.dart';

class StudentService {
  final supabase = Supabase.instance.client;

  // جلب طالب واحد حسب ID
  Future<Student?> getStudentById(String id) async {
    final data = await supabase.from('students').select().eq('id', id).single();

    return Student.fromMap(data);
  }

  // جلب جميع الطلاب داخل حلقة معينة
  Future<List<Student>> getStudentsByHalaqa(String halaqaId) async {
    final data = await supabase
        .from('students')
        .select()
        .eq('halaqa_id', halaqaId);

    return data.map<Student>((map) => Student.fromMap(map)).toList();
  }

  // إضافة طالب جديد
  Future<void> addStudent(Student student) async {
    await supabase.from('students').insert(student.toMap());
  }

  // تحديث بيانات طالب
  Future<void> updateStudent(String id, Map<String, dynamic> values) async {
    await supabase.from('students').update(values).eq('id', id);
  }

  // حذف طالب
  Future<void> deleteStudent(String id) async {
    await supabase.from('students').delete().eq('id', id);
  }
}
