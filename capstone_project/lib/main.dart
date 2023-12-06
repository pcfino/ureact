import 'dart:convert';
import 'package:capstone_project/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'package:sensors_plus/sensors_plus.dart';
import 'accelerometer_data.dart';
import 'gyroscope_data.dart';

import 'dart:async';

// *******************************************************************************************
// START
// ignore: non_constant_identifier_names
String IOS_URL = 'http://127.0.0.1:8000/';
// ignore: non_constant_identifier_names
String ANDROID_URL = 'http://10.0.2.2:5000/';
// ignore: non_constant_identifier_names
String VERSION_URL = IOS_URL;

// these methods send/issue get and post requests to the python server
Future getData(url) async {
  var url2 = Uri.parse(url);
  Response response = await get(url2);
  return response.body;
}

Future sendData(int newNum) async {
  final response = await post(
    // ignore: prefer_interpolation_to_compose_strings
    Uri.parse(VERSION_URL + 'postData'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'counter': newNum}),
  );

  return response.body;
}
// END
// *******************************************************************************************

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
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
                // do something
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
          // backgroundColor: const Color(0xff03dac6),
          // foregroundColor: Colors.black,
          onPressed: () {
            // Respond to button press
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
                  color: Colors.black,
                ),
                Expanded(
                  child: ListView(
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        ListTile(
                          title: const Text('Soccer' + ' - ' + '05/03/2023'),
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
                          title: const Text('Other' + ' - ' + '08/16/2022'),
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
                          title: const Text('Soccer' + ' - ' + '06/15/2021'),
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
                          title: const Text('Soccer' + ' - ' + '04/29/2021'),
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
                          title: const Text('Soccer' + ' - ' + '04/12/2021'),
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
                          title: const Text('Other' + ' - ' + '12/20/2020'),
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
                          title: const Text('Soccer' + ' - ' + '11/14/2020'),
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
                          title: const Text('Soccer' + ' - ' + '10/12/2020'),
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
                          title: const Text('Basketball' + ' - ' + '9/12/2020'),
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
        bottomNavigationBar: BottomAppBar(
            surfaceTintColor: Colors.white,
            shadowColor: Colors.black,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () {},
                        child: const Text('Create New Incident')),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {}, child: const Text('Export Data')),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

class IncidentPage extends StatefulWidget {
  const IncidentPage({super.key});

  @override
  State<IncidentPage> createState() => _IncidentPage();
}

class _IncidentPage extends State<IncidentPage> {
  TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _date.text = "2023/5/3";
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 80,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        text: "Soccer",
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        labelText: "Date",
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
                      controller: TextEditingController(
                        text:
                            "Abby was hit in the head by another player while playing a soccer game and experienced a concussion.",
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: const Text(
                      'Tests',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: const EdgeInsets.all(0),
                        elevation: 0,
                        color: Colors.white10,
                        shape: const Border(
                          top: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "2023/${index * 2}/$index",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const StartTestPage(title: 'Reactive Test'),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      ),
    );
  }
}

// class RunTestPage extends StatefulWidget {
//   const RunTestPage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<RunTestPage> createState() => _RunTestPageState();
// }

// class _RunTestPageState extends State<RunTestPage> {
//   List<double>? _accelerometerValues;
//   List<double>? _userAccelerometerValues;
//   List<double>? _gyroscopeValues;

//   final _streamSubscriptions = <StreamSubscription<dynamic>>[];

//   final List<AccelerometerData> _accelerometerData = [];
//   final List<GyroscopeData> _gyroscopeData = [];

//   // *******************************************************************************************
//   // START
//   String result = "0";
//   int startUp = 0;

//   void sendANumber() async {
//     await sendData(49);
//     // ignore: prefer_interpolation_to_compose_strings
//     var data = await getData(VERSION_URL + 'current');
//     var decodedData = jsonDecode(data);
//     setState(() {
//       result = decodedData['counter'].toString();
//     });
//   }

//   void onLoadApp() async {
//     var data = await getData(VERSION_URL);
//     var decodedData = jsonDecode(data);
//     setState(() {
//       result = decodedData['counter'].toString();
//     });
//   }

//   void _incrementCounter() async {
//     // ignore: prefer_interpolation_to_compose_strings
//     var data = await getData(VERSION_URL + 'incre');
//     var decodedData = jsonDecode(data);
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       result = decodedData['counter'].toString();
//     });
//   }

//   void _resetToZero() async {
//     // ignore: prefer_interpolation_to_compose_strings
//     var data = await getData(VERSION_URL + 'zero');
//     var decodedData = jsonDecode(data);
//     setState(() {
//       result = decodedData['counter'].toString();
//     });
//   }
//   // END
//   // *******************************************************************************************

//   @override
//   Widget build(BuildContext context) {
//     final accelerometer =
//         _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
//     final gyroscope =
//         _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
//     final userAccelerometer = _userAccelerometerValues
//         ?.map((double v) => v.toStringAsFixed(1))
//         .toList();
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     if (startUp == 0) {
//       onLoadApp();
//       startUp++;
//     }
//     return MaterialApp(
//       title: 'Requests',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
//         useMaterial3: true,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: true,
//           leading: BackButton(onPressed: () {
//             Navigator.pop(context);
//           }),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Text(
//                 'You have pushed the button this many times:',
//               ),
//               Text(
//                 result,
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     // start a stream that saves acceleroemeterData
//                     _streamSubscriptions.add(
//                         accelerometerEvents.listen((AccelerometerEvent event) {
//                       _accelerometerData.add(AccelerometerData(
//                           DateTime.now(), <double>[event.x, event.y, event.z]));
//                     }));
//                     // start a stream that saves gyroscopeData
//                     _streamSubscriptions
//                         .add(gyroscopeEvents.listen((GyroscopeEvent event) {
//                       _gyroscopeData.add(GyroscopeData(
//                           DateTime.now(), <double>[event.x, event.y, event.z]));
//                     }));
//                   },
//                   child: const Text("Start")),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => Scaffold(
//                         appBar: AppBar(
//                           title: const Text('Acceleromter Results'),
//                           centerTitle: true,
//                           leading: BackButton(onPressed: () {
//                             Navigator.pop(context);
//                           }),
//                         ),
//                         body: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               //This is where we would call the python functions
//                               Text("Accelerometer Data: $userAccelerometer"),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                   _accelerometerData.clear();
//                   _gyroscopeData.clear();
//                 },
//                 child: const Text("Stop"),
//               )
//             ],
//           ),
//         ),
//         floatingActionButton: Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             // *******************************************************************************************
//             // START
//             // here there are three buttons. When pressed, they call these methods
//             FloatingActionButton(
//               onPressed: _incrementCounter,
//               tooltip: 'Increment',
//               backgroundColor: Colors.purple,
//               foregroundColor: Colors.black,
//               child: const Icon(Icons.add),
//             ),
//             const SizedBox(width: 16.0),
//             FloatingActionButton(
//               onPressed: _resetToZero,
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//               child: const Icon(Icons.arrow_back_ios_new_outlined),
//             ),
//             FloatingActionButton(
//               onPressed: sendANumber,
//               backgroundColor: Colors.green,
//               foregroundColor: Colors.yellow,
//               child: const Icon(Icons.arrow_circle_right_outlined),
//             ),
//             // END
//             // *******************************************************************************************
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     for (final subscription in _streamSubscriptions) {
//       subscription.cancel();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

//     _streamSubscriptions.add(
//       accelerometerEvents.listen(
//         (AccelerometerEvent event) {
//           setState(() {
//             _accelerometerValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//     _streamSubscriptions.add(
//       gyroscopeEvents.listen(
//         (GyroscopeEvent event) {
//           setState(() {
//             _gyroscopeValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//     _streamSubscriptions.add(
//       userAccelerometerEvents.listen(
//         (UserAccelerometerEvent event) {
//           setState(() {
//             _userAccelerometerValues = <double>[event.x, event.y, event.z];
//           });
//         },
//       ),
//     );
//   }
// }

class StartTestPage extends StatefulWidget {
  const StartTestPage({super.key, required this.title});

  final String title;

  @override
  State<StartTestPage> createState() => _StartTestPageState();
}

class _StartTestPageState extends State<StartTestPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: widget.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            }),
          ),
          body: const Center(
              child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Directions',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Attach phone to belt',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('2. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Position phone over participant\'s lumbar spine',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('3. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Lean participant until you hear the chime',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('4. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Hold participant steady and release after 2-5 seconds',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('5. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Press the end test button once the participant has regained their balance',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
          bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EndTestPage(title: 'Reactive Test'),
                          ),
                        );
                      },
                      child: const Text('Start Test',
                          style: TextStyle(fontSize: 20))),
                ],
              )),
        ));
  }
}

