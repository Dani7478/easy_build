import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/User/user_profile_info.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_view.dart';
import '../User/controller_detail_view.dart';


class ContractorHiringView extends StatefulWidget {
  const ContractorHiringView({Key? key}) : super(key: key);

  @override
  State<ContractorHiringView> createState() => _ContractorHiringViewState();
}

final db = FirebaseFirestore.instance;
bool _isloading = true;
String? _cotractorName='loading....';
String? _contractorContact='loading....';


class _ContractorHiringViewState extends State<ContractorHiringView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getName();
  }


  getName() async {
    final prefs = await SharedPreferences.getInstance();
     _cotractorName =await prefs.getString('name');
       _contractorContact =await prefs.getString('contact');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:
      //       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      //     Text(_userName!.toUpperCase()),
      //     Row(
      //       children: [
      //         InkWell(
      //             onTap: () {
      //             Get.to(UserProfileInformation());
      //             },
      //             child: Icon(Icons.person)),
      //         SizedBox(width: 15),
      //         InkWell(
      //             onTap: () {
      //               Get.to(LoginView());
      //             },
      //             child: const Text(
      //               'Logout',
      //               style: TextStyle(fontSize: 10),
      //             )),
      //       ],
      //     )
      //   ]),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('Appointment').
        where('contractorcontact', isEqualTo: _contractorContact).
        snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return  Center(
              child: Loader(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                String username = doc['username'];
                String usercontact = doc['usercontact'];
                String startdate = doc['startdate'];
                String enddate = doc['enddate'];
              
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Container(
                    height: 100,
                    child: Card(
                      color: Colors.orange,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ListTile(
                          leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 25,
                                child: Center(
                                    child: Text(
                                        username.split('').first.toUpperCase())),
                              ),
                            title: Text(username.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                )),

                                 subtitle: Text(
                                   usercontact,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                   fontWeight: FontWeight.w400,
                                )
                                ),

                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Text(
                                   startdate,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                   fontWeight: FontWeight.w400,
                                )
                                ),
                                SizedBox(height: 5,),

                                 Text(
                                   enddate,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                   fontWeight: FontWeight.w400,
                                )
                                ),

                                ]),
                       
                        
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
