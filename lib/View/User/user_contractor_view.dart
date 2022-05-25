import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/User/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_view.dart';
import 'controller_detail_view.dart';

class UserContractorView extends StatefulWidget {
  const UserContractorView({Key? key}) : super(key: key);

  @override
  State<UserContractorView> createState() => _UserContractorViewState();
}

final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _userName='loading....';

class _UserContractorViewState extends State<UserContractorView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      getName();
  }


  getName() async {
    final prefs = await SharedPreferences.getInstance();
     _userName =await prefs.getString('name');
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
              InkWell(
                  onTap: () {
                  Get.to(UserProfileInformation());
                  },
                  child: Icon(Icons.person)),
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
        stream: db.collection('Contractor').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                String cnic = doc['cnic'];
                String address = doc['address'];
                String about = doc['about'];
                String stime = doc['stime'];
                String etime = doc['etime'];
                String name = doc['name'];
                String contact = doc['contact'];
                String image = doc['image'];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    height: 150,
                    child: Card(
                      color: Colors.blueAccent,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListTile(
                            leading: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.memory(
                                base64.decode(image),
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(name.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                )),
                            subtitle: Text(contact.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                )),
                            trailing: FlatButton(
                              color: Colors.orangeAccent,
                              onPressed: () {
                                Get.to(ContractorDetailView(
                                  name: name,
                                  contact: contact,
                                ));
                              },
                              child: Text('see more'),
                            )
                            // subtitle: doc['contact'],
                            ),
                      ),
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
