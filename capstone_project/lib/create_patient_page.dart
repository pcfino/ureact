import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:capstone_project/patient_page.dart';
import 'package:capstone_project/models/patient.dart';
import 'package:capstone_project/api/patient_api.dart';

class CreatePatientPage extends StatefulWidget {
  const CreatePatientPage({super.key});

  @override
  State<CreatePatientPage> createState() => _CreatePatientPage();
}

class _CreatePatientPage extends State<CreatePatientPage> {
  Future<dynamic> createPatient() async {
    try {
      Patient newPatient = Patient(
          -1,
          firstName.text,
          lastName.text,
          dOB.text,
          height.text == "" ? 0 : int.parse(height.text),
          weight.text == "" ? 0 : int.parse(weight.text),
          sport.text,
          gender.text,
          thirdPartyID.text,
          List.empty());

      var jsonPatient = await create(newPatient);
      Patient patient = Patient.fromJson(jsonPatient);
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientPage(pID: patient.pID),
          ),
        );
      });
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dOB = TextEditingController();
  final TextEditingController sport = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController thirdPartyID = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Patient',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Patient'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  createPatient();
                });
              },
              child: Text('Save'),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "First *",
                            contentPadding: EdgeInsets.all(11),
                          ),
                          controller: firstName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: "Last *",
                            contentPadding: EdgeInsets.all(11),
                          ),
                          controller: lastName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "DOB *",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: dOB,
                        onTap: () async {
                          // DateTime? selectedDate = await showDatePicker(
                          //   context: context,
                          //   initialDate: DateTime.now(),
                          //   firstDate: DateTime(2000),
                          //   lastDate: DateTime.now(),
                          // );
                          // if (selectedDate != null) {
                          //   setState(() {
                          //     _date.text =
                          //         "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                          //   });
                          // }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Sport",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: sport,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Height",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: height,
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Weight",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: weight,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Gender",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: gender,
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "3rd Party ID",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: thirdPartyID,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