class EndTestPage extends StatefulWidget {
  const EndTestPage({super.key, required this.title});

  final String title;

  @override
  State<EndTestPage> createState() => _EndTestPageState();
}

class _EndTestPageState extends State<EndTestPage> {
  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  final List<AccelerometerData> _accelerometerData = [];
  final List<GyroscopeData> _gyroscopeData = [];
  @override
  Widget build(BuildContext context) {
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    _streamSubscriptions
        .add(accelerometerEvents.listen((AccelerometerEvent event) {
      _accelerometerData.add(AccelerometerData(
          DateTime.now(), <double>[event.x, event.y, event.z]));
    }));
    // start a stream that saves gyroscopeData
    _streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
      _gyroscopeData.add(
          GyroscopeData(DateTime.now(), <double>[event.x, event.y, event.z]));
    }));
    return MaterialApp(
        title: widget.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            leading: BackButton(onPressed: () {
              Navigator.pop(context);
            }),
          ),
          body: const Center(
              child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Directions',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Attach phone to belt',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('2. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Position phone over participant\'s lumbar spine',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('3. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Lean participant until you hear the chime',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('4. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Hold participant steady and release after 2-5 seconds',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('5. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Press the end test button once the participant has regained their balance',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
          bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TestResultsPage(accelData: userAccelerometer),
                          ),
                        );
                      },
                      child: const Text('End Test',
                          style: TextStyle(fontSize: 20))),
                ],
              )),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});

    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }
}

class TestResultsPage extends StatefulWidget {
  const TestResultsPage({super.key, required this.accelData});

  final List<String>? accelData;

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test Results',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Test Results'),
              centerTitle: true,
              leading: BackButton(onPressed: () {
                Navigator.pop(context);
              }),
            ),
            body: Center(
              child: Text("Results: ${widget.accelData}"),
            )));
  }
}
