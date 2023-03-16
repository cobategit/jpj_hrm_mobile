import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class BottomNavScreen extends StatefulWidget {
  final int? selectedIdx;
  final int? selectedIdxAbsen;
  final int? selectedIdxAttendance;
  final int? selectedIdxLeave;
  final int? selectedIdxMoreSettings;
  const BottomNavScreen({
    Key? key,
    this.selectedIdx,
    this.selectedIdxAbsen,
    this.selectedIdxAttendance,
    this.selectedIdxLeave,
    this.selectedIdxMoreSettings,
  }) : super(key: key);

  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _pages = <Widget>[];
  int _currentIdx = 0;
  Widget? _currentPage;
  int tmpSelectedIdxAbsen = 0;
  int tmpSeletedIdxAttendance = 0;
  int tmpSelectedIdxLeave = 0;
  int tmpSelectedIdxMoreSettings = 0;

  @override
  void initState() {
    if (widget.selectedIdxAbsen != null) {
      tmpSelectedIdxAbsen = widget.selectedIdxAbsen!;
    }

    if (widget.selectedIdxLeave != null) {
      tmpSelectedIdxLeave = widget.selectedIdxLeave!;
    }

    if (widget.selectedIdxAttendance != null) {
      tmpSeletedIdxAttendance = widget.selectedIdxAttendance!;
    }

    if (widget.selectedIdxMoreSettings != null) {
      tmpSelectedIdxMoreSettings = widget.selectedIdxMoreSettings!;
    }

    _pages = [
      StackAbsen(
        selectedIdxAbsen: tmpSelectedIdxAbsen,
      ),
      StackAttendance(
        selectedIdxAttendance: tmpSeletedIdxAttendance,
      ),
      StackLeave(
        selectedIdxLeave: tmpSelectedIdxLeave,
      ),
      StackMoreSettings(
        selectedIdxMoreSettings: tmpSelectedIdxMoreSettings,
      )
    ];

    changeBottomNav(widget.selectedIdx!);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  changeBottomNav(int idx) {
    setState(() {
      _currentIdx = idx;
      _currentPage = _pages[idx];
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    GlobalSize().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _currentPage,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: GlobalSize.blockSizeVertical! * 1,
          top: GlobalSize.blockSizeVertical! * 1,
        ),
        // height: hp * 0.064,
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 1.2,
              offset: Offset(0.0, 0.6),
            )
          ],
          color: Color(0xFFFFFFFF),
        ),
        child: CustomBottomNavigationBar(
          defaultSelectedIndex: _currentIdx,
          iconList: const [
            FontAwesome5.home,
            IconGlobal.iconreportattendance,
            IconGlobal.iconleave,
            Icons.settings,
          ],
          text: const ['Home', 'Attendance', 'Leave', 'Settings'],
          hp: GlobalSize.safeBlockVertical,
          onChange: (val) {
            changeBottomNav(val);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
