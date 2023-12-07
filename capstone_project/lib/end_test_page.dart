import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:capstone_project/test_results_page.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'accelerometer_data.dart';
import 'gyroscope_data.dart';
import 'dart:async';
import 'package:http/http.dart';

class EndTestPage extends StatefulWidget {
  const EndTestPage({super.key, required this.title});

  final String title;

  @override
  State<EndTestPage> createState() => _EndTestPageState();
}

// ignore: non_constant_identifier_names
String IOS_URL = 'http://127.0.0.1:5000/';
// ignore: non_constant_identifier_names
String ANDROID_URL = 'http://10.0.2.2:5000/';
// ignore: non_constant_identifier_names
String VERSION_URL = ANDROID_URL;
// these methods send/issue get and post requests to the python server
Future getData(url) async {
  // ignore: non_constant_identifier_names
  var TTS = Uri.parse(url);
  Response response = await get(TTS);
  return response.body;
}

Future sendData(int newNum) async {
  final response = await post(
    // ignore: prefer_interpolation_to_compose_strings
    Uri.parse(VERSION_URL + 'mysql/setResults'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'TTS': newNum}),
  );
  return response.body;
}

class _EndTestPageState extends State<EndTestPage> {
  // List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  // List<double>? _gyroscopeValues;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  final List<AccelerometerData> _accelerometerData = [];
  final List<GyroscopeData> _gyroscopeData = [];

  var timeToStab = "";
  //var increment = 2;
  Future getTTS() async {
    //increment++;
    //await sendData(increment);
    // ignore: prefer_interpolation_to_compose_strings
    var data = await getData(VERSION_URL + 'mysql/getResults');
    var decodedData = jsonDecode(data);
    setState(() {
      timeToStab = decodedData['TTS'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final accelerometer =
    //     _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    // final gyroscope =
    //     _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
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
                      onPressed: () async {
                        await getTTS();
                        _accelerometerData.clear();
                        _gyroscopeData.clear();
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TestResultsPage(
                              accelData: userAccelerometer,
                              timeToStab: timeToStab,
                            ),
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

    // _streamSubscriptions.add(
    //   accelerometerEvents.listen(
    //     (AccelerometerEvent event) {
    //       setState(() {
    //         _accelerometerValues = <double>[event.x, event.y, event.z];
    //       });
    //     },
    //   ),
    // );
    // _streamSubscriptions.add(
    //   gyroscopeEvents.listen(
    //     (GyroscopeEvent event) {
    //       setState(() {
    //         _gyroscopeValues = <double>[event.x, event.y, event.z];
    //       });
    //     },
    //   ),
    // );
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
