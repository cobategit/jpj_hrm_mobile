import 'package:flutter/material.dart';

class BoxMenuBar extends StatelessWidget {
  final double? safeBlockVertical;
  final double? safeBlockHorizontal;
  final double? blockSizeHorizontal;
  final double? blockSizeVertical;
  final Color? color1;
  final Widget? child;
  const BoxMenuBar({
    Key? key,
    this.safeBlockVertical,
    this.safeBlockHorizontal,
    this.blockSizeHorizontal,
    this.blockSizeVertical,
    this.color1,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: safeBlockVertical! * 8.5,
      right: safeBlockHorizontal! * 3,
      child: Container(
        padding: EdgeInsets.only(
          left: blockSizeHorizontal! * 3.4,
          right: blockSizeHorizontal! * 5.8,
          top: blockSizeVertical! * 3.5,
          bottom: blockSizeVertical! * 3.94,
        ),
        decoration: BoxDecoration(
          color: color1,
          borderRadius: BorderRadius.circular(
            blockSizeVertical! * 2.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              blurRadius: 3.0,
              spreadRadius: 1.0,
              offset: const Offset(
                2.0, // Move to right 10  horizontally
                2.0, // Move to bottom 10 Vertically
              ),
            ),
          ],
        ),
        child: child!,
      ),
    );
  }
}

class CloseBar extends StatelessWidget {
  final double? safeBlockVertical;
  final double? safeBlockHorizontal;
  final double? blockSizeVertical;
  final Color? color1;
  final Function()? onTap;
  const CloseBar({
    Key? key,
    this.safeBlockVertical,
    this.safeBlockHorizontal,
    this.blockSizeVertical,
    this.color1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: safeBlockVertical! * 9.3,
      right: safeBlockHorizontal! * 6,
      child: InkWell(
        onTap: onTap!,
        child: Icon(
          Icons.close,
          color: color1,
          size: blockSizeVertical! * 3,
        ),
      ),
    );
  }
}
