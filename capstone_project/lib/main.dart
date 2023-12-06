import 'dart:convert';
import 'package:capstone_project/patient_model.dart';
import 'package:capstone_project/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'dart:async';

// *******************************************************************************************
// START
// ignore: non_constant_identifier_names
String IOS_URL = 'http://127.0.0.1:8000/';
// ignore: non_constant_identifier_names
String ANDROID_URL = 'http://10.0.2.2:5000/';
// ignore: non_constant_identifier_names
String VERSION_URL = IOS_URL;

// these methods send/issue get and post requests to the python server
Future getData(url) async {
  var url2 = Uri.parse(url);
  Response response = await get(url2);
  return response.body;
}

Future sendData(int newNum) async {
  final response = await post(
    // ignore: prefer_interpolation_to_compose_strings
    Uri.parse(VERSION_URL + 'postData'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'counter': newNum}),
  );

  return response.body;
}
// END
// *******************************************************************************************

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  static List<PatientModel> patientList = [
    PatientModel("Abby", "Smith"),
    PatientModel("Alex", "Johnson"),
    PatientModel("Alfred", "Hitchcock"),
    PatientModel("Amy", "Winehouse"),
    PatientModel("Arnold", "Schwarzenegger"),
    PatientModel("Brant", "Kuithe"),
    PatientModel("Bob", "Thebuilder"),
    PatientModel("Bobby", "Newport"),
    PatientModel("Brett", "Favre"),
    PatientModel("Bill", "Gates"),
    PatientModel("Cam", "Hoefer"),
    PatientModel("Charlie", "Crockett"),
    PatientModel("Carson", "Wells"),
    PatientModel("Chris", "Jones"),
    PatientModel("Carson", "Palmer"),
    PatientModel("Josh", "Allen"),
    PatientModel("JJ", "Abrams"),
    PatientModel("Ron", "Burgundy"),
  ];

  List<PatientModel> displayPatientList = List.from(patientList);
  void alphabetize() {
    displayPatientList.sort((a, b) => a.lastName!.compareTo(b.lastName!));
  }

  void updateList(String value) {
    setState(() {
      displayPatientList = patientList
          .where((element) =>
              element.lastName!.toLowerCase().contains(value.toLowerCase()) ||
              element.firstName!.toLowerCase().contains(value.toLowerCase()) ||
              ("${element.firstName!} ${element.lastName!}")
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              ("${element.lastName!}, ${element.firstName!}")
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    alphabetize();
    return MaterialApp(
      title: 'Patients',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patients'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                // do something
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.red,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: displayPatientList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        elevation: 0,
                        color: Colors.white10,
                        shape: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${displayPatientList[index].lastName!}, ${displayPatientList[index].firstName!}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PatientPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: const Color(0xff03dac6),
          // foregroundColor: Colors.black,
          onPressed: () {
            // Respond to button press
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: () {}, child: const Text('Export List')),
              ],
            )),
      ),
    );
  }
}
