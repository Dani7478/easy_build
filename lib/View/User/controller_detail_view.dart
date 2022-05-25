// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/login_view.dart';
import 'user_chat_view.dart';

// ignore: must_be_immutable
class ContractorDetailView extends StatefulWidget {
  ContractorDetailView({Key? key, required this.name, required this.contact})
      : super(key: key);

  String name;
  String contact;
  @override
  State<ContractorDetailView> createState() => _ContractorDetailViewState();
}

final CollectionReference _appointment = FirebaseFirestore.instance.collection('Appointment');
String? name = 'none';
String? contact = 'none';
String? address = 'none';
String? cnic = 'none';
String? about = 'none';
String? stime = 'none';
String? etime = 'none';
String? image = 'none';
DateTime selectedDate = DateTime.now();
String _startDate='none';
String _endDate='none';
String? _username='none';
String? _userContact='none';


class _ContractorDetailViewState extends State<ContractorDetailView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    name = widget.name;
    contact = widget.contact;
    _username = await prefs.getString('name');
     _userContact = await prefs.getString('contact');
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
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) async {
                  print('Fetch record');
                  cnic = doc['cnic'];
                  address = doc['address'];
                  about = doc['about'];
                  stime = doc['stime'];
                  etime = doc['etime'];
                  cnic = doc['cnic'];
                  image = doc['image'];
                  setState(() {});
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
      appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(name!.toUpperCase()),
            Row(
              children: [
                 InkWell(
                   onTap: (){
                    Get.to(UserChatView(contractorContact: contact!,));
                   },
                   child: Icon(Icons.message)),
                 SizedBox(width:15),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              //________________________Photo
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 85,
                  height: 100,
                  color: Colors.blueAccent,
                  child: image != 'none'
                      ? Image.memory(
                          base64.decode(image.toString()),
                          fit: BoxFit.fitHeight,
                        )
                      : Container(),
                ),
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
                        leading: Icon(Icons.perm_identity),
                        title: Text('CNIC'),
                        subtitle: Text(cnic!),
                      ),
                    ),
                  )),

              Container(
                  height: 150,
                  child: Card(
                    color: Colors.blueAccent,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        leading: Icon(Icons.location_city),
                        title: Text('Adress'),
                        subtitle: Text(address!),
                      ),
                    ),
                  )),

              Container(
                  height: 120,
                  child: Card(
                    color: Colors.blueAccent,
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
                    color: Colors.blueAccent,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        leading: Icon(Icons.alarm),
                        title: Text('Timing'),
                        subtitle: Text('${stime} - ${etime}'),
                      ),
                    ),
                  )),
                  SizedBox(height: 15,),

              Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                   borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: FlatButton(onPressed: () {
                  showDialoge(context);
                }, child: Text('Hire Now')),
              )
            ]),
          ),
        ),
      ),
    );
  }

  //________________________Dialogue For All Teacher
  showDialoge(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            child: Stack(
              clipBehavior: Clip.none, alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 250,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                    child: Column(
                      children: [
                           Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                   borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: FlatButton(onPressed: () {
                  _selectDate(context, 'start');
                }, child: Text('Select Start Date')),
              ),

              SizedBox(height: 10,),
               Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                   borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: FlatButton(onPressed: () {
                  _selectDate(context, 'end');
                }, child: Text('Select End Date')),
              ),

              SizedBox(height: 15,),
                Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                   borderRadius: BorderRadius.circular(8),
                ),
                width: 200,
                child: FlatButton(onPressed: () async{
                   await  postData();
                   Navigator.pop(context);
                }, child: Text('Sent')),
              )
                      ],
                    ),
                  ),
                ),
                const Positioned(
                    top: -40,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFF079bff),
                      radius: 40,
                      //child: Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
                      child: ClipOval(
                        // child: Image.memory(
                        //   base64.decode(teacherImage),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Icon(
                          Icons.person,
                          size: 50,
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }

   _selectDate(BuildContext context, String type) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025), 
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        
       if(type=='start')
       {
         _startDate='${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
         print(_startDate);
       }
       if(type=='end')
       {
          _endDate='${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
         print(_endDate);
       }
      });
    }
  }

  postData() async {
    
    try {
      var response = await _appointment.add(
          {
            'username': _username,
             'usercontact': _userContact, 
             'contractorname': widget.name, 
             'contractorcontact': widget.contact,
              'startdate': _startDate,
              'enddate': _endDate,
             });
      String id = response.id;
      if (id != null) {
        snackBar(context, 'Successfuly Hire.....', "OK");
      } else {
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }

}
