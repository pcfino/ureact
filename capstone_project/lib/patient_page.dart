import 'package:capstone_project/models/test.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:capstone_project/create_incident_page.dart';
import 'package:capstone_project/main.dart';
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
  late final List<Incident> incidents;

  Future<dynamic> getPatient(int pID) async {
    try {
      var jsonPatient = await get(pID);
      Patient patient = Patient.fromJson(jsonPatient[0]);
      return patient;
    } catch (e) {
      print("Error fetching patient: $e");
    }
  }

  Future<dynamic> savePatient(Map<String, dynamic> updatePatient) async {
    try {
      await update(widget.pID, updatePatient);
      // Patient patient = Patient.fromJson(jsonPatient);
      // return patient;
      // setState(() {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => PatientPage(pID: widget.pID),
      //     ),
      //   );
      // });
    } catch (e) {
      print("Error updating patient: $e");
    }
  }

  Future<dynamic> deletePatient(int pID) async {
    try {
      bool deleted = await delete(pID);
      if (deleted) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          );
        });
      }
    } catch (e) {
      print("Error deleting patient: $e");
    }
  }

  Future<dynamic> getIncident(int iID) async {
    try {
      dynamic jsonIncident = await get(iID);
      return Incident.fromJson(jsonIncident[0]);
    } catch (e) {
      print("Error fetching incidents: $e");
    }
  }

  Future<dynamic> getTest(int tID) async {
    try {
      var jsonTest = await get(tID);
      return Test.fromJson(jsonTest[0]);
    } catch (e) {
      print("Error getting test: $e");
    }
  }

  Future<XFile> createCSVFile(String fileName, String fileContent) async {
    final dir = await getApplicationDocumentsDirectory();
    final csvFile = File('${dir.path}/$fileName.csv');
    await csvFile.writeAsString(fileContent);
    final xCsvFile = XFile('${dir.path}/$fileName.csv');
    return xCsvFile;
  }

  Future<void> exportCSV(XFile file) async {
    Share.shareXFiles([file]);
  }

  // Future<void> getFilePicker() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles();
  //   if (result != null) {
  //     File file = File(result.files.single.path ?? "");
  //     await file.readAsString().then((value) => print(value));
  //   } else {
  //     print("User canceled selection");
  //   }
  // }

  void exportPatientData() async {
    // Get patient data
    String fileName = 'patient2';
    List<List<dynamic>> rows = [];
    rows.add([
      '3rd Party ID',
      'Incident',
      'Incident Date/Time',
      'Condition',
      'Reactive TTS'
    ]);
    for (var incident in incidents) {
      print("ENTERED INCIDENT");
      Incident i = await getIncident(incident.iID);
      if (i.tests != null) {
        for (var test in incident.tests ?? []) {
          print("ENTERED TEST");
          print(thirdPartyID.text);
          print(incident.iName);
          print(incident.iDate);
          print(test?.reactive?.mTime);

          rows.add([
            thirdPartyID.text,
            incident.iName,
            incident.iDate,
            incident.iNotes,
            test?.reactive?.mTime
          ]);
        }
      }
    }

    // Export patient data
    String csv = const ListToCsvConverter().convert(rows);
    String fileContent = csv;
    XFile csvFile = await createCSVFile(fileName, fileContent);
    await exportCSV(csvFile);
  }

  final TextEditingController fullName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController dOB = TextEditingController();
  final TextEditingController sport = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController thirdPartyID = TextEditingController();

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
          incidents = patient.incidents!;
          fullName.text = "${patient.firstName} ${patient.lastName}";
          firstName.text = patient.firstName;
          lastName.text = patient.lastName;
          dOB.text = patient.dOB!.toString();
          sport.text = patient.sport!;
          weight.text = patient.weight!.toString();
          height.text = patient.height!.toString();
          gender.text = patient.gender!;
          thirdPartyID.text = patient.thirdPartyID!;

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                }),
                actions: <Widget>[
                  if (editMode)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () {
                        deletePatient(patient.pID);
                      },
                    ),
                  TextButton(
                    onPressed: () {
                      if (!editMode) {
                        setState(() {
                          mode = 'Save';
                          editMode = true;
                        });
                      } else if (editMode) {
                        editMode = false;

                        var updatePatient = {
                          "firstName": firstName.text,
                          "lastName": lastName.text,
                          "dOB": dOB.text,
                          "height": int.parse(height.text),
                          "weight": int.parse(weight.text),
                          "sport": sport.text,
                          "gender": gender.text,
                          "thirdPartyID": thirdPartyID.text
                        };
                        setState(() {
                          mode = 'Edit';
                          savePatient(updatePatient);
                        });
                      }
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
                            controller: fullName,
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
                                  controller: firstName,
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
                              controller: dOB,
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
                                      dOB.text =
                                          "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
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
                              controller: sport,
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
                              controller: height,
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
                              controller: weight,
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
                              controller: gender,
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
                              controller: thirdPartyID,
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
                              subtitle: Text(incidents[index].iDate),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        IncidentPage(iID: incidents[index].iID),
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
                      builder: (context) => CreateIncidentPage(
                        pID: patient.pID,
                      ),
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
                          onPressed: () {
                            exportPatientData();
                          },
                          child: const Text('Export Data')),
                    ],
                  )),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }
}
