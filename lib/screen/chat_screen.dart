import 'package:bubble/bubble.dart';
import 'package:chetingapp/model/message_mdel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userUid;
  final String? userPhoto;
  const ChatScreen(
      {Key? key, this.userName, this.userEmail, this.userUid, this.userPhoto})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Message? message;
  Map<String, dynamic> map = Map<String, dynamic>();
  CollectionReference? collectionReference;
  DocumentSnapshot? documentSnapshot;
  FirebaseAuth? _firebaseAuth = FirebaseAuth.instance;
  String? _senderId;
  final TextEditingController _messageController = TextEditingController();

  Future<User?> getUid() async {
    User? user = await _firebaseAuth!.currentUser;
    return user;
  }

  void addMessage(Message message) async {
    map = message.toMap();

    collectionReference = FirebaseFirestore.instance
        .collection("messages")
        .doc(message.senderUid)
        .collection(widget.userUid!);

    collectionReference!.add(map).whenComplete(() {
      print("Message added to database sender ");
    });

    collectionReference = FirebaseFirestore.instance
        .collection("messages")
        .doc(widget.userUid)
        .collection(message.senderUid!);

    collectionReference!.add(map).whenComplete(() {
      print("Message added to database receiver");
    });
    _messageController.text = "";
  }

  void sendMessage() async {
    var text = _messageController.text;
    print("Message text___${text}");
    message = Message(
        receiverUid: widget.userUid,
        senderUid: _senderId,
        message: text,
        type: "text");

    addMessage(message!);
    setState(() {});
  }

  @override
  void initState() {
    getUid().then((value) {
      setState(() {
        _senderId = value!.uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 400,
        centerTitle: true,
        leading: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("${widget.userPhoto}"),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.userName}",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(
                  _senderId,
                )
                .collection(widget.userUid!)
                .snapshots(),
            builder: (context, snapshot) {
              return ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot documentdata =
                      snapshot.data!.docs[index];

                  return Row(
                    mainAxisAlignment: documentdata['senderUid'] == _senderId
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Bubble(
                          color: Colors.green,
                          child: Text(
                            "${documentdata['message']}",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          radius: Radius.circular(10.0),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: "Send message", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFF6A62B7),
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
