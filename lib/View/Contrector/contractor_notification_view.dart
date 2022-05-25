import 'dart:convert';
import 'dart:io';
import 'package:easy_build/View/Contrector/contractor_chat_view.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/User/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Authentication/login_view.dart';
import '../Common Widgets/snackbar.dart';
import '../User/controller_detail_view.dart';
import '../Common Widgets/loading.dart';


// ignore: must_be_immutable
class ContractorNotificationView extends StatefulWidget {
  const ContractorNotificationView({Key? key,}) : super(key: key);

  @override
  State<ContractorNotificationView> createState() => _ContractorNotificationViewState();
}

TextEditingController messageController = TextEditingController();
final CollectionReference _user = FirebaseFirestore.instance.collection('Message');

final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _userName = 'loading....';
String? _contractorContact = 'loading....';
String image = 'none';
List<String> _userList =[]; // 

class _ContractorNotificationViewState extends State<ContractorNotificationView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getName();
  }
@override
void dispose() {
_userList.clear();
  super.dispose();
}
  getName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = await prefs.getString('name');
    _contractorContact = await prefs.getString('contact');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_userName!.toUpperCase()),
          Row(
            children: [
              
              SizedBox(width: 15),
              InkWell(
                  onTap: () {
                    Get.to(LoginView());
                  },
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 10),
                  )),
            ],
          )
        ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Message').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Center(
              child: loader(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                String sender = doc['sender'];
                String receiver = doc['receiver'];
                String name = doc['name'];
                String message = doc['text'];
                String image = doc['image'];
                String date = doc['date'];
                String time = doc['time'].toString();
                bool read = doc['read'];
                bool _isShow=false;
                
                if (receiver==_contractorContact) //danish 
                {
                
                 if(!_userList.contains(name))
                 {
                    _userList.add(name);
                    print(_userList.length);
                   _isShow=true;
                 }
                }
              
                return  Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 5),
                  child:_isShow==true ?  InkWell(
                    onTap: (){
                      Get.to(ContractorChatView(userContact: sender));
                    },
                    child: Container(
                        height: 120,
                        decoration: const BoxDecoration(
                            color: Colors.orangeAccent,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(8),
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 25,
                                  child: Center(
                                      child: Text(
                                          name.split('').first.toUpperCase())),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                        child: Text(
                                      name.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800),
                                    )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width * 0.7,
                                      child: Text(message,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          date,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          time,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        read == false
                                            ? Icon(
                                                Icons.done,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.done_all,
                                                size: 20,
                                              )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ): Spacer(),
                );
              }).toList(),
            );
        },
      ),
     
    );
  }

  Loader() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }

 
}
