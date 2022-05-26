import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'login_view.dart';

class Registration_View extends StatefulWidget {
  const Registration_View({Key? key}) : super(key: key);

  @override
  State<Registration_View> createState() => _Registration_ViewState();
}

TextEditingController usernameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final CollectionReference _user = FirebaseFirestore.instance.collection('User');
String? role = 'user';
// ignore: unnecessary_new

class _Registration_ViewState extends State<Registration_View> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Registration',
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 60.0,
                      color: Colors.orange),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Your Name ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number ',
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('User'),
                        Radio(
                            value: "user",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value.toString();
                                print(role);
                              });
                            }),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Contractor'),
                        Radio(
                            value: "contractor",
                            groupValue: role,
                            onChanged: (value) {
                              setState(() {
                                role = value.toString();
                                print(role);
                              });
                            }),
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                       await updatePassword();
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
                      // await insertData();
                      if (usernameController.text.length < 5) {
                        snackBar(context, 'User Name Too short', 'OK');
                      } else if (emailController.text.length < 11) {
                        snackBar(context, 'Phone No not Valid', 'OK');
                      } else if (passwordController.text.length < 6) {
                        snackBar(context, 'Week Password', 'OK');
                      } else {
                        await postData();
                      }
                    },
                    color: Colors.orange,
                    child: const Text(
                      'REGISTER',
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
                      '''I Have already account ? ''',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                       
                        Get.to(const LoginView());
                      },
                      child: Text('Login Now'),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  insertData() async {
    try {
      var respose = await FirebaseFirestore.instance.collection('user').add({
        'name': usernameController.text,
        'Contact': emailController.text,
        'role': 'user',
        'password': passwordController.text
      });
      print(respose);
    } catch (err) {
      print(err.toString());
      throw err;
    }
  }

  postData() async {
    String name = usernameController.text;
    String phone = emailController.text;
    String passw = passwordController.text;
    try {
      var response = await _user.add(
          {'name': name, 'Contact': phone, 'role': role, 'password': passw});
      String id = response.id;
      if (id != null) {
        snackBar(context, 'Registerd With id ${id}', "OK");
      } else {
        snackBar(context, 'Something Went Wrong', "OK");
      }
    } catch (error) {
      snackBar(context, 'Something Went Wrong', "OK");
      print(error);
    }
  }

  updatePassword() async
  {

  String id= await getId();
  Map<String,Object> data={
    'Contact':emailController.text,
    'name':usernameController.text,
    'password':passwordController.text,
    'role':role.toString()

  };
  print('____________${id}');
    var collection =await FirebaseFirestore.instance.collection('User');
    collection
        .doc(id) // <-- Doc ID where data should be updated.
        .update(data);
  }

  getId() async
  {
    String? id;
    try {
      var response = await FirebaseFirestore.instance
          .collection('User')
          .where('name', isEqualTo: usernameController.text)
          .where('Contact', isEqualTo: emailController.text)
          .get()
          .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.forEach((doc) async {
          var documentID = doc.reference.id;
          id=documentID;
        }),
      });
      return id;
      // print(dataList.toString());
      // print(response.length);
    } catch (e) {
      snackBar(context, 'Wrong Contact or Password', 'OK');
      return null;
    }
  }
}
