// Dart imports:
import 'dart:math' as math;

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();



class MyApp222 extends StatelessWidget {
  const MyApp222({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CallInvitationPage());
  }
}

class CallInvitationPage extends StatelessWidget {
  CallInvitationPage({Key? key}) : super(key: key);
  final TextEditingController inviteeUsersIDTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCallWithInvitation(
      appID: 250260997,
      appSign: "50771182832fc1d646eeeb2efe33f0d8d96377c766c3311970650bdc3b7e9fa2",
      userID: localUserID,
      userName: "user_$localUserID",
      plugins: [ZegoUIKitSignalingPlugin()],
      child: yourPage(context),
    );
  }

  Widget yourPage(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your userID: $localUserID'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  inviteeUserIDInput(),
                  const SizedBox(width: 5),
                  callButton(false),
                  const SizedBox(width: 5),
                  callButton(true),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inviteeUserIDInput() {
    return Expanded(
      child: TextFormField(
        controller: inviteeUsersIDTextCtrl,

        decoration: const InputDecoration(
          isDense: true,
          hintText: "Please Enter Invitees ID",
          labelText: "Invitees ID, Separate ids by ','",
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
          ZegoStartCallInvitationButton(
          isVideoCall: isVideoCall,
          invitees: invitees,
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

              var message = 'User doesn\'t exist or is offline: $userIDs';
              if (code.isNotEmpty) {
                print("aaa");
                message += ', code: $code, message:$message';
              }
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
                  msg: "${code} ${message}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
          },
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
        name: 'user_$inviteeUserID',
      ));
    });

    return invitees;
  }
}