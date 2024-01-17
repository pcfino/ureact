import 'package:capstone_project/patient_model.dart';
import 'package:capstone_project/patient_page.dart';
import 'package:capstone_project/new_patient_page.dart';
import 'package:capstone_project/settings_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  static List<PatientModel> patientList = [
    PatientModel("Abby", "Smith"),
    PatientModel("Alex", "Johnson"),
    PatientModel("Alfred", "Hitchcock"),
    PatientModel("Amy", "Winehouse"),
    PatientModel("Arnold", "Schwarzenegger"),
    PatientModel("Brant", "Kuithe"),
    PatientModel("Bob", "Thebuilder"),
    PatientModel("Bobby", "Newport"),
    PatientModel("Brett", "Favre"),
    PatientModel("Bill", "Gates"),
    PatientModel("Cam", "Hoefer"),
    PatientModel("Charlie", "Crockett"),
    PatientModel("Carson", "Wells"),
    PatientModel("Chris", "Jones"),
    PatientModel("Carson", "Palmer"),
    PatientModel("Josh", "Allen"),
    PatientModel("JJ", "Abrams"),
    PatientModel("Ron", "Burgundy"),
  ];

  List<PatientModel> displayPatientList = List.from(patientList);
  void alphabetize() {
    displayPatientList.sort((a, b) => a.lastName!.compareTo(b.lastName!));
  }

  void updateList(String value) {
    setState(() {
      displayPatientList = patientList
          .where((element) =>
              element.lastName!.toLowerCase().contains(value.toLowerCase()) ||
              element.firstName!.toLowerCase().contains(value.toLowerCase()) ||
              ("${element.firstName!} ${element.lastName!}")
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              ("${element.lastName!}, ${element.firstName!}")
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
    });
  }

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    alphabetize();
    return MaterialApp(
      title: 'Patients',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patients'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            TextField(
              onChanged: (value) => updateList(value),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: Colors.red,
                constraints: const BoxConstraints(
                  maxHeight: 40,
                ),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
            ),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: displayPatientList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Card(
                        margin: const EdgeInsets.all(0),
                        elevation: 0,
                        color: Colors.white10,
                        shape: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${displayPatientList[index].lastName!}, ${displayPatientList[index].firstName!}",
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PatientPage(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientPage(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: () {}, child: const Text('Export List')),
              ],
            )),
      ),
    );
  }
}
