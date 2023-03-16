import 'package:flutter/material.dart';
import 'package:jpj_hrm_mobile/configs/index.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int? defaultSelectedIndex;
  final double? hp;
  final Function(int)? onChange;
  final List<IconData>? iconList;
  final List<String>? text;

  const CustomBottomNavigationBar(
      {Key? key,
      this.defaultSelectedIndex = 0,
      @required this.iconList,
      this.text,
      @required this.hp,
      @required this.onChange})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];
  List<String> _text = [];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.defaultSelectedIndex!;
    _iconList = widget.iconList!;
    _text = widget.text!;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], _text[i], i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, String text, int index) {
    return GestureDetector(
      onTap: () {
        widget.onChange!(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
        decoration: BoxDecoration(
            color:
                index == _selectedIndex ? GlobalColor.blue : GlobalColor.light,
            borderRadius: BorderRadius.circular(widget.hp! * 1.8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: widget.hp! * 2.9,
              color: index == _selectedIndex
                  ? GlobalColor.light
                  : GlobalColor.grey,
            ),
            index == _selectedIndex
                ? Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: widget.hp! * 1.5,
                          fontWeight: index == _selectedIndex
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: index == _selectedIndex
                              ? GlobalColor.light
                              : GlobalColor.grey,
                          fontFamily: 'IconGlobal'),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
