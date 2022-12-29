
import 'package:chetingapp/screen/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screen/home_screen.dart';

class SplasControllar extends GetxController {
  String? user;
  FirebaseAuth auth= FirebaseAuth.instance;
  @override
  void onReady() {
    auth.currentUser != null ? Future.delayed(Duration(seconds: 3), () {
      Get.offAll(HomeScreen());
    }) : Future.delayed(Duration(seconds: 3), () {
      Get.offAll(LoginScreen());
      super.onReady();
    });
  }
}