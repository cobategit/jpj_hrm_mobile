import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:jpj_hrm_mobile/utils/index.dart';

class DropdownSearchCustomField extends StatelessWidget {
  final bool? isEnableMandatory;
  final bool? enabled;
  final String? labelText;
  final String? hintText;
  final Icon? icon;
  final Color? textStyleColor;
  final PopupProps<dynamic> popupProps;
  final Future<List<dynamic>> Function(String)? asyncItems;
  final List<String>? items;
  final String Function(dynamic)? itemAsString;
  final dynamic selectedItem;
  final void Function(dynamic)? onChanged;

  const DropdownSearchCustomField(
      {Key? key,
      this.isEnableMandatory = true,
      this.enabled,
      this.labelText,
      this.hintText,
      this.icon,
      this.textStyleColor,
      required this.popupProps,
      this.asyncItems,
      this.items,
      this.itemAsString,
      this.selectedItem,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: GlobalSize.blockSizeVertical! * 0.7),
          child: Row(
            children: [
              if (isEnableMandatory!) ...[
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
              SizedBox(width: GlobalSize.blockSizeHorizontal! * 1.0),
              Text(labelText.toString()),
            ],
          ),
        ),
        DropdownSearch<dynamic>(
          enabled: enabled!,
          dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.black26),
                  prefixIcon: icon,
                  contentPadding:
                      EdgeInsets.all(GlobalSize.blockSizeHorizontal! * 4.0),
                  enabledBorder: inputBorder(),
                  errorBorder: errorBorder(),
                  focusedBorder: focusBorder(),
                  focusedErrorBorder: focusErrorBorder(),
                  disabledBorder: disabledBorder()),
              baseStyle: TextStyle(color: textStyleColor)),
          popupProps: popupProps,
          asyncItems: asyncItems,
          items: items ?? [],
          itemAsString: itemAsString,
          selectedItem: selectedItem,
          onChanged: onChanged,
          validator: (dynamic data) {
            if (isEnableMandatory!) {
              if (data == null) {
                return "Data $labelText harus diisi";
              } else {
                return null;
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  OutlineInputBorder inputBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.black26,
          width: 1.5,
        ));
  }

  OutlineInputBorder disabledBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.black12,
          width: 1,
        ));
  }

  OutlineInputBorder errorBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2,
        ));
  }

  OutlineInputBorder focusBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.black,
          width: 2,
        ));
  }

  OutlineInputBorder focusErrorBorder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderSide: BorderSide(
          color: Colors.redAccent,
          width: 2,
        ));
  }
}
