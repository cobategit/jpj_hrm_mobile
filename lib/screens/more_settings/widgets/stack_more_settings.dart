import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/screens/index.dart';
import 'package:jpj_hrm_mobile/screens/more_settings/settings_screen.dart';

class StackMoreSettings extends StatelessWidget {
  final int? selectedIdxMoreSettings;
  const StackMoreSettings({Key? key, this.selectedIdxMoreSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [if (selectedIdxMoreSettings == 0) SettingsScreen()],
    );
  }
}
