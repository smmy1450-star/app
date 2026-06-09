import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/calendar.dart';

class CalendarService {
  final supabase = Supabase.instance.client;

  // جلب حدث واحد حسب ID
  Future<CalendarEvent?> getEventById(String id) async {
    final data = await supabase.from('calendar').select().eq('id', id).single();

    return CalendarEvent.fromMap(data);
  }

  // جلب جميع الأحداث الخاصة بحلقة معيّنة
  Future<List<CalendarEvent>> getEventsByHalaqa(String halaqaId) async {
    final data = await supabase
        .from('calendar')
        .select()
        .eq('halaqa_id', halaqaId);

    return data
        .map<CalendarEvent>((map) => CalendarEvent.fromMap(map))
        .toList();
  }

  // جلب أحداث يوم معيّن
  Future<List<CalendarEvent>> getEventsByDate(DateTime date) async {
    final formattedDate = date.toIso8601String().substring(0, 10);

    final data = await supabase
        .from('calendar')
        .select()
        .eq('date', formattedDate);

    return data
        .map<CalendarEvent>((map) => CalendarEvent.fromMap(map))
        .toList();
  }

  // إضافة حدث جديد
  Future<void> addEvent(CalendarEvent event) async {
    await supabase.from('calendar').insert(event.toMap());
  }

  // تحديث حدث
  Future<void> updateEvent(String id, Map<String, dynamic> values) async {
    await supabase.from('calendar').update(values).eq('id', id);
  }

  // حذف حدث
  Future<void> deleteEvent(String id) async {
    await supabase.from('calendar').delete().eq('id', id);
  }
}
