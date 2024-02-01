import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:capstone_project/incident_page.dart';
import 'package:capstone_project/models/patient.dart';
import 'package:capstone_project/models/incident.dart';
import 'package:capstone_project/api/patient_api.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key, required this.pID});

  final int pID;
  @override
  State<PatientPage> createState() => _PatientPage();
}

class _PatientPage extends State<PatientPage> {
  Future<dynamic> getPatient(int pID) async {
    try {
      var jsonPatient = await get(pID);
      Patient patient = Patient.fromJson(jsonPatient);
      return patient;
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  final TextEditingController _date = TextEditingController();

  bool editMode = false;
  String mode = 'Edit';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPatient(widget.pID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Patient patient = snapshot.data! as Patient;
          int feet = patient.height! ~/ 12;
          int inches = patient.height! % 12;
          List<Incident> incidents = patient.incidents!;

          return MaterialApp(
            title: 'Patient',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Patient'),
                centerTitle: true,
                leading: BackButton(onPressed: () {
                  Navigator.pop(context);
                }),
                actions: <Widget>[
                  if (editMode)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () {
                        // delete
                      },
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (editMode) {
                          editMode = false;
                          mode = 'Edit';
                        } else if (!editMode) {
                          editMode = true;
                          mode = 'Save';
                        }
                      });
                    },
                    child: Text(mode),
                  ),
                ],
              ),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      if (!editMode)
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: TextField(
                            readOnly: !editMode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              labelText: "Name *",
                              contentPadding: EdgeInsets.all(11),
                            ),
                            controller: TextEditingController(
                              text: "${patient.firstName} ${patient.lastName}",
                            ),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (editMode)
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    labelText: "First *",
                                    contentPadding: EdgeInsets.all(11),
                                  ),
                                  controller: TextEditingController(
                                    text: patient.firstName,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  readOnly: !editMode,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    labelText: "Last *",
                                    contentPadding: EdgeInsets.all(11),
                                  ),
                                  controller: TextEditingController(
                                    text: patient.lastName,
                                  ),
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
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "DOB *",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: patient.dOB,
                              ),
                              onTap: () async {
                                if (editMode) {
                                  DateTime? selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      _date.text =
                                          "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "Sport",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: patient.sport,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "Height",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: "$feet'$inches\"",
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "Weight",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: "${patient.weight} lbs",
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "Gender",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: patient.gender,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              readOnly: !editMode,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                labelText: "3rd Party ID",
                                contentPadding: EdgeInsets.all(11),
                              ),
                              controller: TextEditingController(
                                text: patient.thirdPartyID,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Incidents',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: incidents.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(incidents[index].iName),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IncidentPage(
                                        isNewIncident: false,
                                        iID: incidents[index].iID),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const IncidentPage(isNewIncident: false, iID: 1),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endContained,
              bottomNavigationBar: BottomAppBar(
                  surfaceTintColor: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {}, child: const Text('Export Data')),
                    ],
                  )),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // or any other loading indicator
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }
}
