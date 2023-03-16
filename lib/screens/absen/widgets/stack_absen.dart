import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';

class StackAbsen extends StatelessWidget {
  final int? selectedIdxAbsen;
  const StackAbsen({Key? key, this.selectedIdxAbsen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [if (selectedIdxAbsen == 0) CheckInOutScreen()],
    );
  }
}
