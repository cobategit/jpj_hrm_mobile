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
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
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
    this.onSaved,
    this.validator,
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
              BorderRadius.circular(GlobalSize.blockSizeVertical! * 2)),
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
            fontSize: GlobalSize.safeBlockVertical! * 2.1,
            color: GlobalColor.blue),
        maxLength: maxLength,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: GlobalSize.safeBlockVertical! * 2.1,
              color: GlobalColor.blue),
          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          hintText: hintText,
          hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: GlobalSize.safeBlockVertical! * 2.1,
              color: GlobalColor.blue),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: GlobalColor.blue,
            ),
            borderRadius: BorderRadius.circular(
              GlobalSize.blockSizeVertical! * 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: GlobalColor.blue),
            borderRadius: BorderRadius.circular(
              GlobalSize.blockSizeVertical! * 2,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(
              GlobalSize.blockSizeVertical! * 2,
            ),
          ),
          contentPadding: contentPadding,
          counterText: "",
          suffixIcon: suffixIcon,
        ),
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
