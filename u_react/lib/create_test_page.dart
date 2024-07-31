// import 'dart:convert';
// import 'dart:io';

import 'package:u_react/incident_page.dart';
import 'package:u_react/models/test.dart';
import 'package:u_react/slide_right_transition.dart';
import 'package:flutter/material.dart';
import 'package:u_react/tests_page.dart';
import 'package:u_react/api/test_api.dart';

class CreateTestPage extends StatefulWidget {
  const CreateTestPage(
      {super.key,
      required this.iID,
      required this.pID,
      required this.thirdPartyID,
      required this.name});

  final int iID;
  final int pID;
  final String name;
  final String? thirdPartyID;
  @override
  State<CreateTestPage> createState() => _CreateTestPage();
}

/// Page for creating a new patient with the required fields.
class _CreateTestPage extends State<CreateTestPage> {
  /// Send data to create a new test.
  Future<dynamic> createTest() async {
    try {
      String name = widget.name == "Baseline" ? "Baseline" : selectedValue;
      dynamic jsonTest = await create({
        "tName": name,
        "tDate": date.text,
        "tNotes": notes.text,
        "iID": widget.iID,
      });
      Test test = Test.fromJson(jsonTest);
      return test;
    } catch (e) {
      print("Error creating test: $e");
    }
  }

  /// Throw error in case of invalid data.
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

  /// Controllers for test data.
  final TextEditingController date = TextEditingController();
  final TextEditingController notes = TextEditingController();

  /// Sets the dropdown list.
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Acute", child: Text("Acute")),
      const DropdownMenuItem(value: "Post RTP", child: Text("Post RTP")),
      const DropdownMenuItem(
          value: "Pre RTP (Asymptomatic)",
          child: Text("Pre RTP (Asymptomatic)")),
      const DropdownMenuItem(
          value: "3 Month Followup", child: Text("3 Month Followup")),
      const DropdownMenuItem(
          value: "6 Month Followup", child: Text("6 Month Followup")),
      const DropdownMenuItem(
          value: "9 Month Followup", child: Text("9 Month Followup")),
      const DropdownMenuItem(
          value: "1 Year Followup", child: Text("1 Year Followup")),
    ];
    return menuItems;
  }

  /// Default value.
  String selectedValue = "Acute";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Test'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: IncidentPage(
                  iID: widget.iID,
                  thirdPartyID: widget.thirdPartyID,
                ),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (date.text == "") {
                  throwError();
                } else {
                  Test? createdTest = await createTest();
                  if (createdTest != null && context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TestsPage(
                          tID: createdTest.tID,
                          pID: widget.pID,
                          thirdPartyID: widget.thirdPartyID,
                        ),
                      ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.name == "Baseline")
                  Container(
                    padding: const EdgeInsets.fromLTRB(11, 0, 0, 0),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                if (widget.name != "Baseline")
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: DropdownButtonFormField(
                      disabledHint: Text(selectedValue),
                      value: selectedValue,
                      items: dropdownItems,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value!;
                        });
                      },
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        labelText: "Type *",
                        contentPadding: EdgeInsets.all(11),
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: TextField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Date *",
                      contentPadding: EdgeInsets.all(11),
                    ),
                    controller: date,
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          date.text =
                              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Notes",
                    ),
                    controller: notes,
                    onSubmitted: (value) {
                      notes.text = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
