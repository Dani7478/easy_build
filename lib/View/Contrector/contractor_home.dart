import 'package:easy_build/View/Authentication/login_view.dart';
import 'package:easy_build/View/Contrector/contractor_hiring_view.dart';
import 'package:easy_build/View/Contrector/contractor_notification_view.dart';
import 'package:easy_build/View/Contrector/contractor_profile_info.dart';
import 'package:easy_build/View/Contrector/our_design.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contractor_form.dart';

class ContractorHomeView extends StatefulWidget {
  ContractorHomeView({Key? key}) : super(key: key);

  @override
  State<ContractorHomeView> createState() => _ContractorHomeViewState();
}

String? contractorName = '';

class _ContractorHomeViewState extends State<ContractorHomeView> {
  @override
  void initState() {
    super.initState();
    getName();
  }

  getName() async {
    final prefs = await SharedPreferences.getInstance();
    contractorName = await prefs.getString('name');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
       child: AppBar(
          title:Column(
            children: [
                 Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
            Text(contractorName!.toUpperCase()),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Get.to(ProfileInformation());
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

          
            ],
          )
          
        ),),
        // body: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       InkWell(
        //         onTap: () {
        //           Get.to(const ContractorFormView());
        //         },
        //         child: Container(
        //             height: 150,
        //             width: MediaQuery.of(context).size.width * 0.7,
        //             color: Colors.blueAccent,
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: const [
        //                 Icon(
        //                   Icons.person,
        //                   color: Colors.white,
        //                   size: 50,
        //                 ),
        //                 SizedBox(height: 5),
        //                 Text(
        //                   'Upload Profiel',
        //                   style: TextStyle(
        //                       fontSize: 24,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ],
        //             )),
        //       ),
        //       const SizedBox(height: 30),
        //       InkWell(
        //         onTap: () {
        //           Get.to(ContractorNotificationView());
        //         },
        //         child: Container(
        //             height: 150,
        //             width: MediaQuery.of(context).size.width * 0.7,
        //             color: Colors.blueAccent,
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: const [
        //                 Icon(
        //                   Icons.message,
        //                   color: Colors.white,
        //                   size: 50,
        //                 ),
        //                 SizedBox(height: 5),
        //                 Text(
        //                   'See Notification',
        //                   style: TextStyle(
        //                       fontSize: 24,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ],
        //             )),
        //       ),
        //       const SizedBox(height: 30),
        //       InkWell(
        //         onTap: () {
        //           Get.to(ContractorHiringView());
        //         },
        //         child: Container(
        //             height: 150,
        //             width: MediaQuery.of(context).size.width * 0.7,
        //             color: Colors.blueAccent,
        //             child: Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,
        //               children: const [
        //                 Icon(
        //                   Icons.message,
        //                   color: Colors.white,
        //                   size: 50,
        //                 ),
        //                 SizedBox(height: 5),
        //                 Text(
        //                   'Appointment',
        //                   style: TextStyle(
        //                       fontSize: 24,
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500),
        //                 ),
        //               ],
        //             )),
        //       ),
        //     ],
        //   ),
        // )
      body: Column(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(5),
             // mainAxisSpacing: 20,
              children: [
                makeDashboardItem("Upload Profile ", "images/cost.jpeg", 0),
                makeDashboardItem("Notifications", "images/design.jpeg", 1),
                makeDashboardItem("Appointment", "images/contractor.jpeg", 2),
                makeDashboardItem("Our Design", "images/report.jpeg", 3),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50,
          color: Colors.orange,
          child: Row(
           children: [
              Expanded(
              child:  Icon(Icons.home),
            ),
            Expanded(
              child:  InkWell(
                onTap: (){
                  Get.to(const ContractorNotificationView());
                },
                child: Icon(Icons.message)),
            ),
            Expanded(
              child:  InkWell(
                onTap: (){
                  Get.to(const ContractorHiringView());
                },
                child:const Icon(Icons.notifications)),
            ),
             Expanded(
              child:  InkWell(
                onTap: (){
                  Get.to(ProfileInformation());
                },
                child:const Icon(Icons.person)),
            ),
           ],
          ),
        )
        ),
        );
  }

   @override
  Card makeDashboardItem(String title, String img, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: const LinearGradient(
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(3.0, -1.0),
            colors: [
              Color.fromARGB(255, 243, 243, 243),
              Color.fromARGB(255, 255, 255, 255)
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Get.to(const ContractorFormView());
            }
            if (index == 1) {
             Get.to(const ContractorNotificationView());
            }
            if (index == 2) {
                Get.to(const ContractorHiringView());
            }
            if (index == 3) {
               Get.to(const ContractorOurDesign());
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  img,
                  height: 50,
                  width: 50,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 19,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

}
