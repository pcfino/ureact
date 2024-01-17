import 'package:flutter/material.dart';
import 'package:capstone_project/incident_page.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({super.key});

  @override
  State<PatientPage> createState() => _PatientPage();
}

class _PatientPage extends State<PatientPage> {
  final TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _date.text = "10/26/1995";
    return MaterialApp(
      title: 'Patient',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patient'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
          actions: <Widget>[
            TextButton(onPressed: () {}, child: const Text('Save'))
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      labelText: "Name",
                      contentPadding: EdgeInsets.all(11),
                    ),
                    controller: TextEditingController(
                      text: "Abby Smith",
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "DOB",
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
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Sport",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: TextEditingController(
                          text: "Soccer",
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Height",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: TextEditingController(
                          text: "5' 7\"",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Weight",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: TextEditingController(
                          text: "165 lbs",
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "Gender",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: TextEditingController(
                          text: "F",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          labelText: "3rd Party ID",
                          contentPadding: EdgeInsets.all(11),
                        ),
                        controller: TextEditingController(
                          text: "1234567",
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('Incidents',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                Expanded(
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: const Text('Return To Play'),
                          subtitle: const Text('May 3, 2023'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Concussion'),
                          subtitle: const Text('Feb 16, 2023'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Check Up'),
                          subtitle: const Text('Dec 13, 2022'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Check Up'),
                          subtitle: const Text('Aug 14, 2022'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Return To Play'),
                          subtitle: const Text('May 20, 2022'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Concussion'),
                          subtitle: const Text('Feb 25, 2022'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('Check Up'),
                          subtitle: const Text('Jan 10, 2022'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IncidentPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ).toList(),
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
                builder: (context) => const IncidentPage(),
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
                TextButton(onPressed: () {}, child: const Text('Export Data')),
              ],
            )),
      ),
    );
  }
}
