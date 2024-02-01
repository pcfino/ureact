import 'dart:convert';
import 'dart:io';

import 'package:capstone_project/models/test.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/api/test_api.dart';

class CreateTestPage extends StatefulWidget {
  const CreateTestPage({super.key, required this.iID});

  final int iID;
  @override
  State<CreateTestPage> createState() => _CreateTestPage();
}

class _CreateTestPage extends State<CreateTestPage> {
  Future<dynamic> createTest() async {
    try {
      dynamic jsonTest = await create({
        "tName": selectedValue,
        "tDate": date.text,
        "tNotes": notes.text,
        "baseline": 0,
        "tID": widget.iID
      });

      Test test = Test.fromJson(jsonTest);
      return test;
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  final TextEditingController date = TextEditingController();
  final TextEditingController notes = TextEditingController();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Day of", child: Text("Day of")),
      const DropdownMenuItem(
          value: "Pre Return To Play", child: Text("Pre Return To Play")),
      const DropdownMenuItem(value: "Other", child: Text("Other")),
      const DropdownMenuItem(value: "Other 2", child: Text("Other 2")),
    ];
    return menuItems;
  }

  String selectedValue = "Day of";

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
            Navigator.pop(context);
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
                              "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                        });
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: TextField(
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
