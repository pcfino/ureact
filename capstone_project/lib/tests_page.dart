// import 'package:capstone_project/main.dart';
import 'package:capstone_project/dynamic_test_page.dart';
import 'package:capstone_project/start_test_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/test.dart';
import 'package:capstone_project/models/reactive.dart';
import 'package:capstone_project/static_test_page.dart';
import 'package:capstone_project/test_results_page.dart';
import 'package:capstone_project/incident_page.dart';
import 'package:flutter/material.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key, required this.tID});

  final int tID;

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  Future<dynamic> getTest(int tID) async {
    try {
      var jsonTest = await get(tID);
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTest(widget.tID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Test test = snapshot.data! as Test;

          selectedValue = test.tName;
          _date.text = test.tDate;
          notes.text = test.tNotes!;

          return MaterialApp(
            title: 'Tests',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('Tests'),
                centerTitle: true,
                leading: BackButton(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IncidentPage(iID: test.iID),
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
                            if (test.reactive != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TestResultsPage(
                                    backward: test.reactive!.bTime.toString(),
                                    forward: test.reactive!.fTime.toString(),
                                    left: test.reactive!.lTime.toString(),
                                    right: test.reactive!.rTime.toString(),
                                    median: test.reactive!.mTime.toString(),
                                    tID: test.tID,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StartTestPage(
                                    title: 'Reactive',
                                    direction: 'Forward',
                                    forward: "0",
                                    left: "0",
                                    right: "0",
                                    backward: "0",
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
                          trailing: Icon(test.reactive == null
                              ? Icons.add_circle
                              : Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          onTap: () {
                            // check if dynamic exists
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DynamicTestPage(
                                  tID: widget.tID,
                                  start: true,
                                  trialNumber: 1,
                                  trialOne: '0',
                                  trialTwo: '0',
                                  trialThree: '0',
                                ),
                              ),
                            );
                          },
                          title: const Text(
                            'Dynamic',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(Icons.add_circle),
                        ),
                        ListTile(
                          onTap: () {
                            // check if static exists
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StaticTestPage(
                                  tID: widget.tID,
                                  start: true,
                                  stance: "Double Leg Stance",
                                  doubleLeg: '0',
                                  tandem: '0',
                                  singleLeg: '0',
                                  nonDominantFoot: '',
                                ),
                              ),
                            );
                          },
                          title: const Text(
                            'Static',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(Icons.add_circle),
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
