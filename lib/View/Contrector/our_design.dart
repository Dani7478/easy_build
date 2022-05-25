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
import '../User/controller_detail_view.dart';
import 'contractor_profile_info.dart';

class ContractorOurDesign extends StatefulWidget {
  const ContractorOurDesign({Key? key}) : super(key: key);

  @override
  State<ContractorOurDesign> createState() => _ContractorOurDesignState();
}

final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _contractorName = 'loading....';
String? _contractorContact = 'none';

class _ContractorOurDesignState extends State<ContractorOurDesign> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
  }

  getName() async {
    final prefs = await SharedPreferences.getInstance();
    _contractorName = await prefs.getString('name');
    _contractorContact = await prefs.getString('contact');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_contractorName!.toUpperCase()),
          Row(
            children: [
              InkWell(
                  onTap: () {
                    Get.to(const DesignUploadView());
                  },
                  child: const Text(
                    'ADD',
                    style: TextStyle(fontSize: 10),
                  )),
              const SizedBox(width: 5),
              InkWell(
                  onTap: () {
                    Get.to(const DesignUploadView());
                  },
                  child: Icon(Icons.add)),
            ],
          )
        ]),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('Design')
            .where('contact', isEqualTo: _contractorContact)
            .where('name', isEqualTo: _contractorName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    height: 320,
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
                                        border: Border.all(color: Colors.grey)),
                                    child: Image.memory(
                                      base64.decode(image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    // height: 80,
                                    // width: 120,
                                    child: Text(
                                      type.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
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
