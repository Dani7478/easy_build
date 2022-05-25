import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'View/Authentication/login_view.dart';


class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 5),
        () =>Get.to(LoginView()) );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: 220,
                  width: 220,
                  //  color: Colors.red,
                  child: Image.asset(
                    'images/mainlogo2.png',
                    height: 50,
                  ),
                ),
              )),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                    //color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'EASY BUILD',
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  ],
                )),
              ))
        ],
      ),
    );
  }
}
