import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/halaqat.dart';

class HalaqaService {
  final supabase = Supabase.instance.client;

  // جلب حلقة واحدة حسب ID
  Future<Halaqa?> getHalaqaById(String id) async {
    final data = await supabase.from('halaqat').select().eq('id', id).single();

    return Halaqa.fromMap(data);
  }

  // جلب جميع الحلقات
  Future<List<Halaqa>> getAllHalaqat() async {
    final data = await supabase.from('halaqat').select();

    return data.map<Halaqa>((map) => Halaqa.fromMap(map)).toList();
  }

  // جلب الحلقات الخاصة بشيخ معيّن
  Future<List<Halaqa>> getHalaqatBySheikh(String sheikhId) async {
    final data = await supabase
        .from('halaqat')
        .select()
        .eq('sheikh_id', sheikhId);

    return data.map<Halaqa>((map) => Halaqa.fromMap(map)).toList();
  }

  // إضافة حلقة جديدة
  Future<void> addHalaqa(Halaqa halaqa) async {
    await supabase.from('halaqat').insert(halaqa.toMap());
  }

  // تحديث حلقة
  Future<void> updateHalaqa(String id, Map<String, dynamic> values) async {
    await supabase.from('halaqat').update(values).eq('id', id);
  }

  // حذف حلقة
  Future<void> deleteHalaqa(String id) async {
    await supabase.from('halaqat').delete().eq('id', id);
  }
}
