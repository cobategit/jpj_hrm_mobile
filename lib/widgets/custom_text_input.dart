import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? textController;
  final String? hintText;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? contentPadding;
  final bool? readOnly;
  final Function()? onTap;
  final Function(String)? onChanged;
  final double? hp;
  final double? wp;
  final String? labelText;
  final int? maxLength;
  final int? maxLines;
  final bool? obscureText;
  final Widget? suffixIcon;
  const CustomTextInput({
    Key? key,
    this.textController,
    this.hintText,
    this.margin,
    this.contentPadding,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.hp,
    this.wp,
    this.labelText,
    this.maxLength,
    this.maxLines,
    this.obscureText = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalSize().init(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(GlobalSize.blockSizeVertical! * 0.6)),
      margin: margin,
      height: hp,
      width: wp,
      child: TextFormField(
        obscureText: obscureText!,
        controller: textController,
        cursorColor: Colors.blue,
        readOnly: readOnly!,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: GlobalSize.safeBlockVertical! * 1.7,
            color: GlobalColor.blue),
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: GlobalSize.safeBlockVertical! * 1.6,
              color: GlobalColor.blue),
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: GlobalSize.safeBlockVertical! * 1.7,
              color: GlobalColor.blue),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: GlobalColor.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: GlobalColor.blue)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(
              GlobalSize.blockSizeVertical! * 1,
            ),
          ),
          contentPadding: contentPadding,
          counterText: "",
          suffixIcon: suffixIcon,
        ),
        onTap: onTap,
        onChanged: onChanged,
      ),
    );
  }
}
