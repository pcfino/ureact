import 'package:capstone_project/create_incident_page.dart';
import 'package:capstone_project/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/incident_page.dart';
import 'package:capstone_project/models/patient.dart';
import 'package:capstone_project/models/incident.dart';
import 'package:capstone_project/api/patient_api.dart';
import 'package:capstone_project/slide_right_transition.dart';
import 'package:capstone_project/export_data.dart';

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
                              exportPatientData(patient!.pID);
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
