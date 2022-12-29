// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
//  class ImageChatWidget extends StatefulWidget {
//    final String ? collectionId;
//    const ImageChatWidget({Key? key, this.collectionId}) : super(key: key);
//
//    @override
//    State<ImageChatWidget> createState() => _ImageChatWidgetState();
//  }
//
//  class _ImageChatWidgetState extends State<ImageChatWidget> {
//    CollectionReference _collectionReference = FirebaseFirestore.instance.collection("user");
//
//    @override
//    Widget build(BuildContext context) {
//      return FutureBuilder(
//        future:_collectionReference.doc(widget.collectionId).get(),
//        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//
//
//          Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
//
//          if(snapshot.hasData){
//            return    Stack(
//              children: [
//                CircleAvatar(
//                  backgroundImage: NetworkImage(data["photo"]),
//                  maxRadius: 35,
//                  minRadius: 18,
//                ),
//                Positioned(
//                    left: 43,
//                    top: 35,
//                    child: Container(
//                      width: 15,
//                      height: 15,
//
//                      decoration: BoxDecoration(
//                          color: Colors.white,
//                          borderRadius: BorderRadius.circular(100)
//                      ),
//                      child: Center(
//                        child: Container(
//                          width: 8,
//                          height: 8,
//                          decoration: BoxDecoration(
//                              color: Colors.lightGreen,
//                              borderRadius: BorderRadius.circular(100)
//                          ),
//                        ),
//                      ),
//                    ))
//              ],
//            );
//
//          }else{
//            return Center(child: Container(child: CircularProgressIndicator(
//              color:  Color(0XFF6A62B7),
//            ),));
//          }
//
//
//        },
//      );
//    }
//  }
