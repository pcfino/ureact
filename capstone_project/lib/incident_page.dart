import 'package:flutter/material.dart';
import 'package:capstone_project/start_test_page.dart';
import 'package:capstone_project/test_results_page.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/incident.dart';
import 'package:capstone_project/api/incident_api.dart';

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key, required this.iID});
  final int iID;

  @override
  State<IncidentPage> createState() => _IncidentPage();
}

class _IncidentPage extends State<IncidentPage> {
  late Incident incident;
  final TextEditingController _date = TextEditingController();

  bool editMode = false;
  String mode = 'Edit';

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: "Return To Play", child: Text("Return To Play")),
      const DropdownMenuItem(value: "Concussion", child: Text("Concussion")),
      const DropdownMenuItem(value: "Check Up", child: Text("Check Up")),
    ];
    return menuItems;
  }

  Future<dynamic> getIncident(int iID) async {
    try {
      dynamic jsonIncident = await get(iID);
      incident = Incident.fromJson(jsonIncident);
      return incident;
    } catch (e) {
      print("Error fetching incidents: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (editMode) {
      _date.text = incident.iDate;
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
              Navigator.pop(context);
            }),
            actions: <Widget>[
              if (editMode)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                  ),
                  onPressed: () {
                    // delete
                  },
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (editMode) {
                      editMode = false;
                      mode = 'Edit';
                    } else if (!editMode) {
                      editMode = true;
                      mode = 'Save';
                    }

                    update(incident.iID, {
                      incident.iName,
                      incident.iDate,
                      incident.iNotes,
                      incident.pID
                    });
                  });
                },
                child: Text(mode),
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
                    onChanged: editMode
                        ? (String? value) {
                            setState(() {
                              selectedValue = value!;
                              incident.iName = selectedValue;
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
                      labelText: "Type *",
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
                            incident.iDate = selectedDate.toString();
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
                    controller: TextEditingController(text: incident.iNotes
                        // "Abby was hit in the head by another player while playing a soccer game and experienced a concussion.",
                        ),
                    onSubmitted: (value) {
                      incident.iNotes = value;
                    },
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
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: const Text('May 5, 2023'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TestsPage(
                                    reactive: true,
                                    dynamic: true,
                                    static: true),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('May 3, 2023'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TestsPage(
                                    reactive: true,
                                    dynamic: true,
                                    static: true),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text('April 30, 2023'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TestsPage(
                                    reactive: true,
                                    dynamic: true,
                                    static: true),
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
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TestsPage(
                      reactive: false, dynamic: false, static: false),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endContained,
        ),
      );
    } else {
      return FutureBuilder(
          future: getIncident(widget.iID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // or any other loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Incident incident = snapshot.data!;
              _date.text = incident.iDate;
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
                      Navigator.pop(context);
                    }),
                    actions: <Widget>[
                      if (editMode)
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                          onPressed: () {
                            // delete
                          },
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (editMode) {
                              editMode = false;
                              mode = 'Edit';
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
                            onChanged: editMode
                                ? (String? value) {
                                    setState(() {
                                      selectedValue = value!;
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
                              labelText: "Type *",
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
                            controller: TextEditingController(
                                text: incident.iNotes
                                // "Abby was hit in the head by another player while playing a soccer game and experienced a concussion.",
                                ),
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
                          child: ListView(
                            children: ListTile.divideTiles(
                              context: context,
                              tiles: [
                                ListTile(
                                  title: const Text('May 5, 2023'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TestsPage(
                                            reactive: true,
                                            dynamic: true,
                                            static: true),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text('May 3, 2023'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TestsPage(
                                            reactive: true,
                                            dynamic: true,
                                            static: true),
                                      ),
                                    );
                                  },
                                ),
                                ListTile(
                                  title: const Text('April 30, 2023'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TestsPage(
                                            reactive: true,
                                            dynamic: true,
                                            static: true),
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
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TestsPage(
                              reactive: false, dynamic: false, static: false),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endContained,
                ),
              );
            }
          });
    }
    // return MaterialApp(
    //   title: 'Incident',
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
    //     useMaterial3: true,
    //   ),
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Incident'),
    //       centerTitle: true,
    //       leading: BackButton(onPressed: () {
    //         Navigator.pop(context);
    //       }),
    //       actions: <Widget>[
    //         if (editMode)
    //           IconButton(
    //             icon: const Icon(
    //               Icons.delete_outline,
    //             ),
    //             onPressed: () {
    //               // delete
    //             },
    //           ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               if (editMode) {
    //                 editMode = false;
    //                 mode = 'Edit';
    //               } else if (!editMode) {
    //                 editMode = true;
    //                 mode = 'Save';
    //               }
    //             });
    //           },
    //           child: Text(mode),
    //         )
    //       ],
    //     ),
    //     body: Padding(
    //       padding: const EdgeInsets.all(16),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           Container(
    //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    //             child: DropdownButtonFormField(
    //               disabledHint: Text(selectedValue),
    //               value: selectedValue,
    //               items: dropdownItems,
    //               onChanged: editMode
    //                   ? (String? value) {
    //                       setState(() {
    //                         selectedValue = value!;
    //                       });
    //                     }
    //                   : null,
    //               style: const TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.black,
    //               ),
    //               decoration: const InputDecoration(
    //                 border: OutlineInputBorder(
    //                   borderSide: BorderSide.none,
    //                 ),
    //                 labelText: "Type *",
    //                 contentPadding: EdgeInsets.all(11),
    //               ),
    //             ),
    //           ),
    //           Container(
    //             margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
    //             child: TextField(
    //               readOnly: !editMode,
    //               decoration: const InputDecoration(
    //                 border: OutlineInputBorder(
    //                   borderSide: BorderSide.none,
    //                 ),
    //                 labelText: "Date *",
    //                 contentPadding: EdgeInsets.all(11),
    //               ),
    //               controller: _date,
    //               onTap: () async {
    //                 if (editMode) {
    //                   DateTime? selectedDate = await showDatePicker(
    //                     context: context,
    //                     initialDate: DateTime.now(),
    //                     firstDate: DateTime(2000),
    //                     lastDate: DateTime.now(),
    //                   );
    //                   if (selectedDate != null) {
    //                     setState(() {
    //                       _date.text =
    //                           "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
    //                     });
    //                   }
    //                 }
    //               },
    //             ),
    //           ),
    //           Container(
    //             margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
    //             child: TextField(
    //               readOnly: !editMode,
    //               maxLines: null,
    //               decoration: const InputDecoration(
    //                 border: OutlineInputBorder(),
    //                 labelText: "Notes",
    //               ),
    //               controller: TextEditingController(text: incident.iNotes
    //                   // "Abby was hit in the head by another player while playing a soccer game and experienced a concussion.",
    //                   ),
    //             ),
    //           ),
    //           Container(
    //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
    //             child: const Text(
    //               'Tests',
    //               style: TextStyle(
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //               ),
    //             ),
    //           ),
    //           const Divider(
    //             height: 1,
    //             thickness: 1,
    //             color: Colors.grey,
    //           ),
    //           Expanded(
    //             child: ListView(
    //               children: ListTile.divideTiles(
    //                 context: context,
    //                 tiles: [
    //                   ListTile(
    //                     title: const Text('May 5, 2023'),
    //                     onTap: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => const TestsPage(
    //                               reactive: true, dynamic: true, static: true),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                   ListTile(
    //                     title: const Text('May 3, 2023'),
    //                     onTap: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => const TestsPage(
    //                               reactive: true, dynamic: true, static: true),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                   ListTile(
    //                     title: const Text('April 30, 2023'),
    //                     onTap: () {
    //                       Navigator.push(
    //                         context,
    //                         MaterialPageRoute(
    //                           builder: (context) => const TestsPage(
    //                               reactive: true, dynamic: true, static: true),
    //                         ),
    //                       );
    //                     },
    //                   ),
    //                 ],
    //               ).toList(),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     floatingActionButton: FloatingActionButton(
    //       onPressed: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => const TestsPage(
    //                 reactive: false, dynamic: false, static: false),
    //           ),
    //         );
    //       },
    //       child: const Icon(Icons.add),
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    //   ),
    // );
  }
}
