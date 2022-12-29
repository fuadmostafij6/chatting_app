import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllar/splasscontrollar.dart';
class SplassScreen extends StatelessWidget {
  const SplassScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder(
        init: SplasControllar(),
        builder: (_){
          return SafeArea(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      image:DecorationImage(
                        image: AssetImage("asset/spalash.jpg"),)
                  ),
                ),
              ));
        },

      ),
    );
  }
}
