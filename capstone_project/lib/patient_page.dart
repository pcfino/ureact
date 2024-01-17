import 'package:flutter/material.dart';
import 'package:capstone_project/incident_page.dart';

class PatientPage extends StatelessWidget {
  const PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black,
                        size: 100.0,
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Abby Smith'),
                          Text('DOB: 10/26/1995'),
                          Text('Sport: Soccer'),
                          Text('3rd Party ID: 1234567')
                        ],
                      ),
                    ),
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          'Ht: 5\' 7"',
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          'Wt: 165 lbs',
                          textAlign: TextAlign.center,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          'Gender: F',
                          textAlign: TextAlign.center,
                        )),
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
