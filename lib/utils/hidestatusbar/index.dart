import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HideStatusBar extends StatelessWidget {
  final Widget? child;
  const HideStatusBar({Key? key, this.child}) : super(key: key);

  void hideStatusBar(PointerEvent dtls) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.bottom,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerUp: hideStatusBar,
      onPointerMove: hideStatusBar,
      onPointerDown: hideStatusBar,
      child: child,
    );
  }
}
