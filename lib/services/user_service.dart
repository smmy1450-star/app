import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/users.dart';

class UserService {
  final supabase = Supabase.instance.client;

  // جلب بيانات مستخدم حسب الـ id
  Future<AppUser?> getUserById(String id) async {
    final data = await supabase.from('users').select().eq('id', id).single();

    return AppUser.fromMap(data);
  }

  // إضافة مستخدم جديد
  Future<void> addUser(AppUser user) async {
    await supabase.from('users').insert(user.toMap());
  }

  // تحديث بيانات مستخدم
  Future<void> updateUser(String id, Map<String, dynamic> values) async {
    await supabase.from('users').update(values).eq('id', id);
  }

  // حذف مستخدم
  Future<void> deleteUser(String id) async {
    await supabase.from('users').delete().eq('id', id);
  }
}
