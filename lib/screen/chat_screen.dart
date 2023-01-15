
import 'package:audioplayers/audioplayers.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:chat_bubbles/bubbles/bubble_normal_audio.dart';
import 'package:chetingapp/model/message_mdel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../widget/RecordBUtton.dart';
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

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  Message? message;
  Map<String, dynamic> map = Map<String, dynamic>();
  CollectionReference? collectionReference;
  DocumentSnapshot? documentSnapshot;
  FirebaseAuth? _firebaseAuth = FirebaseAuth.instance;
  String? _senderId;
AnimationController? controller;
  FirebaseMessaging  ?_firebaseMessaging;



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
    if (_messageController.text.isNotEmpty) {
      var text = _messageController.text;
      // _firebaseMessaging!.sendMessage(
      //
      // );
      print("Message text___${text}");
      message = Message(
          receiverUid: widget.userUid,
          senderUid: _firebaseAuth!.currentUser!.uid,
          message: text,
          type: "text",
          time: DateTime.now());

      addMessage(message!);
      setState(() {});
    } else {
      print("Please Add your text");
    }
  }

  bool emojiOn = false;
String micOn ="";
  ScrollController _scrollController = ScrollController();
  String readTimestamp(int timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date); // Doesn't get called when it should be
    } else {
      time =
          diff.inDays.toString() + 'DAYS AGO'; // Gets call and it's wrong date
    }

    return time;
  }
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();
  @override
  void initState() {
    inviteeUsersIDTextCtrl.text ="${widget.userUid!}";
    getUid().then((value) {
      setState(() {
        _senderId = value!.uid;
      });
    });
    controller = AnimationController(vsync: this,
    duration: Duration(milliseconds: 600),

    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          callButton(false),
          callButton(true)
          // IconButton(onPressed: (){
          //
          //
          //
          // }, icon: Icon(
          //   Icons.call,
          //   color: Colors.black,
          // ))
        ],
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
      body: ZegoUIKitPrebuiltCallWithInvitation(

        appID: 250260997,
        appSign: "50771182832fc1d646eeeb2efe33f0d8d96377c766c3311970650bdc3b7e9fa2",
        userID: _firebaseAuth!.currentUser!.uid,
        userName: _firebaseAuth!.currentUser!.email!,
        plugins: [ZegoUIKitSignalingPlugin()],
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(
                    _senderId,
                  )
                  .collection(widget.userUid!)
                  .orderBy('time', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {


                return snapshot.hasData
                    ? snapshot.data!.docs.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            controller: _scrollController,
                            // reverse: true,

                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              SchedulerBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  _scrollController.jumpTo(
                                    _scrollController.position.maxScrollExtent,
                                  );
                                }
                              });
                              QueryDocumentSnapshot documentdata =
                                  snapshot.data!.docs[index];
                              DateTime datFormate = DateTime.parse(
                                  documentdata["time"].toDate().toString());
                              Duration duration = new Duration();
                              Duration position = new Duration();
                              bool isPlaying = false;
                              bool isLoading = false;
                              bool isPause = false;
                              AudioPlayer audioPlayer = new AudioPlayer();
                              void _changeSeek(double value) {
                                setState(() {
                                  audioPlayer.seek(new Duration(seconds: value.toInt()));
                                });
                              }

                               _playAudio(String u) async {
                                print("uuuuu"+u);
                                final url =
                                    u;
                                if (isPause) {
                                  await audioPlayer.resume();
                                  setState(() {
                                    isPlaying = true;
                                    isPause = false;
                                  });
                                } else if (isPlaying) {
                                  await audioPlayer.pause();
                                  setState(() {
                                    isPlaying = false;
                                    isPause = true;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await audioPlayer.play(UrlSource(url));
                                  setState(() {
                                    isPlaying = true;
                                  });
                                }

                                audioPlayer.onDurationChanged.listen((Duration d) {
                                  setState(() {
                                    duration = d;
                                    isLoading = false;
                                  });
                                });
                                audioPlayer.onDurationChanged.listen((Duration p) {
                                  setState(() {
                                    position = p;
                                  });
                                });
                                audioPlayer.onPlayerComplete.listen((event) {
                                  setState(() {
                                    isPlaying = false;
                                    duration = new Duration();
                                    position = new Duration();
                                  });
                                });
                              }
                              return Align(
                                alignment: documentdata['senderUid'] == _senderId
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  documentdata['type'] =="text"?
                                  BubbleNormal(
                                    text: documentdata['message'],
                                    isSender: documentdata['senderUid'] == _senderId,
                                    color:documentdata['senderUid'] == _senderId
                                        ? Colors.green
                                        : Colors.deepPurple,
                                    tail: true,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  )

                                  // Bubble(
                                  //   color: documentdata['senderUid'] == _senderId
                                  //       ? Colors.green
                                  //       : Colors.deepPurple,
                                  //   child: FittedBox(
                                  //     child: Column(
                                  //       mainAxisAlignment: MainAxisAlignment.end,
                                  //       crossAxisAlignment: CrossAxisAlignment.end,
                                  //
                                  //       children: [
                                  //         Text(
                                  //           "${documentdata['message']}",
                                  //           style: TextStyle(
                                  //               fontSize: 18,
                                  //               color: Colors.white),
                                  //         ),
                                  //         Align(
                                  //           alignment: Alignment.centerRight,
                                  //           child: Text(
                                  //             "${DateFormat().add_jm().format(datFormate)}",
                                  //             style: TextStyle(
                                  //               fontSize: 14,
                                  //               color: Colors.white,
                                  //
                                  //             ),
                                  //             textAlign: TextAlign.end,
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  //   radius: Radius.circular(10.0),
                                  // )
                                 : BubbleNormalAudio(
                                    color: Color(0xFFE8E8EE),
                                    duration: duration.inSeconds.toDouble(),
                                    position: position.inSeconds.toDouble(),
                                    isPlaying: isPlaying,
                                    isLoading: isLoading,
                                    isPause: isPause,
                                    onSeekChanged: _changeSeek,
                                    onPlayPauseButtonClick: ()async{
                                      print(documentdata['message']);
                                     await _playAudio(documentdata['message']);
                                    },
                                    sent: documentdata['senderUid'] == _senderId,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: Text("No Massage"))
                    : Center(child: CircularProgressIndicator());
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
                      onTap: () {
                        setState(() {
                          emojiOn = false;
                        });
                      },
                      controller: _messageController,
                      onChanged: (v){
                        setState(() {
                          micOn = v;
                        });
                      },
                      decoration: InputDecoration(
                          hintText: "Send message", border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  micOn.isNotEmpty?   InkWell(
                    onTap: () {
                      sendMessage();

                      setState(() {
                        emojiOn = false;
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
                  ):

                  RecordButton(controller: controller!, userUid: widget.userUid!,),


                ],
              ),
            ),
            emojiOn
                ? SizedBox(
                    height: 350,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji? emoji) {
                        // Do something when emoji is tapped (optional)
                      },
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                      },
                      textEditingController:
                          _messageController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
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
                        loadingIndicator:
                            const SizedBox.shrink(), // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: const CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget callButton(bool isVideoCall) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: inviteeUsersIDTextCtrl,
      builder: (context, inviteeUserID, _) {
        var invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);

        return
          ZegoSendCallInvitationButton(

            invitees:invitees ,
            iconSize: const Size(40, 40),
            buttonSize: const Size(50, 50),

            onPressed: (String code, String message, List<String> errorInvitees) {


              if (errorInvitees.isNotEmpty) {
                String userIDs = "";
                for (int index = 0; index < errorInvitees.length; index++) {
                  if (index >= 5) {
                    userIDs += '... ';
                    break;
                  }

                  var userID = errorInvitees.elementAt(index);
                  userIDs += userID + ' ';
                }
                if (userIDs.isNotEmpty) {
                  userIDs = userIDs.substring(0, userIDs.length - 1);
                }

                var message = 'User is offline';
                // if (code.isNotEmpty) {
                //   print("aaa");
                //   message += ', code: $code, message:$message';
                // }
                Fluttertoast.showToast(
                    msg: message,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              } else if (code.isNotEmpty) {
                Fluttertoast.showToast(
                    msg: "${message}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            }, isVideoCall: isVideoCall,
          );
      },
    );
  }

  List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
    List<ZegoUIKitUser> invitees = [];

    var inviteeIDs = textCtrlText.trim().replaceAll('，', '');
    inviteeIDs.split(",").forEach((inviteeUserID) {
      if (inviteeUserID.isEmpty) {
        return;
      }

      invitees.add(ZegoUIKitUser(
        id: inviteeUserID,
        name: '${widget.userName}',
      ));
    });

    return invitees;
  }
}
