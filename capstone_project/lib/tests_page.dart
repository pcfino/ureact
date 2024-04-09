import 'package:capstone_project/dynamic_test_page.dart';
import 'package:capstone_project/export_data.dart';
import 'package:capstone_project/reactive_test_page.dart';
import 'package:capstone_project/dynamic_results_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/test.dart';
import 'package:capstone_project/static_test_page.dart';
import 'package:capstone_project/reactive_test_results_page.dart';
import 'package:capstone_project/static_results_page.dart';
import 'package:capstone_project/incident_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/slide_right_transition.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key, required this.tID, required this.pID});

  final int tID;
  final int pID;

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  late Future<dynamic> future;
  late Future<dynamic> baselineFuture;

  @override
  void initState() {
    super.initState();

    future = getTest(widget.tID);
    baselineFuture = getBaselineTest(widget.tID);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<dynamic> getTest(int tID) async {
    try {
      var jsonTest = await getAllTests(tID);
      if (!jsonTest[0]["reactiveTest"].containsKey("rID")) {
        jsonTest[0].remove("reactiveTest");
      } else if (jsonTest[0]["reactiveTest"]["administeredBy"] == null) {
        jsonTest[0]["reactiveTest"]["administeredBy"] = "None";
      }
      if (!jsonTest[0]["dynamicTest"].containsKey("dID")) {
        jsonTest[0].remove("dynamicTest");
      } else if (jsonTest[0]["dynamicTest"]["administeredBy"] == null) {
        jsonTest[0]["dynamicTest"]["administeredBy"] = "None";
      }
      if (!jsonTest[0]["staticTest"].containsKey("sID")) {
        jsonTest[0].remove("staticTest");
      } else if (jsonTest[0]["staticTest"]["administeredBy"] == null) {
        jsonTest[0]["staticTest"]["administeredBy"] = "None";
      }
      Test test = Test.fromJson(jsonTest[0]);
      return test;
    } catch (e) {
      print("Error getting test: $e");
    }
  }

  Future<dynamic> updateTest(Map<String, dynamic> updated) async {
    try {
      var jsonTest = await update(updated);
      test?.tName = jsonTest["tName"];
      test?.tDate = jsonTest["tDate"];
      test?.tNotes = jsonTest["tNotes"];
    } catch (e) {
      print("Error updating test: $e");
    }
  }

  void setTest() {
    selectedValue = test!.tName;
    _date.text = test!.tDate;
    notes.text = test!.tNotes!;
  }

  Future<dynamic> deleteTest() async {
    try {
      bool deleted = await delete(widget.tID);
      if (deleted && context.mounted) {
        Navigator.pushReplacement(
            context,
            SlideRightRoute(
                page: IncidentPage(
              iID: test!.iID,
            )));
      }
    } catch (e) {
      print("Error deleting test: $e");
    }
  }

  Future<dynamic> getBaselineTest(int tID) async {
    try {
      var jsonTest = await getBaseline(tID);
      if (jsonTest[0]["reactiveTest"]["administeredBy"] == null) {
        jsonTest[0]["reactiveTest"]["administeredBy"] = "None";
      }
      if (jsonTest[0]["dynamicTest"]["administeredBy"] == null) {
        jsonTest[0]["dynamicTest"]["administeredBy"] = "None";
      }
      if (jsonTest[0]["staticTest"]["administeredBy"] == null) {
        jsonTest[0]["staticTest"]["administeredBy"] = "None";
      }
      return jsonTest[0];
    } catch (e) {
      return null;
    }
  }

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

  String? expData = "Test Data";

  void exportPopUp() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Export Test'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                  title: const Text('Test Data'),
                  value: "Test Data",
                  onChanged: (String? value) {
                    setState(() {
                      expData = value!;
                    });
                  },
                  groupValue: expData,
                ),
                RadioListTile(
                  title: const Text('IMU Data'),
                  value: "IMU Data",
                  groupValue: expData,
                  onChanged: (String? value) {
                    setState(() {
                      expData = value!;
                    });
                  },
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Export'),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (expData == "Test Data") {
                    // export test data
                  } else if (expData == "IMU Data") {
                    // export IMU data
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

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

  bool editMode = false;
  String mode = 'Edit';

  bool reactiveTile = false;
  String selectedValue = "Pre Return";

  final TextEditingController _date = TextEditingController();
  final TextEditingController notes = TextEditingController();

  Test? test;
  dynamic baseline;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        future,
        baselineFuture,
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (test == null) {
            test = snapshot.data![0] as Test;
            selectedValue = test!.tName;
            _date.text = test!.tDate;
            notes.text = test!.tNotes!;
            baseline = snapshot.data![1];
          }

          return MaterialApp(
            title: 'Test',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Test'),
                centerTitle: true,
                leading: BackButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                      page: IncidentPage(iID: test!.iID),
                    ),
                  );
                }),
                actions: <Widget>[
                  if (editMode)
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                      ),
                      onPressed: () async {
                        await deleteTest();
                      },
                    ),
                  TextButton(
                    onPressed: () async {
                      if (editMode) {
                        if (_date.text == "") {
                          throwError();
                        } else {
                          var newTest = {
                            "tID": widget.tID,
                            "tName": selectedValue,
                            "tDate": _date.text,
                            "tNotes": notes.text,
                          };
                          await updateTest(newTest);
                          setTest();
                          editMode = false;
                          mode = 'Edit';
                        }
                      } else if (!editMode) {
                        editMode = true;
                        mode = 'Save';
                      }
                      setState(() {});
                    },
                    child: Text(mode),
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!editMode || selectedValue == "Baseline")
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color.fromRGBO(255, 220, 212, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ListTile(
                            title: Text(
                              selectedValue,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    if (editMode && selectedValue != "Baseline")
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: DropdownButtonFormField(
                          value: selectedValue,
                          items: dropdownItems,
                          onChanged: (String? value) {
                            setState(() {
                              selectedValue = value!;
                              if (editMode) {
                                //incident.iName = selectedValue;
                              }
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
                        controller: _date,
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
                                if (editMode) {
                                  //incident.iDate =
                                  // "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
                                }
                              });
                            }
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        readOnly: !editMode,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Notes",
                        ),
                        controller: notes,
                        onSubmitted: (value) {
                          if (editMode) {
                            //incident.iNotes = value;
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: const Text(
                        'Test Types',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: ListView(shrinkWrap: true, children: [
                        ListTile(
                          onTap: () {
                            if (!editMode) {
                              if (test!.reactiveTest != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReactiveTestResultsPage(
                                      pID: widget.pID,
                                      administeredBy:
                                          test!.reactiveTest!.administeredBy,
                                      backward:
                                          test!.reactiveTest!.bTime * 1000,
                                      forward: test!.reactiveTest!.fTime * 1000,
                                      left: test!.reactiveTest!.lTime * 1000,
                                      right: test!.reactiveTest!.rTime * 1000,
                                      median: test!.reactiveTest!.mTime * 1000,
                                      tID: test!.tID,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReactiveTestPage(
                                      pID: widget.pID,
                                      direction: 'Forward',
                                      forward: 0,
                                      left: 0,
                                      right: 0,
                                      backward: 0,
                                      tID: widget.tID,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          title: const Text(
                            'Reactive',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.reactiveTest == null
                              ? Icons.add
                              : Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          onTap: () {
                            // check if dynamic exists
                            if (!editMode) {
                              if (test!.dynamicTest != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DynamicResultsPage(
                                      pID: widget.pID,
                                      administeredBy:
                                          test!.dynamicTest!.administeredBy,
                                      t1Duration:
                                          test!.dynamicTest!.t1Duration * 1000,
                                      t1TurnSpeed:
                                          test!.dynamicTest!.t1TurnSpeed,
                                      t1MLSway:
                                          test!.dynamicTest!.t1MLSway * 100,
                                      t2Duration:
                                          test!.dynamicTest!.t2Duration * 1000,
                                      t2TurnSpeed:
                                          test!.dynamicTest!.t2TurnSpeed,
                                      t2MLSway:
                                          test!.dynamicTest!.t2MLSway * 100,
                                      t3Duration:
                                          test!.dynamicTest!.t3Duration * 1000,
                                      t3TurnSpeed:
                                          test!.dynamicTest!.t3TurnSpeed,
                                      t3MLSway:
                                          test!.dynamicTest!.t3MLSway * 100,
                                      dMax: test!.dynamicTest!.dMax * 1000,
                                      dMin: test!.dynamicTest!.dMin * 1000,
                                      dMean: test!.dynamicTest!.dMean * 1000,
                                      dMedian:
                                          test!.dynamicTest!.dMedian * 1000,
                                      tsMax: test!.dynamicTest!.tsMax,
                                      tsMin: test!.dynamicTest!.tsMin,
                                      tsMean: test!.dynamicTest!.tsMean,
                                      tsMedian: test!.dynamicTest!.tsMedian,
                                      mlMax: test!.dynamicTest!.mlMax * 100,
                                      mlMin: test!.dynamicTest!.mlMin * 100,
                                      mlMean: test!.dynamicTest!.mlMean * 100,
                                      mlMedian:
                                          test!.dynamicTest!.mlMedian * 100,
                                      tID: widget.tID,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DynamicTestPage(
                                      pID: widget.pID,
                                      tID: widget.tID,
                                      start: true,
                                      trialNumber: 1,
                                      t1Duration: 0,
                                      t1TurnSpeed: 0,
                                      t1MLSway: 0,
                                      t2Duration: 0,
                                      t2TurnSpeed: 0,
                                      t2MLSway: 0,
                                      t3Duration: 0,
                                      t3TurnSpeed: 0,
                                      t3MLSway: 0,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          title: const Text(
                            'Dynamic',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.dynamicTest == null
                              ? Icons.add
                              : Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          onTap: () {
                            if (!editMode) {
                              // check if static exists
                              if (test!.staticTest != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticResultsPage(
                                      pID: widget.pID,
                                      administeredBy:
                                          test!.staticTest!.administeredBy,
                                      tID: widget.tID,
                                      tlSolidML:
                                          test!.staticTest!.tlSolidML * 100,
                                      tlFoamML:
                                          test!.staticTest!.tlFoamML * 100,
                                      slSolidML:
                                          test!.staticTest!.slSolidML * 100,
                                      slFoamML:
                                          test!.staticTest!.slSolidML * 100,
                                      tandSolidML:
                                          test!.staticTest!.tandSolidML * 100,
                                      tandFoamML:
                                          test!.staticTest!.tandFoamML * 100,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      pID: widget.pID,
                                      tID: widget.tID,
                                      stance: "Two Leg Stance (Solid)",
                                      tlSolidML: 0,
                                      tlFoamML: 0,
                                      slSolidML: 0,
                                      slFoamML: 0,
                                      tandSolidML: 0,
                                      tandFoamML: 0,
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          title: const Text(
                            'Static',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.staticTest == null
                              ? Icons.add
                              : Icons.arrow_forward_ios),
                        ),
                      ]),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    if (selectedValue != "Baseline" && baseline != null)
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        child: const Text(
                          'Baseline',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (selectedValue != "Baseline" && baseline != null)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey,
                      ),
                    if (selectedValue != "Baseline" && baseline != null)
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              onTap: () {
                                if (!editMode) {
                                  if (baseline["reactiveTest"]["rID"] != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReactiveTestResultsPage(
                                          pID: widget.pID,
                                          administeredBy:
                                              baseline["reactiveTest"]
                                                  ["administeredBy"],
                                          backward: baseline["reactiveTest"]
                                                  ["bTime"] *
                                              1000,
                                          forward: baseline["reactiveTest"]
                                                  ["fTime"] *
                                              1000,
                                          left: baseline["reactiveTest"]
                                                  ["lTime"] *
                                              1000,
                                          right: baseline["reactiveTest"]
                                                  ["rTime"] *
                                              1000,
                                          median: baseline["reactiveTest"]
                                                  ["mTime"] *
                                              1000,
                                          tID: widget.tID,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              title: const Text(
                                'Reactive',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                  baseline["reactiveTest"]["rID"] == null
                                      ? null
                                      : Icons.arrow_forward_ios),
                            ),
                            ListTile(
                              onTap: () {
                                if (!editMode) {
                                  if (baseline["dynamicTest"]["dID"] != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DynamicResultsPage(
                                          pID: widget.pID,
                                          administeredBy:
                                              baseline["dynamicTest"]
                                                  ["administeredBy"],
                                          t1Duration: baseline["dynamicTest"]
                                                  ["t1Duration"] *
                                              1000,
                                          t1TurnSpeed: baseline["dynamicTest"]
                                              ["t1TurnSpeed"],
                                          t1MLSway: baseline["dynamicTest"]
                                                  ["t1MLSway"] *
                                              100,
                                          t2Duration: baseline["dynamicTest"]
                                                  ["t2Duration"] *
                                              1000,
                                          t2TurnSpeed: baseline["dynamicTest"]
                                              ["t2TurnSpeed"],
                                          t2MLSway: baseline["dynamicTest"]
                                                  ["t2MLSway"] *
                                              100,
                                          t3Duration: baseline["dynamicTest"]
                                                  ["t3Duration"] *
                                              1000,
                                          t3TurnSpeed: baseline["dynamicTest"]
                                              ["t3TurnSpeed"],
                                          t3MLSway: baseline["dynamicTest"]
                                                  ["t3MLSway"] *
                                              100,
                                          dMax: baseline["dynamicTest"]
                                                  ["dMax"] *
                                              1000,
                                          dMin: baseline["dynamicTest"]
                                                  ["dMin"] *
                                              1000,
                                          dMean: baseline["dynamicTest"]
                                                  ["dMean"] *
                                              1000,
                                          dMedian: baseline["dynamicTest"]
                                                  ["dMedian"] *
                                              1000,
                                          tsMax: baseline["dynamicTest"]
                                              ["tsMax"],
                                          tsMin: baseline["dynamicTest"]
                                              ["tsMin"],
                                          tsMean: baseline["dynamicTest"]
                                              ["tsMean"],
                                          tsMedian: baseline["dynamicTest"]
                                              ["tsMedian"],
                                          mlMax: baseline["dynamicTest"]
                                                  ["mlMax"] *
                                              100,
                                          mlMin: baseline["dynamicTest"]
                                                  ["mlMin"] *
                                              100,
                                          mlMean: baseline["dynamicTest"]
                                                  ["mlMean"] *
                                              100,
                                          mlMedian: baseline["dynamicTest"]
                                                  ["mlMedian"] *
                                              100,
                                          tID: widget.tID,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              title: const Text(
                                'Dynamic',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                  baseline["dynamicTest"]["dID"] == null
                                      ? null
                                      : Icons.arrow_forward_ios),
                            ),
                            ListTile(
                              onTap: () {
                                if (!editMode) {
                                  if (baseline["staticTest"]["sID"] != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StaticResultsPage(
                                          pID: widget.pID,
                                          administeredBy: baseline["staticTest"]
                                              ["administeredBy"],
                                          tID: widget.tID,
                                          tlSolidML: baseline["staticTest"]
                                              ["tlSolidML"],
                                          tlFoamML: baseline["staticTest"]
                                              ["tlFoamML"],
                                          slSolidML: baseline["staticTest"]
                                              ["slSolidML"],
                                          slFoamML: baseline["staticTest"]
                                              ["slFoamML"],
                                          tandSolidML: baseline["staticTest"]
                                              ["tandSolidML"],
                                          tandFoamML: baseline["staticTest"]
                                              ["tandFoamML"],
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              title: const Text(
                                'Static',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(
                                  baseline["staticTest"]["sID"] == null
                                      ? null
                                      : Icons.arrow_forward_ios),
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                  surfaceTintColor: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                          onPressed: () {
                            exportPopUp();
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
