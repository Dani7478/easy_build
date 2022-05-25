import 'package:easy_build/View/Common%20Widgets/snackbar.dart';
import 'package:flutter/material.dart';

class ConstCalculationView extends StatefulWidget {
  const ConstCalculationView({Key? key}) : super(key: key);

  @override
  State<ConstCalculationView> createState() => _ConstCalculationViewState();
}

class _ConstCalculationViewState extends State<ConstCalculationView> {
  final _sizeList = [
    "Select Size",
    "3 Marla",
    "5 Marla",
    "7 Marla",
    '10 Marla',
    "1 Kanal"
  ];
  String sizeSelected = "Select Size";

  final _workList = ["Select Work", "Grey Structure", "Finishing"];
  String workSelected = "Select Work";
  String totalCost = '0';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cost Calculator...'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                  border: Border.all(color: Colors.teal)),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: DropdownButton(
                  value: sizeSelected,
                  items: _sizeList.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ));
                  }).toList(),
                  onChanged: (String? value) {
                    sizeSelected = value!;
                    setState(() {});
                    print(sizeSelected);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.orange,
                  border: Border.all(color: Colors.teal)),
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: DropdownButton(
                  value: workSelected,
                  items: _workList.map((String items) {
                    return DropdownMenuItem(
                        value: items,
                        child: Text(
                          items,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ));
                  }).toList(),
                  onChanged: (String? value) {
                    workSelected = value!;
                    setState(() {});
                    print(workSelected);
                  },
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              child: MaterialButton(
                onPressed: () async {
                  if (sizeSelected == 'Select Size' ||
                      workSelected == 'Select Work') {
                    snackBar(context, 'Please Select Size and Work', 'OK');
                  } else {
                    await calculate();
                    showDialoge(context);
                  }

                  // await fetchData();
                },
                color: Colors.orange,
                child: const Text(
                  'CALCULATE',
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
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 300,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, right: 20, left: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            totalCost,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: double.infinity,
                            child: ListTile(
                              leading: Icon(Icons.home),
                              title: Text(
                                sizeSelected,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            width: double.infinity,
                            child: ListTile(
                              leading: Icon(Icons.waterfall_chart_rounded),
                              title: Text(
                                workSelected,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: 200,
                          child: FlatButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: Text('OK')),
                        )
                      ],
                    ),
                  ),
                ),
                const Positioned(
                    top: -40,
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      radius: 40,
                      //child: Icon(Icons.assistant_photo, color: Colors.white, size: 50,),
                      child: ClipOval(
                        // child: Image.memory(
                        //   base64.decode(teacherImage),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Icon(
                          Icons.calculate,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    )),
              ],
            ));
      },
    );
  }

  calculate() {
    if (sizeSelected == '3 Marla' && workSelected == 'Grey Structure') {
      totalCost = '4,367,400';
      print(totalCost);
    } else if (sizeSelected == '5 Marla' && workSelected == 'Grey Structure') {
      totalCost = '5,727,500';
      print(totalCost);
    } else if (sizeSelected == '7 Marla' && workSelected == 'Grey Structure') {
      totalCost = '8,700,000';
      print(totalCost);
    } else if (sizeSelected == '10 Marla' && workSelected == 'Grey Structure') {
      totalCost = '9,570,000';
      print(totalCost);
    } else if (sizeSelected == '1 Kanal' && workSelected == 'Grey Structure') {
      totalCost = '17,272,400';
      print(totalCost);
    } else if (sizeSelected == '3 Marla' && workSelected == 'Finishing') {
      totalCost = '2,550,000';
      print(totalCost);
    } else if (sizeSelected == '5 Marla' && workSelected == 'Finishing') {
      totalCost = '3,357,500';
      print(totalCost);
    } else if (sizeSelected == '7 Marla' && workSelected == 'Finishing') {
      totalCost = '5,100,000';
      print(totalCost);
    } else if (sizeSelected == '10 Marla' && workSelected == 'Finishing') {
      totalCost = '5,610,000';
      print(totalCost);
    } else if (sizeSelected == '1 Kanal' && workSelected == 'Finishing') {
      totalCost = '10,125,200';
      print(totalCost);
    }
  }
}
