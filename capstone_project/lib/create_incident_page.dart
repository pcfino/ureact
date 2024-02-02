import 'package:capstone_project/incident_page.dart';
import 'package:capstone_project/patient_page.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/models/incident.dart';
import 'package:capstone_project/api/incident_api.dart';

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
      const DropdownMenuItem(
          value: "Return To Play", child: Text("Return To Play")),
      const DropdownMenuItem(value: "Concussion", child: Text("Concussion")),
      const DropdownMenuItem(value: "Check Up", child: Text("Check Up")),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PatientPage(pID: widget.pID),
              ),
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Call createIncident and wait for it to complete
                Incident? createdIncident = await createIncident();
                if (createdIncident != null && context.mounted) {
                  // Navigate to IncidentPage only if incident is successfully created
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IncidentPage(iID: createdIncident.iID),
                    ),
                  );
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
