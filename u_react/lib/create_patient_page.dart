// import 'dart:convert';
// import 'dart:io';

import 'package:u_react/home_page.dart';
import 'package:u_react/slide_right_transition.dart';
import 'package:flutter/material.dart';
import 'package:u_react/patient_page.dart';
import 'package:u_react/models/patient.dart';
import 'package:u_react/api/patient_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:session_manager/session_manager.dart';

class CreatePatientPage extends StatefulWidget {
  const CreatePatientPage({super.key});

  @override
  State<CreatePatientPage> createState() => _CreatePatientPage();
}

/// Page for creating a new patient with the required fields.
class _CreatePatientPage extends State<CreatePatientPage> {
  /// Send the data to create a new patient.
  Future<dynamic> createPatient() async {
    try {
      String orgID = await SessionManager().getString("orgID");

      dynamic jsonPatient = await create({
        "orgID": orgID,
        "firstName": firstName.text,
        "lastName": lastName.text,
        "dOB": _date.text,
        "height": feet * 12 + inches,
        "weight": pounds,
        "sport": sport.text,
        "gender": gen,
        "thirdPartyID": thirdPartyID.text
      });
      Patient patient = Patient.fromJson(jsonPatient);
      return patient;
    } catch (e) {
      print("Error creating patient: $e");
    }
  }

  /// Throw error in case of invalid patient data.
  void throwError() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Required fields must have a value'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Controllers for patient data.
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController sport = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController thirdPartyID = TextEditingController();

  int feet = 0;
  int inches = 0;
  int pounds = 0;
  String gen = '';

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
            Navigator.pushReplacement(
              context,
              SlideRightRoute(page: const HomePage()),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (firstName.text == "" ||
                    lastName.text == "" ||
                    _date.text == "") {
                  throwError();
                } else {
                  Patient? createdPatient = await createPatient();
                  if (createdPatient != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientPage(
                          pID: createdPatient.pID,
                        ),
                      ),
                      result: true,
                    );
                  }
                }
              },
              child: const Text('Save'),
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
                          textCapitalization: TextCapitalization.words,
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
                          textCapitalization: TextCapitalization.words,
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
                        readOnly: true,
                        decoration: const InputDecoration(
                          labelText: "DOB *",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: _date,
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _date.text =
                                  "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                            });
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
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
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => Container(
                              height: 300,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: feet),
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          feet = index;
                                          height.text = "$feet' $inches\"";
                                        });
                                      },
                                      children: List.generate(12, (index) {
                                        return Center(
                                          child: Text('$index'),
                                        );
                                      }),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'ft',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: inches),
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          inches = index;
                                          height.text = "$feet' $inches\"";
                                        });
                                      },
                                      children: List.generate(12, (index) {
                                        return Center(
                                          child: Text('$index'),
                                        );
                                      }),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: Text(
                                        'inches',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
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
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) => Container(
                              height: 300,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: CupertinoPicker(
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem: pounds),
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          pounds = (index);
                                          weight.text = "$pounds lbs";
                                        });
                                      },
                                      children: List.generate(500, (index) {
                                        return Center(
                                          child: Text('$index'),
                                        );
                                      }),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        'lbs',
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: DropdownButtonFormField(
                        items: const [
                          DropdownMenuItem<String>(
                            value: 'M',
                            child: Text('M'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'F',
                            child: Text('F'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Other',
                            child: Text('Other'),
                          )
                        ],
                        onChanged: (String? value) {
                          setState(() {
                            gen = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: "Gender",
                          contentPadding: EdgeInsets.all(11),
                        ),
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
