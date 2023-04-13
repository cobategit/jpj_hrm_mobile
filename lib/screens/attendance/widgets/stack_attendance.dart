import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';

class StackAttendance extends StatelessWidget {
  final int? selectedIdxAttendance;
  const StackAttendance({Key? key, this.selectedIdxAttendance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [if (selectedIdxAttendance == 0) AttendanceScreen()],
    );
  }
}
