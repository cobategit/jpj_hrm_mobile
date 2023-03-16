import 'package:flutter/material.dart';

class GlobalButtonElevated extends StatelessWidget {
  final String? tittle;
  final Function()? onPressed;
  final double? fontSize;
  final Color? color;
  final Color? colorPrim;
  final Color? colorOnPrim;
  final Color? colorShadowPrim;
  final double? borderRadius;
  final double? sizeH;
  final double? sizeW;

  const GlobalButtonElevated(
      {Key? key,
      this.tittle,
      this.onPressed,
      this.fontSize,
      this.color,
      this.borderRadius,
      this.sizeH,
      this.sizeW,
      this.colorPrim,
      this.colorOnPrim,
      this.colorShadowPrim})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        tittle!,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
        ),
      ),
      style: ElevatedButton.styleFrom(
        elevation: 2,
        primary: colorPrim,
        onPrimary: colorOnPrim,
        shadowColor: colorShadowPrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius!,
          ),
        ),
        minimumSize: Size(
          sizeW!,
          sizeH!,
        ),
      ),
    );
  }
}
