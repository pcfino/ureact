import 'package:capstone_project/create_patient_page.dart';
import 'package:capstone_project/models/patient.dart';
import 'package:capstone_project/patient_page.dart';
import 'package:capstone_project/settings_page.dart';
import 'package:capstone_project/api/patient_api.dart';
import 'package:flutter/material.dart';

import 'package:azlistview/azlistview.dart';

class AzItem extends ISuspensionBean {
  final String name;
  final String tag;

  AzItem({required this.name, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Future<dynamic> getPatients() async {
    try {
      List<dynamic> jsonPatientList = await getAll() as List;
      List<Patient> patientList = List<Patient>.from(
          jsonPatientList.map((model) => Patient.fromJson(model)));

      patientList = List.from(patientList);
      patientList.sort((a, b) =>
          a.lastName.toLowerCase().compareTo(b.lastName.toLowerCase()));
      return patientList;
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  List<Patient> updateList(List<Patient> list, [String? value]) {
    if (value == null) return list;
    return list
        .where((element) =>
            element.lastName.toLowerCase().contains(value.toLowerCase()) ||
            element.firstName.toLowerCase().contains(value.toLowerCase()) ||
            ("${element.firstName} ${element.lastName}")
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            ("${element.lastName}, ${element.firstName}")
                .toLowerCase()
                .contains(value.toLowerCase()))
        .toList();
  }

  final ScrollController scrollController = ScrollController();
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPatients(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          List<Patient> patients = snapshot.data!;

          return MaterialApp(
            title: 'Patients',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              useMaterial3: true,
            ),
            home: Scaffold(
              resizeToAvoidBottomInset: false,
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
                  Expanded(
                    flex: 1,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: search,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: Colors.red,
                        suffixIcon: search.text != ""
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                ),
                                onPressed: () {
                                  search.text = "";
                                  updateList(patients);
                                  setState(() {});
                                },
                              )
                            : null,
                        constraints: const BoxConstraints(
                          maxHeight: 40,
                        ),
                        fillColor: const Color.fromARGB(255, 240, 240, 240),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 10,
                      child: AzListView(
                        data: updateList(patients, search.text)
                            .map((e) => AzItem(
                                name: "${e.lastName}, ${e.firstName}",
                                tag: e.firstName[0].toUpperCase()))
                            .toList(),
                        itemCount: updateList(patients, search.text).length,
                        itemBuilder: (BuildContext context, int index) {
                          final patientName =
                              updateList(patients, search.text)[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                    "${patientName.lastName}, ${patientName.firstName}"),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PatientPage(pID: patientName.pID),
                                    ),
                                  );
                                },
                              ),
                              if (index !=
                                  updateList(patients, search.text).length - 1)
                                const Divider(
                                  color: Colors.grey,
                                  height: 1,
                                  thickness: 0.5,
                                  endIndent: 30,
                                )
                            ],
                          );
                        },
                      )
                      // ListView.separated(
                      //   controller: scrollController,
                      //   //padding: const EdgeInsets.all(8.0),
                      //   itemCount: updateList(patients, search.text).length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return ListTile(
                      //       title: Text(
                      //           "${updateList(patients, search.text)[index].lastName}, ${updateList(patients, search.text)[index].firstName}"),
                      //       //subtitle: Text(incidents[index].iDate),
                      //       onTap: () {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => PatientPage(
                      //                 pID:
                      //                     updateList(patients, search.text)[index]
                      //                         .pID),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   separatorBuilder: (context, index) {
                      //     return const Divider();
                      //   },
                      // ),
                      ),
                ]),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePatientPage(),
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
                          onPressed: () {}, child: const Text('Export List')),
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
