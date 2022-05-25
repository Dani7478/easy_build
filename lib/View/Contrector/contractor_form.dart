import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

//name ,contact,  cnic , time , address , about
class ContractorFormView extends StatefulWidget {
  const ContractorFormView({Key? key}) : super(key: key);

  @override
  State<ContractorFormView> createState() => _ContractorFormViewState();
}

File? imageFile;
String? imageData;
String _selectImage = 'Select Image';
TextEditingController usernameController = TextEditingController();
TextEditingController cnicCotroller = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController aboutController = TextEditingController();
late String staringTime = 'Open';
late String endingTime = 'Close';
TimeOfDay selectedTime = TimeOfDay.now();

final CollectionReference _contractor =
    FirebaseFirestore.instance.collection('Contractor');
String? role = 'user';
// ignore: unnecessary_new

class _ContractorFormViewState extends State<ContractorFormView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Contractor Form',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40.0,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: cnicCotroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'CNIC Format 37405-3061644-3',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Office Address ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                    contentPadding: EdgeInsets.symmetric(vertical: 100),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Select Timing"),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        _selectTime(context, 'start');
                      },
                      child: Text(staringTime),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      onPressed: () {
                        _selectTime(context, 'end');
                      },
                      child: Text(endingTime),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: aboutController,
                  keyboardType: TextInputType.visiblePassword,
                 // obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'About .....',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    // suffixIcon: Icon(Icons.remove_red_eye),
                    contentPadding: EdgeInsets.symmetric(vertical: 50),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.blue,
                  child: FlatButton(
                    color: Colors.blue,
                    onPressed: () async {
                      await _imgFromGallery();
                    },
                    child: Text(_selectImage),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      // await insertData();
                      //  await postData();
                      await postData();
                    },
                    color: Colors.blue,
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // insertData() async {
  //   try {
  //     var respose = await FirebaseFirestore.instance.collection('user').add({
  //       'name': usernameController.text,
  //       'Contact': emailController.text,
  //       'role': 'user',
  //       'password': passwordController.text
  //     });
  //     print(respose);
  //   } catch (err) {
  //     print(err.toString());
  //     throw err;
  //   }
  // }

  // postData() async {
  //   String name = usernameController.text;
  //   String phone = emailController.text;
  //   String passw = passwordController.text;
  //   try {
  //     var response = await _user.add(
  //         {'name': name, 'Contact': phone, 'role': role, 'password': passw});
  //     String id = response.id;
  //     if (id != null) {
  //       snackBar(context, 'Registerd With id ${id}', "OK");
  //     } else {
  //       snackBar(context, 'Something Went Wrong', "OK");
  //     }
  //   } catch (error) {
  //     snackBar(context, 'Something Went Wrong', "OK");
  //     print(error);
  //   }
  // }

  _selectTime(BuildContext context, String btn) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      if (btn == 'start') {
        staringTime = '${selectedTime.hour}:${selectedTime.minute}';
        print(staringTime);
      }
      if (btn == 'end') {
        endingTime = '${selectedTime.hour}:${selectedTime.minute}';
        print(endingTime);
      }
      setState(() {});
    }
  }

  //_____________________________________________________________________ Img From Gallery
  _imgFromGallery() async {
    //var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectImage = pickedImage.path;
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      print(imageData);
      setState(() {});
      // return imageData;
    } else {
      return null;
    }
  }

  postData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString('name');
    String? contact = await prefs.getString('contact');
    String cnic = cnicCotroller.text;
    String address = addressController.text;
    String stime = staringTime;
    String etime = endingTime;
    String about = aboutController.text;
    String image = imageData.toString();
    await prefs.setString('cnic', cnic);
    await prefs.setString('address', address);
    await prefs.setString('stime', stime);
    await prefs.setString('etime', etime);
    await prefs.setString('about', about);
    await prefs.setString('image', image);
    try {
      var response = await _contractor.add({
        'name': name,
        'contact': contact,
        'cnic': cnic,
        'address': address,
        'stime': stime,
        'etime': etime,
        'about': about,
        'image': image
      });
      String id = response.id;
      if (id != null) {
        snackBar(context, 'Submited Your Personal Info}', "OK");
      } else {
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }
}
