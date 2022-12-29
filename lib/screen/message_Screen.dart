// import 'dart:async';
// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../model/message_mdel.dart';
//
// class MessageScreen extends StatefulWidget {
//   final String? name;
//   final String? email;
//   final String? photo;
//   final String? uId;
//   const MessageScreen({Key? key, this.name, this.email, this.photo, this.uId})
//       : super(key: key);
//
//   @override
//   State<MessageScreen> createState() => _MessageScreenState();
// }
//
// class _MessageScreenState extends State<MessageScreen>
//     with SingleTickerProviderStateMixin {
//   bool emojiVisible = true;
//   Message? _message;
//   Map<String, dynamic> map = Map<String, dynamic>();
//   CollectionReference? _collectionReference;
//   DocumentSnapshot? documentSnapshot;
//   FirebaseAuth? _firebaseAuth = FirebaseAuth.instance;
//   String? _senderuid;
//   var listItem;
//   String? receiverPhotoUrl, senderPhotoUrl, receiverName, senderName;
//   StreamSubscription<DocumentSnapshot>? subscription;
//   File? imageFile;
//   final TextEditingController _messageController = TextEditingController();
//
//   @override
//   void initState() {
//     getUID().then((value) {
//       setState(() {
//         _senderuid = value!.uid;
//       });
//     });
//     super.initState();
//   }
//
//   Future<User?> getUID() async {
//     User? user = await _firebaseAuth!.currentUser;
//     return user;
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     subscription?.cancel();
//   }
//
//   void addMessageToDb(Message? message) async {
//     print("Message : ${message!.message}");
//     map = message.toMap();
//
//     print("Map : ${map}");
//     _collectionReference = FirebaseFirestore.instance
//         .collection("messages")
//         .doc(message.senderUid)
//         .collection(widget.uId!);
//
//     _collectionReference!.add(map).whenComplete(() {
//       print("Messages added to db");
//     });
//
//     _collectionReference = FirebaseFirestore.instance
//         .collection("messages")
//         .doc(widget.uId)
//         .collection(message.senderUid!);
//
//     _collectionReference!.add(map).whenComplete(() {
//       print("Messages added to db");
//     });
//
//     _messageController.text = "";
//   }
//
//   String changeButton = "";
//   String changeemoji = "";
//   String changefile = "";
//   String admin = "";
//   bool showMic = false;
//   bool readOnly = false;
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         iconTheme: IconThemeData(color: Colors.black),
//         elevation: 2,
//         backgroundColor: Colors.white,
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 15, right: 3, top: 10),
//           child: CircleAvatar(
//             radius: 30,
//             backgroundImage: NetworkImage("${widget.photo}"),
//             // maxRadius: 25,
//             // minRadius: 12,
//           ),
//         ),
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 18.0),
//               child: Text(
//                 "${widget.name}",
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 18,
//                     color: Colors.black),
//               ),
//             ),
//             Text(
//               "Online",
//               style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                   color: Colors.white),
//             ),
//           ],
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(top: 12, right: 12),
//             child: Icon(
//               Icons.video_call,
//               size: 30,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 12, right: 12),
//             child: Icon(
//               Icons.call,
//               size: 25,
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 12, right: 12),
//             child: Icon(
//               Icons.more_vert,
//               size: 25,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child:StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('messages')
//           .doc(_senderuid)
//           .collection(widget.uId!)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else {
//           listItem = snapshot.data!.docs;
//           return ListView.builder(
//             padding: EdgeInsets.all(10.0),
//             itemBuilder: (context, index) =>
//                 chatMessageItem(snapshot.data!.docs[index]),
//             itemCount: snapshot.data!.docs.length,
//           );
//         }
//       },
//     ),
//
//           ),
//
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _messageController,
//                   decoration: InputDecoration(
//                       hintText: "Send Message...",
//                       border: OutlineInputBorder()),
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   sendMessage();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Container(child: Text("Add")),
//                 ),
//               ),
//             ],
//           ),
//
//           // Expanded(
//           //   child: Column(
//           //
//           //     children: [
//           //       Bubble(
//           //         margin: BubbleEdges.only(top: 15),
//           //         nip: BubbleNip.leftTop,
//           //         child: Text("Hi Developer"),
//           //       ),
//           //       Bubble(
//           //         margin: BubbleEdges.only(top: 15),
//           //         alignment: Alignment.bottomRight,
//           //         nip: BubbleNip.rightBottom,
//           //         color: Color.fromRGBO(225, 255, 199, 1.0),
//           //         child: Text("Hello Developer"),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//
//           // Row(
//           //   children: [
//           //     Expanded(
//           //       child: MassageTextFildWidget(
//           //         onTab: (){
//           //          setState(() {
//           //
//           //
//           //            emojiVisible=true;
//           //          });
//           //         },
//           //         icon: GestureDetector(
//           //           onTap: (){
//           //
//           //           },
//           //             child: Icon(Icons.file_copy)),
//           //         icon2:GestureDetector(
//           //           onTap: (){
//           //             setState(() {
//           //               emojiVisible=!emojiVisible;
//           //               FocusScope.of(context).unfocus();
//           //
//           //             });
//           //
//           //           },
//           //
//           //             child: Icon(Icons.emoji_emotions,))
//           //         ,controller: _messageController,
//           //       readOnly:readOnly ,
//           //        onChanged: (value){
//           //           setState(() {
//           //             changeButton=value;
//           //             print("Data....${changeButton}");
//           //           });
//           //        },
//           //       name: "Type Messages....",),
//           //     ),
//           //
//           //
//           //
//           //     changeButton !=""|| changeemoji!="" || changefile!="" ?  GestureDetector(
//           //           onTap: () {
//           //
//           //             setState(() {
//           //
//           //             });
//           //           },
//           //           child: Container(
//           //             height: 50,
//           //             width: 50,
//           //             decoration: BoxDecoration(
//           //               color: Theme.of(context).primaryColor,
//           //               borderRadius: BorderRadius.circular(30),
//           //             ),
//           //             child: const Center(
//           //                 child: Icon(
//           //                   Icons.send,
//           //                   color: Colors.white,
//           //                 )),
//           //           ),
//           //         )
//           //
//           //     : RecordButton(controller: _messageController)
//           //
//           //   ],
//           // ),
//
//           //  emojiPicker()
//         ],
//       ),
//     );
//   }
//
//   Widget chatMessageItem(DocumentSnapshot documentSnapshot) {
//     return buildChatLayout(documentSnapshot);
//   }
//   void sendMessage() async {
//     print("Inside send message");
//     var text = _messageController.text;
//     print(text);
//     _message = Message(
//         receiverUid: widget.uId,
//         senderUid: _senderuid,
//         message: text,
//         type: 'text');
//     print(
//         "receiverUid: ${widget.uId} , senderUid : ${_senderuid} , message: ${text}");
//     print(
//         "timestamp: ${DateTime.now().millisecond}, type: ${text != null ? 'text' : 'image'}");
//     addMessageToDb(_message);
//   }
//   Widget buildChatLayout(DocumentSnapshot snapshot) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             mainAxisAlignment: snapshot['senderUid'] == _senderuid?
//             MainAxisAlignment.end : MainAxisAlignment.start,
//             children: <Widget>[
//
//               SizedBox(
//                 width: 10.0,
//               ),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   snapshot['senderUid'] == _senderuid
//                       ?  Text(
//                     senderName == null ? "" : senderName.toString(),
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold),
//                   )
//                       :  Text(
//                     receiverName == null ? "" : receiverName.toString(),
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   snapshot['type'] == 'text'
//                       ?  Text(
//                     snapshot['message'],
//                     style: TextStyle(color: Colors.black, fontSize: 14.0),
//                   ) : Container()
//                 ],
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//   //  emojiPicker(){
//   //
//   //  return Offstage(
//   //    offstage: emojiVisible,
//   //    child: SizedBox(
//   //      height: 250,
//   //      child: EmojiPicker(
//   //        onEmojiSelected: (Category,Emoji emoji){
//   //          setState(() {
//   //            changeButton =emoji.emoji.toString();
//   //          });
//   //          print(emoji.name);
//   //          print(emoji.emoji);
//   //        },
//   //        onBackspacePressed: (){
//   //        },
//   //        textEditingController: massegeControllar,
//   //        config:Config(
//   //          columns: 7,
//   //          emojiSizeMax: 32,// Issue: https://github.com/flutter/flutter/issues/28894
//   //          verticalSpacing: 0,
//   //          horizontalSpacing: 0,
//   //          gridPadding: EdgeInsets.zero,
//   //          initCategory: Category.RECENT,
//   //          bgColor: Color(0xFFF2F2F2),
//   //          indicatorColor: Colors.blue,
//   //          iconColor: Colors.grey,
//   //          iconColorSelected: Colors.blue,
//   //          backspaceColor: Colors.blue,
//   //          skinToneDialogBgColor: Colors.white,
//   //          skinToneIndicatorColor: Colors.grey,
//   //          enableSkinTones: true,
//   //          showRecentsTab: true,
//   //          recentsLimit: 28,
//   //          noRecents: const Text(
//   //            'No Recents',
//   //            style: TextStyle(fontSize: 20, color: Colors.black26),
//   //            textAlign: TextAlign.center,
//   //          ), // Needs to be const Widget
//   //          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
//   //          tabIndicatorAnimDuration: kTabScrollDuration,
//   //          categoryIcons: const CategoryIcons(),
//   //          buttonMode: ButtonMode.MATERIAL,
//   //        ),
//   //      ),
//   //    ),
//   //  );
//   // }
//
// }
