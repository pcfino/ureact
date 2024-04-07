// import 'dart:convert';
// import 'dart:io';

import 'package:capstone_project/incident_page.dart';
import 'package:capstone_project/models/test.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/api/test_api.dart';

class CreateTestPage extends StatefulWidget {
  const CreateTestPage({super.key, required this.iID, required this.name});

  final int iID;
  final String name;
  @override
  State<CreateTestPage> createState() => _CreateTestPage();
}

class _CreateTestPage extends State<CreateTestPage> {
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

  final TextEditingController date = TextEditingController();
  final TextEditingController notes = TextEditingController();

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

  String selectedValue = "Pre RTP (Asymptomatic)";

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IncidentPage(iID: widget.iID),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Test? createdTest = await createTest();
                if (createdTest != null && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestsPage(tID: createdTest.tID),
                    ),
                  );
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
