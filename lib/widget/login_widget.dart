import 'package:flutter/material.dart';
class TextFildWidged extends StatelessWidget {
  TextEditingController controller;
  String name;
  Icon icon;

   TextFildWidged({Key? key,required this.name,required this.icon,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 12,right: 15),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5,),
        width: size.width*8.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Color(0XFF6A62B7).withAlpha(50),
        ),
        child: TextField(
          controller: controller,
         //10
          decoration: InputDecoration(
              hintText: name,
              icon: icon,
              border: InputBorder.none
          ),
        ),
      ),
    );
  }
}
