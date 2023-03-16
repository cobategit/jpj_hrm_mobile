import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';

class AlertDialogMsg {
  static Future<void> showCupertinoDialogSimple(BuildContext? context,
      String? title, String? content, List<Widget>? listActions, hp) async {
    return showCupertinoDialog(
      context: context!,
      builder: (BuildContext context) => AlertDialog(
          title: Text(
            title!,
            style: TextStyle(
                fontSize: hp * 3,
                color: GlobalColor.green,
                fontWeight: FontWeight.w600,
                fontFamily: 'IconGlobal'),
          ),
          content: Text(
            content!,
            style: TextStyle(
                fontSize: hp * 2.5,
                color: GlobalColor.blue,
                fontWeight: FontWeight.w600,
                fontFamily: 'IconGlobal'),
          ),
          actions: listActions),
    );
  }
}
