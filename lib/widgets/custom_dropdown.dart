import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class CustomDropdownMenu extends StatelessWidget {
  final String? value;
  final String? hinText;
  final List<DropdownMenuItem<String>>? items;
  final double? hp;
  final double? wp;
  final bool? isExpanded;
  final EdgeInsetsGeometry? margin;
  final Function(dynamic)? onChanged;
  final Function()? onTap;
  const CustomDropdownMenu(
      {Key? key,
      this.value,
      this.hinText,
      this.items,
      this.hp,
      this.wp,
      this.margin,
      this.isExpanded,
      this.onChanged,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Container(
      color: GlobalColor.light,
      height: GlobalSize.blockSizeVertical! * hp!,
      width: GlobalSize.blockSizeHorizontal! * wp!,
      margin: margin,
      child: DropdownButtonFormField(
        value: value,
        items: items,
        onChanged: onChanged,
        onTap: onTap,
        isExpanded: isExpanded ?? false,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: GlobalSize.safeBlockVertical! * 2,
          color: GlobalColor.blue,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: GlobalSize.blockSizeHorizontal! * 2),
          filled: true,
          fillColor: GlobalColor.light,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GlobalColor.blue),
              borderRadius:
                  BorderRadius.circular(GlobalSize.blockSizeVertical! * 2)),
          border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(GlobalSize.blockSizeVertical! * 2),
              borderSide: const BorderSide(color: Colors.white)),
          hintText: hinText!,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: GlobalSize.safeBlockVertical! * 2,
              color: GlobalColor.blue),
        ),
      ),
    );
  }
}
