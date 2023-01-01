import 'package:bubble/bubble.dart';
import 'package:chetingapp/model/message_mdel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
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
    if(_messageController.text.isNotEmpty){
      var text = _messageController.text;
      print("Message text___${text}");
      message = Message(
          receiverUid: widget.userUid,
          senderUid: _senderId,
          message: text,
          type: "text",

          time: DateTime.now()

      );

      addMessage(message!);
      setState(() {});
    }else{
      print("Please Add your text");
    }

  }

  bool emojiOn= false;

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
          Expanded(child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(
                  _senderId,
                )
                .collection(widget.userUid!).orderBy("time")
                .snapshots(),
            builder: (context, snapshot) {


              return snapshot.hasData?
              snapshot.data!.docs.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,
                primary: false,
                reverse: true,
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
                          color:documentdata['senderUid'] == _senderId? Colors.green: Colors.deepPurple,
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
              ):

                  Center(child: Text("No Massage")):

              Center(child: CircularProgressIndicator());
            },
          )),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              children: [

                InkWell(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      emojiOn = !emojiOn;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0XFF6A62B7),
                    ),
                    child: Icon(
                      Icons.emoji_emotions,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: TextField(
                    onTap: (){
                      setState(() {
                        emojiOn = false;
                      });
                    },
                    controller: _messageController,
                    decoration: InputDecoration(
                        hintText: "Send message", border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    sendMessage();

                    setState(() {
                      emojiOn =false;
                    });
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
          ),


          emojiOn?
          SizedBox(
            height: 350,
            child: EmojiPicker(
              onEmojiSelected: (Category? category, Emoji? emoji) {
                // Do something when emoji is tapped (optional)
              },
              onBackspacePressed: () {
                // Do something when the user taps the backspace button (optional)
              },
              textEditingController: _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
              config: Config(
                columns: 7,
                //emojiSizeMax: 32 * (foundation.defaultTargetPlatform == TargetPlatform.iOS ? 1.30 : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
                verticalSpacing: 0,
                horizontalSpacing: 0,
                gridPadding: EdgeInsets.zero,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
                indicatorColor: Colors.blue,
                iconColor: Colors.grey,
                iconColorSelected: Colors.blue,
                backspaceColor: Colors.blue,
                skinToneDialogBgColor: Colors.white,
                skinToneIndicatorColor: Colors.grey,
                enableSkinTones: true,
                showRecentsTab: true,
                recentsLimit: 28,
                noRecents: const Text(
                  'No Recent',
                  style: TextStyle(fontSize: 20, color: Colors.black26),
                  textAlign: TextAlign.center,
                ), // Needs to be const Widget
                loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
                tabIndicatorAnimDuration: kTabScrollDuration,
                categoryIcons: const CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ):
          Container()


        ],
      ),
    );
  }
}
