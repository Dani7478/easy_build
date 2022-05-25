import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
import 'controller_detail_view.dart';

// ignore: must_be_immutable
class UserChatView extends StatefulWidget {
  UserChatView({Key? key, required this.contractorContact}) : super(key: key);
  String contractorContact;

  @override
  State<UserChatView> createState() => _UserChatViewState();
}

TextEditingController messageController = TextEditingController();
final CollectionReference _user =
    FirebaseFirestore.instance.collection('Message');

final db = FirebaseFirestore.instance;
File? imageFile;
String? imageData;
bool _isloading = true;
String? _userName = 'loading....';
String? _userContact = 'loading....';
String image = 'none';

class _UserChatViewState extends State<UserChatView> {
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
        stream: db.collection('Message').orderBy('date').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else
            // ignore: curly_braces_in_flow_control_structures
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                String sender = doc['sender'];
                String receiver = doc['receiver'];
                String name = doc['name'];
                String message = doc['text'];
                String dataimage = doc['image'];
                String date = doc['date'];
                String time = doc['time'].toString();
                bool read = doc['read'];
                bool _isShow=false;
                Color msgColor = Colors.orangeAccent;
                if (sender == _userContact) {
                  msgColor = Colors.grey;
                }
                if(
                  (sender==_userContact && receiver==widget.contractorContact) ||
                  (sender==widget.contractorContact && receiver==_userContact)
                )
                {
                  _isShow=true;
                  
                }

                return  Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 5),
                  child:_isShow==true ?  Container(
                      height: dataimage=='none'  ? 120 : 300,
                      decoration: BoxDecoration(
                          color: msgColor,
                          borderRadius: const BorderRadius.only(
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
                                  dataimage=='none'? Container() :
                                   Container(
                                            height: 120,
                                            width: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.orange,
                                                border: Border.all(
                                                    color: Colors.grey)),
                                            child: Image.memory(
                                              base64.decode(dataimage
                                              ),
                                              fit: BoxFit.cover,
                                            ),
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
                      )): Spacer(),
                );
              }).toList(),
            );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.grey,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Expanded(flex: 1, child:
               InkWell(
                 onTap: ()async {
                   await  _imgFromGallery();
                 },
                 child: Icon(Icons.image))),
              Expanded(
                  flex: 8,
                  child: Container(
                    color: Colors.grey,
                    child: TextFormField(
                      controller: messageController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: const InputDecoration(
                        hintText: 'Type message here...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () {
                        SentMessage();
                      },
                      child: Icon(Icons.arrow_forward))),
            ],
          ),
        ),
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

  SentMessage() async {
    DateTime now = DateTime.now();
    String time = now.hour.toString() + ":" + now.minute.toString();
    var formatterDate = DateFormat('dd/MM/yy');
    String date = formatterDate.format(now);
    print(time);
    print(date);

    try {
      var response = await _user.add({
        'name': _userName,
        'sender': _userContact,
        'receiver': widget.contractorContact,
        'text': messageController.text,
        'image': image,
        'time': time,
        'date': date,
        'read': false
      });
      String id = response.id;
      if (id != null) {
        snackBar(context, 'Message Sent', "OK");
        messageController.text = '';
        setState(() {});
      } else {
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }

    //_____________________________________________________________________ Img From Gallery
  // ignore: unused_element
  _imgFromGallery() async {
    //var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      image=imageData!;
      print(imageData);
      setState(() {});
      // return imageData;
    } else {
      return null;
    }
  }
}
