import 'package:u_react/export_data.dart';
import 'package:u_react/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:u_react/create_test_page.dart';
import 'package:u_react/tests_page.dart';
import 'package:u_react/models/incident.dart';
import 'package:u_react/api/incident_api.dart';
import 'package:u_react/slide_right_transition.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key, this.iID = -1, required this.thirdPartyID});
  final int iID;
  final String? thirdPartyID;

  @override
  State<IncidentPage> createState() => _IncidentPage();
}

/// Displays all of the incident data given the iID
class _IncidentPage extends State<IncidentPage> {
  Incident? incident;
  final TextEditingController _date = TextEditingController();
  final TextEditingController _notes = TextEditingController();

  bool editMode = false;
  String mode = 'Edit';

  /// Set dropdown items as either Baseline or Concussion.
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Baseline", child: Text("Baseline")),
      const DropdownMenuItem(value: "Concussion", child: Text("Concussion")),
    ];
    return menuItems;
  }

  /// Get the incident data given the iID.
  Future<dynamic> getIncident(int iID) async {
    try {
      dynamic jsonIncident = await get(iID);
      Incident incident = Incident.fromJson(jsonIncident[0]);
      return incident;
    } catch (e) {
      print("Error fetching incidents: $e");
    }
  }

  /// Update the incident with the given incident map.
  Future<dynamic> updateIncident(
      int iID, Map<String, dynamic> saveIncident) async {
    try {
      await update(iID, saveIncident);
    } catch (e) {
      print("Error updating incident: $e");
    }
  }

  /// Throw error in case of invalid data.
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

  Widget incidentPageContent(context, Incident incident) {
    _date.text = incident.iDate.toString();
    _notes.text = incident.iNotes!;
    String selectedValue = incident.iName;
    return MaterialApp(
      title: 'Incident',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Incident'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: PatientPage(
                  pID: incident.pID,
                ),
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
                  delete(incident.iID);
                  Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                      page: PatientPage(pID: incident.pID),
                    ),
                  );
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
                  if (_date.text == "") {
                    throwError();
                  } else {
                    editMode = false;

                    var saveIncident = {
                      "iName": selectedValue,
                      "iDate": _date.text,
                      "iNotes": _notes.text,
                      "pID": incident.pID
                    };
                    setState(() {
                      mode = 'Edit';
                      updateIncident(incident.iID, saveIncident);
                    });
                  }
                }
              },
              child: Text(mode),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                      incident.iName,
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
              TextField(
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
                            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        if (editMode) {
                          incident.iDate =
                              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                        }
                      });
                    }
                  }
                },
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
                  controller: _notes,
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: const Text(
                  'Tests',
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
                child: ListView.builder(
                  itemCount: incident.tests!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(incident.tests![index].tName),
                      subtitle: Text(incident.tests![index].tDate),
                      // The start indicates this is the most recent baseline and the one that will be used
                      trailing: index == 0 && incident.iName == "Baseline"
                          ? const Icon(Icons.star_border)
                          : null,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestsPage(
                              tID: incident.tests![index].tID,
                              pID: incident.pID,
                              thirdPartyID: widget.thirdPartyID,
                            ),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTestPage(
                  iID: widget.iID,
                  pID: incident.pID,
                  name: incident.iName,
                  thirdPartyID: widget.thirdPartyID,
                ),
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
                TextButton(
                    onPressed: () {
                      exportIncident(incident.pID, incident.iID);
                    },
                    child: const Text('Export Data')),
              ],
            )),
      ),
    );
  }

  late Future<dynamic> future;
  @override
  void initState() {
    super.initState();
    future = getIncident(widget.iID);
  }

  @override
  Widget build(context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (incident == null) {
              incident = snapshot.data! as Incident;
              incident?.tests?.sort((a, b) => b.tDate.compareTo(a.tDate));
            }
            return incidentPageContent(context, incident!);
          }
        });
    //}
  }
}
