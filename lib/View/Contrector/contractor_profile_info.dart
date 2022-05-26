import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileInformation extends StatefulWidget {
  ProfileInformation({Key? key}) : super(key: key);

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

String? name = 'none';
String? contact = 'none';
String? address = 'none';
String? cnic = 'none';
String? about = 'none';
String? stime = 'none';
String? etime = 'none';
String? image = 'none';

class _ProfileInformationState extends State<ProfileInformation> {
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
    // cnic = await prefs.getString('cnic');
    // address = await prefs.getString('address');
    // about = await prefs.getString('about');
    // stime = await prefs.getString('stime');
    // etime = await prefs.getString('etime');

    try {
      var response = await FirebaseFirestore.instance
          .collection('Contractor')
          .where('contact', isEqualTo: contact)
          .where('name', isEqualTo: name)
          .get()
          .then((QuerySnapshot querySnapshot) =>
      {
        querySnapshot.docs.forEach((doc) async {
          print('Fetch record');
          cnic = doc['cnic'];
          address = doc['address'];
          about = doc['about'];
          stime = doc['stime'];
          etime = doc['etime'];
          cnic = doc['cnic'];
          image = doc['image'].toString();
          setState(() {});
          print( base64.decode(image.toString()));
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
     // appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: [
            //________________________Photo
            SizedBox(
              height: 10,
            ),
            image != 'none'
                ? Container(
              height: 90,
              width: 90,
             decoration: BoxDecoration(
               color: Colors.orange,
               borderRadius: BorderRadius.circular(90),
             ),
              child: ClipOval(
                child: Image.memory(
                  base64.decode(image.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            //_____________________Name
            SizedBox(
                height: 80,
                child: Card(
                  color: Colors.orange,
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
            SizedBox(
                height: 80,
                child: Card(
                  color: Colors.orange,
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
                  color: Colors.orange,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.perm_identity),
                      title: Text('CNIC'),
                      subtitle: Text(cnic!),
                    ),
                  ),
                )),

            SizedBox(
                height: 150,
                child: Card(
                  color: Colors.orange,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.location_city),
                      title: Text('Adress'),
                      subtitle: Text(address!),
                    ),
                  ),
                )),

            SizedBox(
                height: 120,
                child: Card(
                  color: Colors.orange,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.details),
                      title: Text('About'),
                      subtitle: Text(about!),
                    ),
                  ),
                )),

            Container(
                height: 80,
                child: Card(
                  color: Colors.orange,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ListTile(
                      leading: Icon(Icons.alarm),
                      title: Text('Timing'),
                      subtitle: Text('${stime} - ${etime}'),
                    ),
                  ),
                )),
          ]),
        ),
      ),
    );
  }
}
