import 'package:easy_build/View/Authentication/login_view.dart';
import 'package:easy_build/View/Contrector/contractor_form.dart';
import 'package:easy_build/View/Contrector/contractor_home.dart';
import 'package:easy_build/View/Contrector/design_upload_view.dart';
import 'package:easy_build/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/User/cost_calculation.dart';
import 'View/User/user_chat_view.dart';
import 'View/User/user_contractor_view.dart';
import 'View/User/user_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Build',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home:const  SplashView()
    );
  }
}