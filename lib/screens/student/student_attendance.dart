import 'package:flutter/material.dart';
import '../../services/attendance_service.dart';
import '../../models/attendance.dart';

class StudentAttendancePage extends StatefulWidget {
  final String studentId;

  const StudentAttendancePage({super.key, required this.studentId});

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<Attendance> attendanceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    final data = await AttendanceService().getAttendanceByStudent(
      widget.studentId,
    );

    setState(() {
      attendanceList = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("تحضير الطالب")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final att = attendanceList[index];

                return Card(
                  child: ListTile(
                    title: Text(
                      "التاريخ: ${att.date.toString().substring(0, 10)}",
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الحالة: ${att.status}"),
                        if (att.hifz != null) Text("الحفظ: ${att.hifz}"),
                        if (att.murajaah != null)
                          Text("المراجعة: ${att.murajaah}"),
                        if (att.notes != null) Text("ملاحظات: ${att.notes}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
