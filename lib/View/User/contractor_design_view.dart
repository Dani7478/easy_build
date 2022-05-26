// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Contrector/design_upload_view.dart';
import 'package:easy_build/View/User/user_chat_view.dart';
import 'package:easy_build/View/User/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_view.dart';
import '../Common Widgets/loading.dart';
import '../Common Widgets/snackbar.dart';
import '../User/controller_detail_view.dart';

class ContractorDesignView extends StatefulWidget {
  const ContractorDesignView({Key? key}) : super(key: key);

  @override
  State<ContractorDesignView> createState() => _ContractorDesignViewState();
}

final CollectionReference _favorite =
    FirebaseFirestore.instance.collection('Favorite');
final CollectionReference _message =
    FirebaseFirestore.instance.collection('Message');

final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _userName = 'loading....';
String? _userContact = 'none';
String? designType = 'interior';
List<bool>? favList;

class _ContractorDesignViewState extends State<ContractorDesignView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = await prefs.getString('name');
    _userContact = await prefs.getString('contact');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(_userName!.toUpperCase()),
            // Row(
            //   children: [
            //     InkWell(
            //         onTap: () {
            //           Get.to(const DesignUploadView());
            //         },
            //         child: const Text(
            //           'ADD',
            //           style: TextStyle(fontSize: 10),
            //         )),
            //     const SizedBox(width: 5),
            //     InkWell(
            //         onTap: () {
            //           Get.to(const DesignUploadView());
            //         },
            //         child: Icon(Icons.add)),
            //   ],
            // )
          ]),
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: [
                      Text('Interior'),
                      Radio(
                          value: "interior",
                          groupValue: designType,
                          onChanged: (value) {
                            setState(() {
                              designType = value.toString();
                              print(designType);
                            });
                          }),
                    ],
                  ),
                  Row(
                    children: [
                      const Text('Exterior'),
                      Radio(
                          value: "exterior",
                          groupValue: designType,
                          onChanged: (value) {
                            setState(() {
                              designType = value.toString();
                              print(designType);
                            });
                          }),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db
                    .collection('Design')
                    .where('type', isEqualTo: designType)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: loader(),
                    );
                  } else {
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        String name = doc['name'];
                        String contact = doc['contact'];
                        String image = doc['image'];
                        String type = doc['type'];
                        String title = doc['title'];
                        bool? _isFav;
                        checkFav(title, contact).then((value) {
                          _isFav = value;

                          print(_isFav);
                        });
                        // _isFav=chek(title,contact);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Container(
                            height: 350,
                            child: Card(
                              color: Colors.orange,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      //   crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            // height: 80,
                                            // width: 120,

                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            height: 180,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Image.memory(
                                              base64.decode(image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              name.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              contact.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                            Text(
                                              type.toUpperCase(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  await postData(name, contact,
                                                      image, title, type);
                                                },
                                                child: Icon(
                                                  Icons.thumb_up,
                                                  color: _isFav == true
                                                      ? Colors.deepOrange
                                                      : Colors.black,
                                                )),
                                            Icon(Icons.thumb_down),
                                            InkWell(
                                                onTap: () async {
                                                  await SentMessage(
                                                      contact, image);
                                                },
                                                child: Icon(Icons.share)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            )
          ],
        ));
  }

  Loader() {
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.teal,
        size: 80,
      ),
    );
  }

  SentMessage(String receiveer, String dataimage) async {
    DateTime now = DateTime.now();
    String time = now.hour.toString() + ":" + now.minute.toString();
    var formatterDate = DateFormat('dd/MM/yy');
    String date = formatterDate.format(now);
    print(time);
    print(date);

    try {
      var response = await _message.add({
        'name': _userName,
        'sender': _userContact,
        'receiver': receiveer,
        'text': 'i liked your Desgin',
        'image': dataimage,
        'time': time,
        'date': date,
        'read': false
      });
      String id = response.id;
      if (id != null) {
        snackBar(context, 'Message Sent', "OK");
        Get.to(UserChatView(contractorContact: receiveer));

        setState(() {});
      } else {
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }

  //___________________________________________________________________________INSERT DATA

  postData(String name, String contact, String image, String title,
      String type) async {
   // final prefs = await SharedPreferences.getInstance();
   // String? contact = await prefs.getString('contact');

    try {
      var response = await _favorite.add({
        'name': name,
        'contact': contact,
        'title': title,
        'type': type,
        'image': image,
        'favcontact': _userContact
      });
      String id = response.id;
      // ignore: unnecessary_null_comparison
      if (id != null) {
        // ignore: use_build_context_synchronously
        snackBar(context, 'Favorite Done...', "OK");
      } else {
        // ignore: use_build_context_synchronously
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }

  checkFav(String title, String contact) async {
    bool _isFav = false;
    try {
      var response = await FirebaseFirestore.instance
          .collection('Favorite')
          .where('title', isEqualTo: title)
          .where('contact', isEqualTo: contact)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) async {
                  print('Has Record...');
                  _isFav = true;
                  //  return _isFav;
                }),
              });
      return _isFav;
    } catch (e) {
      return _isFav;
    }
  }
}
