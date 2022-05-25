// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Contrector/design_upload_view.dart';
import 'package:easy_build/View/User/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_view.dart';
import '../Common Widgets/loading.dart';
import '../Common Widgets/snackbar.dart';
import '../User/controller_detail_view.dart';

class UserFavruitDesignView extends StatefulWidget {
  const UserFavruitDesignView({Key? key}) : super(key: key);

  @override
  State<UserFavruitDesignView> createState() => _UserFavruitDesignViewState();
}

final CollectionReference _favorite =
    FirebaseFirestore.instance.collection('Favorite');
final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _userName = 'loading....';
String? _userContact = 'none';
String? designType = 'interior';

class _UserFavruitDesignViewState extends State<UserFavruitDesignView> {
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
                    .collection('Favorite')
                    .where('type', isEqualTo: designType)
                    .where('favcontact', isEqualTo: _userContact)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: loader(),
                    );
                  } else
                    // ignore: curly_braces_in_flow_control_structures
                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        String name = doc['name'];
                        String contact = doc['contact'];
                        String image = doc['image'];
                        String type = doc['type'];
                        String title = doc['title'];

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
                                       
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }).toList(),
                    );
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

 
}
