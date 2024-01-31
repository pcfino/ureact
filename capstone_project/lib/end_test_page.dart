import 'dart:convert';
// import 'dart:io';
import 'package:capstone_project/start_test_page.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/test_results_page.dart';
import 'package:capstone_project/tests_page.dart';
import 'sensor_recorder.dart';
import 'dart:async';
import 'api/api_util.dart' as api_util;

class EndTestPage extends StatefulWidget {
  const EndTestPage({super.key, required this.title, required this.direction});

  final String title;
  final String direction;

  @override
  State<EndTestPage> createState() => _EndTestPageState();
}

class _EndTestPageState extends State<EndTestPage> {
  late String timeToStab;
  late SensorRecorder sensorRecorder;

  Future getTTS() async {
    var sensorData = sensorRecorder.endRecording();

    var responseBody = await api_util.post('/timeToStability', {
      'dataAcc': sensorData.formattedAccData(),
      'dataRot': sensorData.formattedGyrData(),
      'timeStamps': sensorData.timeStamps,
      'fs': sensorData.fs
    });

    var decodedData = jsonDecode(responseBody);

    setState(() {
      timeToStab = decodedData['TTS'].toString();
    });
  }

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
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestsPage(
                            reactive: false, dynamic: false, static: false),
                      ),
                    );
                  },
                  child: const Text('Cancel'))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Directions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '1. Attach phone to belt',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '2. Position phone over participant\'s lumbar spine',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '3. Lean participant until you hear the chime',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '4. Hold participant steady and release after 2-5 seconds',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '5. Press the end test button once the participant has regained their balance',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '6. Repeat for each direction',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 5),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Lean ${widget.direction}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: const EdgeInsets.all(
                                  30), // Modify this till it fills the color properly
                              color: Colors.black54, // Color
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.pause_circle_filled_rounded,
                              color: Color.fromRGBO(255, 220, 212, 1),
                              size: 75,
                            ),
                            onPressed: () {
                              if (widget.direction == 'Forward') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StartTestPage(
                                      title: 'Reactive',
                                      direction: 'Right',
                                    ),
                                  ),
                                );
                              } else if (widget.direction == 'Right') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StartTestPage(
                                      title: 'Reactive',
                                      direction: 'Left',
                                    ),
                                  ),
                                );
                              } else if (widget.direction == 'Left') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const StartTestPage(
                                      title: 'Reactive',
                                      direction: 'Backward',
                                    ),
                                  ),
                                );
                              } else if (widget.direction == 'Backward') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestResultsPage(
                                      timeToStab: timeToStab,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    timeToStab = "";
    sensorRecorder = SensorRecorder();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }
}
