import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../models/attendance.dart';

class StudentHifzPage extends StatefulWidget {
  final String studentId;

  const StudentHifzPage({super.key, required this.studentId});

  @override
  _StudentHifzPageState createState() => _StudentHifzPageState();
}

class _StudentHifzPageState extends State<StudentHifzPage> {
  List<Attendance> hifzList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHifz();
  }

  Future<void> loadHifz() async {
    final data = await AttendanceService().getAttendanceByStudent(
      widget.studentId,
    );

    setState(() {
      hifzList = data
          .where((a) => a.hifz != null || a.murajaah != null)
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("جدول الحفظ والمراجعة")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: hifzList.length,
              itemBuilder: (context, index) {
                final item = hifzList[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      "التاريخ: ${item.date.toString().substring(0, 10)}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.hifz != null) Text("الحفظ: ${item.hifz}"),
                        if (item.murajaah != null)
                          Text("المراجعة: ${item.murajaah}"),
                        if (item.notes != null) Text("ملاحظات: ${item.notes}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
