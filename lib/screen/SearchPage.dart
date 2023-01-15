


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'chat_screen.dart';




class SearchPage extends SearchDelegate{



  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [

      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),

    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
   return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator(),);

        final results =
        snapshot.data!.docs.where((a) => a['name'].toLowerCase().contains(query.toLowerCase()));

        return ListView(
          children:

          results.map<Widget>((documentData) => ListTile(



              onTap: (){
                query = documentData['name'];
                Get.to(ChatScreen(
                  userName: documentData["name"],
                  userEmail: documentData["email"],
                  userUid: documentData["uid"],
                  userPhoto: documentData["photo"],
                ));
              },
              leading: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(documentData["photo"]),
              ),
              title: Text(documentData['name']))).toList(),
        );
      },
    );
  }

}




