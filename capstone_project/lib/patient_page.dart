import 'package:capstone_project/models/test.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:capstone_project/create_incident_page.dart';
import 'package:capstone_project/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/incident_page.dart';
import 'package:capstone_project/models/patient.dart';
import 'package:capstone_project/models/incident.dart';
import 'package:capstone_project/api/patient_api.dart';
import 'package:capstone_project/api/export_api.dart' as export_api;
import 'package:capstone_project/slide_right_transition.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key, required this.pID});

  final int pID;
  @override
  State<PatientPage> createState() => _PatientPage();
}

class _PatientPage extends State<PatientPage> {
  late Future<dynamic> future;

  @override
  void initState() {
    super.initState();
    future = getPatient(widget.pID);
  }

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
    } catch (e) {
      print("Error updating patient: $e");
    }
  }

  Future<dynamic> deletePatient(int pID) async {
    try {
      bool deleted = await delete(pID);
      if (deleted) {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        });
      }
    } catch (e) {
      print("Error deleting patient: $e");
    }
  }

  Future<dynamic> getExport(int pID) async {
    try {
      dynamic jsonExport = await export_api.get(pID);
      return jsonExport[0];
    } catch (e) {
      print("Error fetching export data: $e");
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

  void exportPatientData() async {
    // Get patient data
    String fileName = "";
    List<List<dynamic>> rows = [];
    rows.add([
      '3rd Party ID',
      'Incident',
      'Incident Date/Time',
      'Condition',
      'Reactive MTime',
      'Static TL Solid ML',
      'Static TL Foam ML',
      // 'Dynamic T1 Duration',
      // 'Dynamic T1 TurnSpeed',
      // 'Dynamic T1 ML Sway',
      // 'Dynamic T2 Duration',
      // 'Dynamic T2 TurnSpeed',
      // 'Dynamic T2 ML Sway',
      // 'Dynamic T3 Duration',
      // 'Dynamic T3 TurnSpeed',
      // 'Dynamic T3 ML Sway',
      'dMax',
      'dMin',
      'dMean',
      'dMedian',
      'tsMax',
      'tsMin',
      'tsMean',
      'tsMedian',
      'mlMax',
      'mlMin',
      'mlMean',
      'mlMedian',
    ]);

    List<dynamic> colHeaders = rows[0];
    Map<String, dynamic> json = await getExport(widget.pID);
    Map<int, Map<String, dynamic>> processedJson = {};

    print(json);

    if (json.containsKey('thirdPartyID')) {
      fileName = "patient${json['thirdPartyID']}";
      if (json.containsKey('incidents')) {
        List<dynamic> incidents = json['incidents'];

        // Iterate over incidents
        for (var incident in incidents) {
          if (incident.containsKey('tests')) {
            List<dynamic> tests = incident['tests'];

            // Iterate over tests
            for (var test in tests) {
              bool hasData = false;
              double? reactiveMTime;

              double? staticTLSolidML;
              double? staticTLFoamML;

              // double? dynamicT1Duration;
              // double? dynamicT1TurnSpeed;
              // double? dynamicT1MLSway;

              // double? dynamicT2Duration;
              // double? dynamicT2TurnSpeed;
              // double? dynamicT2MLSway;

              // double? dynamicT3Duration;
              // double? dynamicT3TurnSpeed;
              // double? dynamicT3MLSway;

              double? dMax;
              double? dMin;
              double? dMean;
              double? dMedian;
              double? tsMax;
              double? tsMin;
              double? tsMean;
              double? tsMedian;
              double? mlMax;
              double? mlMin;
              double? mlMean;
              double? mlMedian;

              // Get reactive test data
              if (test.containsKey('reactive')) {
                if (test['reactive'].length != 0) {
                  reactiveMTime = test['reactive']['mTime'];
                  hasData = true;
                }
              }
              // Get static test data
              else if (test.containsKey('static')) {
                if (test['static'].length != 0) {
                  staticTLSolidML = test['static']['tlSolidML'];
                  staticTLFoamML = test['static']['tlFoamML'];
                  hasData = true;
                }
              }
              // Get dynamic test data
              else if (test.containsKey('dynamic')) {
                if (test['dynamic'].length != 0) {
                  // dynamicT1Duration = test['dynamic']['t1Duration'];
                  // dynamicT1TurnSpeed = test['dynamic']['t1TurnSpeed'];
                  // dynamicT1MLSway = test['dynamic']['t1MLSway'];

                  // dynamicT2Duration = test['dynamic']['t2Duration'];
                  // dynamicT2TurnSpeed = test['dynamic']['t2TurnSpeed'];
                  // dynamicT2MLSway = test['dynamic']['t2MLSway'];

                  // dynamicT3Duration = test['dynamic']['t3Duration'];
                  // dynamicT3TurnSpeed = test['dynamic']['t3TurnSpeed'];
                  // dynamicT3MLSway = test['dynamic']['t3MLSway'];

                  dMax = test['dynamic']['dMax'];
                  dMin = test['dynamic']['dMin'];
                  dMean = test['dynamic']['dMean'];
                  dMedian = test['dynamic']['dMedian'];

                  tsMax = test['dynamic']['tsMax'];
                  tsMin = test['dynamic']['tsMin'];
                  tsMean = test['dynamic']['tsMean'];
                  tsMedian = test['dynamic']['tsMedian'];

                  mlMax = test['dynamic']['mlMax'];
                  mlMin = test['dynamic']['mlMin'];
                  mlMean = test['dynamic']['mlMean'];
                  mlMedian = test['dynamic']['mlMedian'];

                  hasData = true;
                }
              }

              List<dynamic> row;

              if (hasData) {
                row = [
                  json['thirdPartyID'],
                  incident['iName'],
                  incident['iDate'],
                  incident['iNotes'],
                  reactiveMTime,
                  staticTLSolidML,
                  staticTLFoamML,
                  // dynamicT1Duration,
                  // dynamicT1TurnSpeed,
                  // dynamicT1MLSway,
                  // dynamicT2Duration,
                  // dynamicT2TurnSpeed,
                  // dynamicT2MLSway,
                  // dynamicT3Duration,
                  // dynamicT3TurnSpeed,
                  // dynamicT3MLSway,
                  dMax,
                  dMin,
                  dMean,
                  dMedian,
                  tsMax,
                  tsMin,
                  tsMean,
                  tsMedian,
                  mlMax,
                  mlMin,
                  mlMean,
                  mlMedian,
                ];
                rows.add(row);

                // Condense csv rows to group related data
                if (processedJson.containsKey(test['tID'])) {
                  int headerIndex = 0;
                  for (var col in row) {
                    if (processedJson[test['tID']]?[colHeaders[headerIndex]] ==
                            null &&
                        col != null) {
                      processedJson[test['tID']]![colHeaders[headerIndex]] =
                          col;
                    }
                    headerIndex++;
                  }
                } else {
                  int headerIndex = 0;
                  for (var col in row) {
                    if (processedJson[test['tID']] == null) {
                      processedJson[test['tID']] = {};
                    }
                    processedJson[test['tID']]![colHeaders[headerIndex++]] =
                        col;
                  }
                }
              }
            }
          }
        }
      }
    }

    rows.clear();
    rows.add(colHeaders);
    // Reorder the row data so that it matches the csv column order
    processedJson.forEach((test, row) {
      List<dynamic> orderedRow = [];
      for (String header in colHeaders) {
        orderedRow.add(row[header]);
      }
      rows.add(orderedRow);
    });

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
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController thirdPartyID = TextEditingController();

  bool editMode = false;
  String mode = 'Edit';

  Patient? patient;
  int feet = 0;
  int inches = 0;
  int weight = 0;
  List<Incident>? incidents;
  String gen = '';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (patient == null) {
            patient = snapshot.data! as Patient;
            feet = patient!.height! ~/ 12;
            inches = patient!.height! % 12;
            incidents = patient!.incidents!;
            fullName.text = "${patient!.firstName} ${patient!.lastName}";
            firstName.text = patient!.firstName;
            lastName.text = patient!.lastName;
            dOB.text = patient!.dOB!.toString();
            sport.text = patient!.sport!;
            weightController.text = "${patient!.weight!} lbs";
            weight = patient!.weight!;
            heightController.text = "$feet' $inches\"";
            gen = patient!.gender!;
            thirdPartyID.text = patient!.thirdPartyID!;
          }

          return MaterialApp(
            title: 'Patient',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            home: GestureDetector(
              onPanUpdate: (details) {
                // Swiping in right direction.
                if (details.delta.dx > 0) {
                  Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                      page: const HomePage(),
                    ),
                  );
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Patient'),
                  centerTitle: true,
                  leading: BackButton(onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      SlideRightRoute(
                        page: const HomePage(),
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
                          deletePatient(patient!.pID);
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
                            "height": feet * 12 + inches,
                            "weight": weight,
                            "sport": sport.text,
                            "gender": gen,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!editMode)
                          TextField(
                            textCapitalization: TextCapitalization.words,
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
                        if (editMode)
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  textCapitalization: TextCapitalization.words,
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
                                  textCapitalization: TextCapitalization.words,
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
                                    DateTime? selectedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
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
                                textCapitalization: TextCapitalization.words,
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
                                controller: heightController,
                                onTap: () {
                                  if (editMode) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
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
                                                onSelectedItemChanged:
                                                    (int index) {
                                                  setState(() {
                                                    feet = index;
                                                    heightController.text =
                                                        "$feet' $inches\"";
                                                  });
                                                },
                                                children:
                                                    List.generate(12, (index) {
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
                                                    decoration:
                                                        TextDecoration.none,
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
                                                onSelectedItemChanged:
                                                    (int index) {
                                                  setState(() {
                                                    inches = index;
                                                    heightController.text =
                                                        "$feet' $inches\"";
                                                  });
                                                },
                                                children:
                                                    List.generate(12, (index) {
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
                                                    decoration:
                                                        TextDecoration.none,
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
                                  }
                                },
                                readOnly: !editMode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: "Height",
                                  contentPadding: EdgeInsets.all(11),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                onTap: () {
                                  if (editMode) {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
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
                                                        initialItem: weight),
                                                itemExtent: 32.0,
                                                onSelectedItemChanged:
                                                    (int index) {
                                                  setState(() {
                                                    weight = (index);
                                                    weightController.text =
                                                        "$weight lbs";
                                                  });
                                                },
                                                children:
                                                    List.generate(500, (index) {
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
                                                    decoration:
                                                        TextDecoration.none,
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
                                  }
                                },
                                readOnly: !editMode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: "Weight",
                                  contentPadding: EdgeInsets.all(11),
                                ),
                                controller: weightController,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField(
                                //disabledHint: Text(gen),
                                value: gen,
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
                                  ),
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text(''),
                                  )
                                ],
                                onChanged: editMode
                                    ? (String? value) {
                                        setState(() {
                                          gen = value!;
                                        });
                                      }
                                    : null,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  labelText: "Gender",
                                  contentPadding: EdgeInsets.all(11),
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
                                controller: thirdPartyID,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Incidents',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: incidents!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(incidents![index].iName),
                                subtitle: Text(incidents![index].iDate),
                                onTap: () {
                                  if (!editMode) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => IncidentPage(
                                            iID: incidents![index].iID),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
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
                          pID: patient!.pID,
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
