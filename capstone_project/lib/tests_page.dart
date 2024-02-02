// import 'package:capstone_project/main.dart';
import 'package:capstone_project/start_test_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/test.dart';
import 'package:capstone_project/models/reactive.dart';
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
      print("Error fetching patients: $e");
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Day of", child: Text("Day of")),
      const DropdownMenuItem(value: "Pre Return", child: Text("Pre Return")),
      const DropdownMenuItem(value: "Other", child: Text("Other")),
      const DropdownMenuItem(value: "Other 2", child: Text("Other 2")),
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
                  Navigator.pop(context);
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
                    if (test.reactive != null)
                      ExpansionTile(
                        title: const Text(
                          'Reactive',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          reactiveTile
                              ? Icons.arrow_drop_down_circle
                              : Icons.arrow_drop_down_circle,
                        ),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            reactiveTile = expanded;
                          });
                        },
                        children: [
                          ListTile(
                            title: const Text('Average',
                                style: TextStyle(fontSize: 16)),
                            trailing: Text(test.reactive!.mTime.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ListTile(
                            title: const Text('Forward',
                                style: TextStyle(fontSize: 16)),
                            trailing: Text(test.reactive!.fTime.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ListTile(
                            title: const Text('Right',
                                style: TextStyle(fontSize: 16)),
                            trailing: Text(test.reactive!.rTime.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ListTile(
                            title: const Text('Left',
                                style: TextStyle(fontSize: 16)),
                            trailing: Text(test.reactive!.lTime.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ListTile(
                            title: const Text('Backward',
                                style: TextStyle(fontSize: 16)),
                            trailing: Text(test.reactive!.bTime.toString(),
                                style: const TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    if (test.reactive == null)
                      ExpansionTile(
                        title: const Text(
                          'Reactive',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(Icons.play_arrow_rounded),
                        onExpansionChanged: (bool? value) {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StartTestPage(
                                  title: 'Reactive',
                                  direction: 'Forward',
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    ExpansionTile(
                      title: const Text(
                        'Dynamic',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.play_arrow_rounded),
                      onExpansionChanged: (bool? value) {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartTestPage(
                                title: 'Dynamic',
                                direction: 'Forward',
                              ),
                            ),
                          );
                        });
                      },
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Static',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.play_arrow_rounded),
                      onExpansionChanged: (bool? value) {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StartTestPage(
                                title: 'Static',
                                direction: 'Forward',
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ],
                ),
              ),
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
