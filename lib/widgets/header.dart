import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    this.height,
    this.width,
    this.color1,
    this.color2,
    this.color3,
    this.onPressedMenu,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? color1;
  final Color? color2;
  final Color? color3;
  final Function()? onPressedMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: color1,
          width: width! * 100,
          height: height! * 3.94,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height! * 2,
            bottom: height! * 2,
            left: width! * 4,
            right: width! * 4,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img/logo_header.png',
                    fit: BoxFit.contain,
                    width: width! * 21.46,
                    height: height! * 7.38,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Hi, Guest,!',
                    style: TextStyle(
                      fontSize: height! * 1.9,
                      fontWeight: FontWeight.w600,
                      color: color2,
                    ),
                  ),
                  InkWell(
                    onTap: onPressedMenu,
                    child: Icon(
                      Icons.menu,
                      size: height! * 4,
                      color: color3,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
