import 'package:capstone_project/dynamic_test_page.dart';
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
  const TestsPage({super.key, required this.tID});

  final int tID;

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  late Future<dynamic> future;

  @override
  void initState() {
    super.initState();

    future = getTest(widget.tID);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<dynamic> getTest(int tID) async {
    try {
      var jsonTest = await getAllTests(tID);
      if (!jsonTest[0]["reactiveTest"].containsKey("rID")) {
        jsonTest[0].remove("reactiveTest");
      }
      if (!jsonTest[0]["dynamicTest"].containsKey("dID")) {
        jsonTest[0].remove("dynamicTest");
      }
      if (!jsonTest[0]["staticTest"].containsKey("sID")) {
        jsonTest[0].remove("staticTest");
      }
      Test test = Test.fromJson(jsonTest[0]);
      return test;
    } catch (e) {
      print("Error getting test: $e");
    }
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (test == null) {
            test = snapshot.data! as Test;
            selectedValue = test!.tName;
            _date.text = test!.tDate;
            notes.text = test!.tNotes!;
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
                  Navigator.push(
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
                      onPressed: () {
                        //delete(incident.iID);
                        Navigator.pop(context);
                        // TODO: get incident to navigate back to a fresh copy without the test that was just deleted
                      },
                    ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (editMode) {
                          editMode = false;
                          mode = 'Edit';
                          //savePatient(patient);
                        } else if (!editMode) {
                          editMode = true;
                          mode = 'Save';
                        }
                      });
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
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: DropdownButtonFormField(
                        value: selectedValue,
                        items: dropdownItems,
                        onChanged: editMode
                            ? (String? value) {
                                setState(() {
                                  selectedValue = value!;
                                  if (editMode) {
                                    //incident.iName = selectedValue;
                                  }
                                });
                              }
                            : null,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Name *",
                          contentPadding: EdgeInsets.all(11),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                      child: TextField(
                        readOnly: !editMode,
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
                      child: ListView(children: [
                        ListTile(
                          onTap: () {
                            if (test!.reactiveTest != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReactiveTestResultsPage(
                                    backward: test!.reactiveTest!.bTime,
                                    forward: test!.reactiveTest!.fTime,
                                    left: test!.reactiveTest!.lTime,
                                    right: test!.reactiveTest!.rTime,
                                    median: test!.reactiveTest!.mTime,
                                    tID: test!.tID,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReactiveTestPage(
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
                          },
                          title: const Text(
                            'Reactive',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.reactiveTest == null
                              ? Icons.add_circle
                              : Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          onTap: () {
                            // check if dynamic exists
                            if (test!.dynamicTest != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DynamicResultsPage(
                                    t1Duration: test!.dynamicTest!.t1Duration,
                                    t1TurnSpeed: test!.dynamicTest!.t1TurnSpeed,
                                    t1MLSway: test!.dynamicTest!.t1MLSway,
                                    t2Duration: test!.dynamicTest!.t2Duration,
                                    t2TurnSpeed: test!.dynamicTest!.t2TurnSpeed,
                                    t2MLSway: test!.dynamicTest!.t2MLSway,
                                    t3Duration: test!.dynamicTest!.t3Duration,
                                    t3TurnSpeed: test!.dynamicTest!.t3TurnSpeed,
                                    t3MLSway: test!.dynamicTest!.t3MLSway,
                                    dMax: test!.dynamicTest!.dMax,
                                    dMin: test!.dynamicTest!.dMin,
                                    dMean: test!.dynamicTest!.dMean,
                                    dMedian: test!.dynamicTest!.dMedian,
                                    tsMax: test!.dynamicTest!.tsMax,
                                    tsMin: test!.dynamicTest!.tsMin,
                                    tsMean: test!.dynamicTest!.tsMean,
                                    tsMedian: test!.dynamicTest!.tsMedian,
                                    mlMax: test!.dynamicTest!.mlMax,
                                    mlMin: test!.dynamicTest!.mlMin,
                                    mlMean: test!.dynamicTest!.mlMean,
                                    mlMedian: test!.dynamicTest!.mlMedian,
                                    tID: widget.tID,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DynamicTestPage(
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
                          },
                          title: const Text(
                            'Dynamic',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.dynamicTest == null
                              ? Icons.add_circle
                              : Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          onTap: () {
                            // check if static exists
                            if (test!.staticTest != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StaticResultsPage(
                                    tID: widget.tID,
                                    tlSolidML: test!.staticTest!.tlSolidML,
                                    tlFoamML: test!.staticTest!.tlFoamML,
                                    slSolidML: test!.staticTest!.slSolidML,
                                    slFoamML: test!.staticTest!.slSolidML,
                                    tandSolidML: test!.staticTest!.tandSolidML,
                                    tandFoamML: test!.staticTest!.tandFoamML,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StaticTestPage(
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
                          },
                          title: const Text(
                            'Static',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(test!.staticTest == null
                              ? Icons.add_circle
                              : Icons.arrow_forward_ios),
                        ),
                      ]),
                    ),
                  ],
                ),
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
