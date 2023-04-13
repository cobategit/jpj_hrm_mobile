import 'package:flutter/material.dart';

class CloseKeyboardTapAnyWhr extends StatelessWidget {
  final Widget? child;
  const CloseKeyboardTapAnyWhr({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: child,
    );
  }
}
