import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';

class StackLeave extends StatelessWidget {
  final int? selectedIdxLeave;
  const StackLeave({Key? key, this.selectedIdxLeave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (selectedIdxLeave == 0) LeaveScreen(),
        if (selectedIdxLeave == 1) HistoryLeaveScreen(),
        if (selectedIdxLeave == 2) FormLeaveScreen(),
      ],
    );
  }
}
