import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:easy_build/View/Contrector/our_design.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';


class DesignUploadView extends StatefulWidget {
 const DesignUploadView({Key? key}) : super(key: key);

  @override
  State<DesignUploadView> createState() => _DesignUploadViewState();
}

TextEditingController _titleController= TextEditingController();
final CollectionReference _design = FirebaseFirestore.instance.collection('Design');
String? designType='interior';
File? imageFile;
String? imageData;
var _imagePath;

class _DesignUploadViewState extends State<DesignUploadView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'DESIGN FORM',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 40.0,
                      color: Colors.blue),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: _titleController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Enter title',
                    border: OutlineInputBorder(),
                    //prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color:Colors.orange
                  ),
                  child: _imagePath!=null ? Image.file(File(_imagePath),  fit: BoxFit.cover,) : Container(),
                ),

                 const SizedBox(
                  height: 15,
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
                     await _imgFromGallery();
                    },
                    color: Colors.blue,
                    child: const Text(
                      'Upload Photo',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),    
                      const SizedBox(
                  height: 15,
                ),            
                Row(
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
               
                const SizedBox(
                  height: 15,
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
                      if(_titleController.text=='')
                      {
                         snackBar(context, 'Please Enter Title', 'OK');
                      }
                      if(_imagePath==null)
                      {
                        snackBar(context, 'Please Choose Image', 'OK');
                      }
                      else 
                      {
                       await  postData();
                      Get.to(const ContractorOurDesign());
                      }
                      
                    
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
                const SizedBox(
                  height: 30,
                ),
               
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  //_____________________________________________________________________ Img From Gallery
  _imgFromGallery() async {
    //var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    ImagePicker imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        print('_________________________________');
        print(pickedImage.path);
        _imagePath=pickedImage.path;
         print('_________________________________');
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile!.readAsBytesSync());
      //print(imageData);
      setState(() {});
      // return imageData;
    } else {
      return null;
    }
  }

  //___________________________________________________________________________INSERT DATA 
  
  postData() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = await prefs.getString('name');
    String? contact = await prefs.getString('contact');
    String title =_titleController.text;
    String image =_imagePath;
    String type = designType!;
    try {
      var response = await _design.add({
        'name': name,
        'contact': contact,
        'title': title,
        'type': type,
        'image': imageData,
      });
      String id = response.id;
      // ignore: unnecessary_null_comparison
      if (id != null) {
        // ignore: use_build_context_synchronously
        snackBar(context, 'Submite Your Design', "OK");
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




}