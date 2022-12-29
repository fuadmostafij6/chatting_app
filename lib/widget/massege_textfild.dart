import 'package:flutter/material.dart';
class MassageTextFildWidget extends StatelessWidget {
  TextEditingController controller;
  String name;
  Widget icon;
  Widget icon2;
  bool readOnly;
  Function(String) onChanged;
  Function() onTab;
  MassageTextFildWidget({Key? key, this.readOnly = false,
    required this.name,
    required this.icon,
    required this.controller,
    required this.icon2,
    required this.onTab,
  required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5,),
      // width: size.width*8.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0XFF6A62B7).withAlpha(50),
      ),
      child: TextField(
        maxLines: 8,
        minLines: 1,
        onTap: onTab,
        controller: controller,
        readOnly: readOnly,
        onChanged: onChanged,
        //10
        decoration: InputDecoration(
            hintText: name,
            suffixIcon: icon,
            border: InputBorder.none,
            prefixIcon: icon2,
        ),
      ),
    );
  }
}
