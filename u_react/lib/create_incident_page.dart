import 'package:u_react/incident_page.dart';
import 'package:u_react/patient_page.dart';
import 'package:u_react/slide_right_transition.dart';
import 'package:flutter/material.dart';
import 'package:u_react/models/incident.dart';
import 'package:u_react/api/incident_api.dart';

class CreateIncidentPage extends StatefulWidget {
  const CreateIncidentPage({super.key, required this.pID});
  final int pID;

  @override
  State<CreateIncidentPage> createState() => _CreateIncidentPage();
}

class _CreateIncidentPage extends State<CreateIncidentPage> {
  final TextEditingController _date = TextEditingController();
  final TextEditingController _notes = TextEditingController(text: "");
  late Incident incident;
  String selectedValue = "Concussion";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Baseline", child: Text("Baseline")),
      const DropdownMenuItem(value: "Concussion", child: Text("Concussion")),
    ];
    return menuItems;
  }

  Future<dynamic> createIncident() async {
    try {
      dynamic jsonIncident = await create({
        "iName": selectedValue,
        "iDate": _date.text,
        "iNotes": _notes.text,
        "pID": widget.pID,
      });
      incident = Incident.fromJson(jsonIncident);
      return incident;
    } catch (e) {
      print("Error fetching creating incident: $e");
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Incident',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Incident'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: PatientPage(pID: widget.pID),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (_date.text == "") {
                  throwError();
                } else {
                  // Call createIncident and wait for it to complete
                  Incident? createdIncident = await createIncident();
                  if (createdIncident != null && context.mounted) {
                    // Navigate to IncidentPage only if incident is successfully created
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            IncidentPage(iID: createdIncident.iID),
                      ),
                    );
                  }
                }
              },
              child: const Text("Save"),
            )
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
                margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: DropdownButtonFormField(
                  disabledHint: Text(selectedValue),
                  value: selectedValue,
                  items: dropdownItems,
                  onChanged: (String? value) {
                    setState(() {
                      selectedValue = value!;
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
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Notes",
                  ),
                  controller: _notes,
                  onSubmitted: (value) {
                    _notes.text = value;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
