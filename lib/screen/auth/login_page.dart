import 'dart:io';

import 'package:chetingapp/screen/home_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../widget/login_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  bool islogin = true;
  Animation<double>? conteinarsize;
  AnimationController? animationController;
  Duration animationDuretion = Duration(microseconds: 250);

  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loder = false;

  TextEditingController namecontrollar = TextEditingController();
  TextEditingController emailcontrollar = TextEditingController();
  TextEditingController passwordcontrollar = TextEditingController();

  File? _fileImage;
  ImagePicker imagePicker = ImagePicker();
  String  ?imagePath;

  void takePhoto(ImageSource source) async {
    final pickedFile =
        await imagePicker.getImage(source: source, imageQuality: 50);
    setState(() {
      _fileImage = File(pickedFile!.path);
    });
    Reference reference = FirebaseStorage.instance.ref().child(DateTime.now().toString());
    await reference.putFile(File(_fileImage!.path));
    reference.getDownloadURL().then((value) {
      setState(() {
        imagePath =value;
        print("PROFILE Pic Image Path--$imagePath");
      });
    });

  }

  @override
  void initState() {

    super.initState();

    animationController =
        AnimationController(vsync: this, duration: animationDuretion);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    double viewInset = MediaQuery.of(context)
        .viewInsets
        .bottom; // we are using this to determine Keyboard is opened or not
    var defaultLoginSize = size.height - (size.height * 0.2);
    var defaultRegisterSize = size.height - (size.height * 0.1);

    conteinarsize =
        Tween<double>(begin: size.height * 0.1, end: defaultRegisterSize)
            .animate(CurvedAnimation(
                parent: animationController!, curve: Curves.linear));

    return Scaffold(
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: islogin ? 0.0 : 0.3,
            duration: animationDuretion,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                height: size.height * 0.1,
                child: IconButton(
                    onPressed: () {
                      animationController!.reverse();
                      setState(() {
                        islogin = !islogin;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.pink,
                    )),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: defaultLoginSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to our community",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
                    ),
                    SizedBox(height: 15),
                    SvgPicture.asset(
                      "asset/login.svg",
                      height: 200,
                      width: 200,
                    ),
                    TextFildWidged(
                      name: "Email",
                      icon: Icon(
                        Icons.email,
                        color: Color(0XFF6A62B7),
                      ),
                      controller: emailcontrollar,
                    ),
                    TextFildWidged(
                      name: "password",
                      icon: Icon(
                        Icons.lock,
                        color: Color(0XFF6A62B7),
                      ),
                      controller: passwordcontrollar,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      onTap: () {
                        login();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 65, right: 65),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0XFF6A62B7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: loder
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.pink,
                                      ),
                                    )
                                  : Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: animationController!,
            builder: (context, child) {
              if (viewInset == 0 && islogin) {
                return defouldRegister();
              } else if (!islogin) {
                return defouldRegister();
              }
              return Container();
            },
          ),
          Visibility(
            visible: !islogin,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: defaultLoginSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "WelCome to our community",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 15),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _fileImage==null ? Container() :    CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.blue,
                            backgroundImage: FileImage(File(_fileImage!.path)),

                            // backgroundImage: ,
                          ),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: Text("Upload Image"),
                                      content: SingleChildScrollView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            TextButton(
                                                onPressed: () {
                                                  takePhoto(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Camera")),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  takePhoto(
                                                      ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Gallery")),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 18.0,
                              ),
                              child: Icon(
                                Icons.camera,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFildWidged(
                        name: "Name",
                        icon: Icon(
                          Icons.person,
                          color: Color(0XFF6A62B7),
                        ),
                        controller: namecontrollar,
                      ),
                      TextFildWidged(
                        name: "Email",
                        icon: Icon(
                          Icons.email,
                          color: Color(0XFF6A62B7),
                        ),
                        controller: emailcontrollar,
                      ),
                      TextFildWidged(
                        name: "password",
                        icon: Icon(
                          Icons.lock,
                          color: Color(0XFF6A62B7),
                        ),
                        controller: passwordcontrollar,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () {
                          register();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 65, right: 65),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0XFF6A62B7),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: loder
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Text(
                                        "SingUp",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget defouldRegister() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: conteinarsize!.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(100), topLeft: Radius.circular(100)),
            color: Color(0XFFE5E5E5),
          ),
          alignment: Alignment.center,
          child: GestureDetector(
              onTap: () {
                animationController!.forward();
                setState(() {
                  islogin = !islogin;
                });
              },
              child: islogin
                  ? Text(
                      "New User ? Register",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF6A62B7)),
                    )
                  : null),
        ),
      ),
    );
  }

  Future login() async {
    try {
      setState(() {
        loder = true;
      });

      await _auth.signInWithEmailAndPassword(
          email: emailcontrollar.text, password: passwordcontrollar.text);

      Fluttertoast.showToast(
          msg: "successful login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.to(HomeScreen());
      setState(() {
        loder = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        Fluttertoast.showToast(
            msg: "${error.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        loder = false;
      });
    }
  }

  Future register() async {
    try {
      setState(() {
        loder = true;
      });

      final user = await _auth.createUserWithEmailAndPassword(
          email: emailcontrollar.text, password: passwordcontrollar.text);

      if (user.user != null) {
        userdetels();

        animationController!.reverse();
        setState(() {
          islogin = !islogin;
        });
      }

      Fluttertoast.showToast(
          msg: "successful register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Get.to(LoginScreen());
      setState(() {
        loder = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        Fluttertoast.showToast(
            msg: "${error.message}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        loder = false;
      });
    }
  }

  Future userdetels() async {
    await FirebaseFirestore.instance.collection("user").add({
      "name": namecontrollar.text,
      "email": emailcontrollar.text,
      "uid": _auth.currentUser!.uid,
      "photo": imagePath ?? "",
      "status": true,
    });
  }
}
