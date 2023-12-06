import 'package:flutter/material.dart';
import 'package:capstone_project/end_test_page.dart';

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