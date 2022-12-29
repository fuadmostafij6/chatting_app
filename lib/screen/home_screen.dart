import 'package:chetingapp/screen/message_Screen.dart';
import 'package:chetingapp/widget/user_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';

import '../widget/image_chat_list.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchControllar=TextEditingController();
  final AdvancedDrawerController _drawerController=AdvancedDrawerController();


  List<String>   userCollectionList = [];

  Future getUserList()async{
    await FirebaseFirestore.instance.collection("user").get().then((value) {
      value.docs.forEach((element) {
        userCollectionList.add(element.reference.id);
      });
      setState(() {

      });
    });

  }


  @override
  void initState() {
    getUserList();
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _drawerController,
        animationDuration: Duration(milliseconds: 200),
        animationCurve: Curves.easeInOut,
       animateChildDecoration: true,
       rtlOpening: false,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Container(
            child:Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white60
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage("asset/humaun.jpg"),
                                maxRadius: 45,
                                minRadius: 30,
                              ),
                              Positioned(
                                top: 45,
                                left: 50,
                                child:  Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white
                                ),
                                child: Center(
                                  child: Icon(Icons.camera_alt,size: 25,),
                                ),

                              ),)
                            ],
                          )
                        ),
                        SizedBox(height: 10,),
                        Text("AL-FAYEJ ",style: TextStyle(fontSize: 25,
                            fontWeight:FontWeight.bold,
                            color: Colors.black54),),
                        // Text("fayej017fa@gmail.com",style: TextStyle(
                        //     fontSize: 15,
                        //     fontWeight:FontWeight.bold,
                        //     color: Colors.black54),)
                      ],

                    ),
                  ),
                ),
                Divider(height: 5,color: Colors.black,),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Icon(Icons.person,size: 25,),
                      ),

                    ),
                    title: Text("Profile ",style: TextStyle(
                        fontSize: 15,
                        fontWeight:FontWeight.bold,
                        color: Colors.black54),),),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Icon(Icons.settings,size: 25,),
                      ),

                    ),
                    title: Text("Settins ",style: TextStyle(
                        fontSize: 15,
                        fontWeight:FontWeight.bold,
                        color: Colors.black54),),),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child:ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white
                      ),
                      child: Center(
                        child: Icon(Icons.message_rounded,size: 25,),
                      ),

                    ),
                    title: Text("Message Requests ",style: TextStyle(
                        fontSize: 15,
                        fontWeight:FontWeight.bold,
                        color: Colors.black54),),),
                )
              ],
            ),
          ),
        ),
      child: Scaffold(
        backgroundColor: Colors.white,
       appBar: AppBar(
         leading: IconButton(
           onPressed: (){
             _drawerController.showDrawer();
           },
           icon: ValueListenableBuilder<AdvancedDrawerValue>(
             valueListenable: _drawerController,
             builder: (_, value, __) {
               return AnimatedSwitcher(
                 duration: Duration(milliseconds: 250),
                 child: Icon(
                   value.visible ? Icons.clear : Icons.menu,
                   key: ValueKey<bool>(value.visible),
                 ),
               );
             },
           ),
         ),


         actions: [
           Padding(
             padding: const EdgeInsets.only(top: 10,right: 15,bottom: 10),
                 child: Container(
                   height: 40,
                   width: 40,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(100),
                       color: Colors.grey.withOpacity(0.30)
                   ),
                   child: Center(
                     child: Icon(Icons.camera_alt,size: 20,),
                   ),

             ),
             // child: CircleAvatar(
             //   backgroundImage: AssetImage("asset/humaun.jpg"),
             //   maxRadius: 20,
             //   minRadius: 10,
             // ),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 10,right: 15,bottom: 10),
             child: Container(
               height: 40,
               width: 40,
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(100),
                   color: Colors.grey.withOpacity(0.30)
               ),
               child: Center(
                 child: Icon(Icons.edit,size: 20,),
               ),

             ),
             // child: CircleAvatar(
             //   backgroundImage: AssetImage("asset/humaun.jpg"),
             //   maxRadius: 20,
             //   minRadius: 10,
             // ),
           ),
         ],
         backgroundColor:Colors.white,
         elevation: 0,
         iconTheme: IconThemeData(
           color: Colors.black54
         ),
       ),

        body: ListView(
          shrinkWrap: true,
          primary: false,

          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8,left: 15,right: 15),
              child: Container(
                height: 50,
                child: TextField(
                  controller:_searchControllar,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    contentPadding: EdgeInsets.only(top: 10,left: 20),
                    filled: true,
                    // fillColor: Theme.of(context).cardColor,
                    fillColor: Colors.grey.withOpacity(.15),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:BorderSide(color:Colors.white24)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:BorderSide(
                            color: Colors.white24,
                            width: 1
                        )
                    ),
                    prefixIcon: Icon(Icons.search,color:Colors.blueGrey,),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10,right: 10,top: 1,bottom: 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Expanded(
            //         child: SizedBox(
            //           height: 50,
            //           width: double.infinity,
            //           child: ListView.builder(
            //             primary: false,
            //             shrinkWrap: true,
            //             scrollDirection: Axis.horizontal,
            //             itemCount: userCollectionList.length,
            //               itemBuilder: (context,index){
            //
            //               return ImageChatWidget(
            //                 collectionId:userCollectionList[index] ,
            //               );
            //
            //
            //               //   Container(
            //               //   height: 30,
            //               //   width: 30,
            //               //   decoration: BoxDecoration(
            //               //     borderRadius: BorderRadius.circular(100),
            //               //     image: DecorationImage(image: AssetImage(datalist[index]),fit: BoxFit.fill)
            //               //   ),
            //               // );
            //               }),
            //         ),
            //
            //       ),
            //
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left:15,top:10),
              child: Text("Messages",style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),),
            ),

          // StreamBuilder<QuerySnapshot>(
          //   stream: FirebaseFirestore.instance.collection("user").snapshots(),
          //   builder: (_,snapshot){
          //     if(!snapshot.hasData){
          //       return Center(
          //         child: CircularProgressIndicator(
          //           color: Colors.indigo,
          //         ),
          //       );
          //     }else{
          //       return  ListView.builder(
          //         shrinkWrap: true,
          //         primary: false,
          //         itemCount: snapshot.data!.docs.length,
          //         itemBuilder: (_,index){
          //           QueryDocumentSnapshot x = snapshot.data!.docs[index];
          //           return    Padding(
          //             padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   color: Colors.white60.withOpacity(0.15),
          //                   borderRadius: BorderRadius.circular(10)
          //               ),
          //               child:ListTile(
          //                 onTap: (){
          //                   Get.to(MessageScreen(
          //                     name: x['name'],
          //                     photo: x['photo'],
          //                     email: x['email'],
          //                     uId: x['uid'],
          //                   ));
          //
          //                 },
          //                 leading:  CircleAvatar(
          //                   backgroundImage: NetworkImage("${x["photo"]}"),
          //                   maxRadius: 22,
          //                   minRadius: 10,
          //                 ),
          //                 title: Text("${x["name"]}",style: TextStyle(fontSize: 14,
          //                     fontWeight:FontWeight.bold,
          //                     color: Colors.black54),),
          //                 subtitle: Text("hello... ",style: TextStyle(fontSize: 12,
          //                     fontWeight:FontWeight.bold,
          //                     color: Colors.black54),),),
          //             ),
          //           );
          //         },
          //       );
          //     }
          //   },
          //
          // ),


          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: (){
        //       Navigator.push(context, MaterialPageRoute(builder: (_)=>MessageScreen()));
        //     },
        // backgroundColor: Color(0XFF6A62B7),
        // child: Icon(Icons.message),),
      ),
    );

  }
}
