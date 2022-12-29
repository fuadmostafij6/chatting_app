// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class UserList extends StatefulWidget {
//
//
//   final String ? collectionId;
//
//   const UserList({Key? key, this.collectionId}) : super(key: key);
//
//   @override
//   State<UserList> createState() => _UserListState();
// }
//
// class _UserListState extends State<UserList> {
//
//
//
//   CollectionReference _collectionReference = FirebaseFirestore.instance.collection("user");
//
//   @override
//   Widget build(BuildContext context) {
//     return  FutureBuilder(
//       future:_collectionReference.doc(widget.collectionId).get(),
//       builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//
//
//         Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
//
//         if(snapshot.hasData){
//           return
//             Padding(
//             padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
//             child: Container(
//               decoration: BoxDecoration(
//                   color: Colors.white60.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(10)
//               ),
//               child:ListTile(
//                 leading:CircleAvatar(
//                   backgroundImage: NetworkImage("${data["photo"]}"),
//                   maxRadius: 22,
//                   minRadius: 10,
//                 ),
//                 title: Text("${data["name"]}",style: TextStyle(fontSize: 14,
//                     fontWeight:FontWeight.bold,
//                     color: Colors.black54),),
//                 subtitle: Text("hello... ",style: TextStyle(fontSize: 12,
//                     fontWeight:FontWeight.bold,
//                     color: Colors.black54),),),
//             ),
//           );
//         }else{
//           return Center(child: Container(child: CircularProgressIndicator(
//             color:  Color(0XFF6A62B7),
//           ),));
//         }
//
//
//       },
//     );
//
//   }
// }
