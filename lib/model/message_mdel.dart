
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {

  String  ?senderUid;
  String ? receiverUid;
  String  ?type;
  String ? message;
  String ? photoUrl;

  Message({this.senderUid, this.receiverUid, this.type, this.message,});

  Map<String,dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['senderUid'] = this.senderUid;
    map['receiverUid'] = this.receiverUid;
    map['type'] = this.type;
    map['message'] = this.message;
    return map;
  }

  Message fromMap(Map<String, dynamic> map) {
    Message _message = Message();
    _message.senderUid = map['senderUid'];
    _message.receiverUid = map['receiverUid'];
    _message.type = map['type'];
    _message.message = map['message'];
    return _message;
  }



}

