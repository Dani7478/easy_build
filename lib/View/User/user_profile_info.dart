import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileInformation extends StatefulWidget {
  UserProfileInformation({Key? key}) : super(key: key);

  @override
  State<UserProfileInformation> createState() => _UserProfileInformationState();
}

String? name = 'none';
String? contact = 'none';
String? password= 'none';


class _UserProfileInformationState extends State<UserProfileInformation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    name = await prefs.getString('name');
    contact = await prefs.getString('contact');
  

    try {
      var response = await FirebaseFirestore.instance
          .collection('User')
          .where('contact', isEqualTo: contact)
          .where('name', isEqualTo: name)
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) async {
                  print('Fetch record');
                  name = doc['name'];
                  contact = doc['contact'];
                  password = doc['password'];
                  setState((){});
                }),
              });
      // print(dataList.toString());
      // print(response.length);
    } catch (e) {
      // snackBar(context, 'Wrong Contact or Password', 'OK');
      return null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(children: [
            //________________________Photo
            SizedBox(
              height: 10,
            ),
           
            SizedBox(
              height: 10,
            ),
            //_____________________Name
            Container(
                height: 80,
                child: Card(
                  color: Colors.blueAccent,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Name'),
                      subtitle: Text(name!),
                    ),
                  ),
                )),

            //_____________________Name
            Container(
                height: 80,
                child: Card(
                  color: Colors.blueAccent,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Contact'),
                      subtitle: Text(contact!),
                    ),
                  ),
                )),
            Container(
                height: 80,
                child: Card(
                  color: Colors.blueAccent,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: const Icon(Icons.perm_identity),
                      title: const Text('Password'),
                      subtitle: Text(password!),
                    ),
                  ),
                )),

          
          ]),
        ),
      ),
    );
  }
}
