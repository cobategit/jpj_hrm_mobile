import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class CustomAppBar extends StatelessWidget {
  final Function()? onPressedSearch;
  final String? textJudul;
  final String? textUsername;
  final bool automaticallyImplyLeading;
  final bool checkNetwork;
  const CustomAppBar({
    Key? key,
    this.onPressedSearch,
    this.textJudul,
    this.textUsername,
    this.automaticallyImplyLeading = true,
    this.checkNetwork = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return AppBar(
      backgroundColor: GlobalColor.blue,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Image.asset(
          //   "assets/img/logo_header.png",
          //   height: GlobalSize.blockSizeVertical! * 4.5,
          // ),
          Container(
            margin: EdgeInsets.only(left: GlobalSize.blockSizeHorizontal! * 1),
            height: 25,
            width: 25,
            decoration: BoxDecoration(
                color: checkNetwork ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(100)
                //more than 50% of width makes circle
                ),
          ),
          Text(textJudul!,
              style: TextStyle(
                  fontSize: GlobalSize.blockSizeVertical! * 2.4,
                  fontWeight: FontWeight.bold,
                  color: GlobalColor.light,
                  fontFamily: 'IconGlobal')),
          Text(textUsername!,
              style: TextStyle(
                  fontSize: GlobalSize.blockSizeVertical! * 1.8,
                  fontWeight: FontWeight.bold,
                  color: GlobalColor.light,
                  fontFamily: 'IconGlobal')),
        ],
      ),
    );
  }
}
