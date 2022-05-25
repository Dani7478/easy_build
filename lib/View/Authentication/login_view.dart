import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Authentication/registration.dart';
import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:easy_build/View/Contrector/contractor_home.dart';
import 'package:easy_build/View/User/user_contractor_view.dart';
import 'package:easy_build/View/User/user_home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Contrector/contractor_form.dart';



class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();



 List dataList = [];

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 60.0,
                        color: Colors.orange),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Contact Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: Icon(Icons.remove_red_eye),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          print('Forgotted Password!');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.4),
                            fontSize: 12.0,
                          ),
                        ),
                      ),
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
                        //  if(emailController.text.length<11)
                        // {
                        //   snackBar(context, 'No valid phone number', 'OK');
                        // }
                        // else 
                        // {
                        //    await getData();
                        // }
                         await getData();
                      
                        // await fetchData();
                      },
                      color: Colors.orange,
                      child: const Text(
                        'LOGIN',
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
                  const Divider(
                    color: Colors.black,
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '''Don't have an account? ''',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16.0,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const Registration_View());
                        },
                        child: Text('Register Now'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

   getData() async {
    final prefs = await SharedPreferences.getInstance();
    String contact=emailController.text;
    String password=passwordController.text;

    //List dataList = [];
    try {
   var response=  await FirebaseFirestore.instance.collection('User').
      where('Contact', isEqualTo: contact).
      where('password', isEqualTo: password).
      get().then((QuerySnapshot querySnapshot) => {
            querySnapshot.docs.forEach((doc) async{
           
            await prefs.setString('name',doc['name'] );
            await prefs.setString('contact',doc['Contact'] );
             await prefs.setString('role',doc['role'] );
            // dataList.add(doc.data());
           snackBar(context, 'Authenticate....', 'OK');
           String role =doc['role'];
           if(role.toLowerCase()=='user')
           {
             Get.to(UserHomeView());
           }
            if(role.toLowerCase()=='contractor')
           {
             Get.to(ContractorHomeView());
           }
            }),
          });
         // print(dataList.toString());
         // print(response.length);
    } catch (e) {
     snackBar(context, 'Wrong Contact or Password', 'OK');
      return null;
    }
  }


}
