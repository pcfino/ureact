import 'dart:convert';
import "dart:math";
import 'package:capstone_project/patient_angle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/reactive_test_results_page.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/models/reactive.dart';
import 'reactive_sensor_recorder.dart';
import 'dart:async';
import 'api/test_api.dart';
import 'package:event/event.dart';

class ReactiveTestPage extends StatefulWidget {
  const ReactiveTestPage(
      {super.key,
      required this.direction,
      required this.forward,
      required this.left,
      required this.right,
      required this.backward,
      required this.tID});

  final String direction;

  final double forward;
  final double left;
  final double right;
  final double backward;

  final int tID;

  @override
  State<ReactiveTestPage> createState() => _ReactiveTestPage();
}

class _ReactiveTestPage extends State<ReactiveTestPage>
    with SingleTickerProviderStateMixin {
  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //   super.dispose();
  // }

  late double timeToStab;
  late ReactiveSensorRecorder sensorRecorder;

  void throwTestError() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You did not complete the test.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try Again'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ReactiveTestPage(
                      direction: widget.direction,
                      forward: widget.forward,
                      left: widget.left,
                      right: widget.right,
                      backward: widget.backward,
                      tID: widget.tID,
                    ),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future getTTS() async {
    SensorRecorderResults? sensorData;
    try {
      sensorData = sensorRecorder.endRecording();
      var decodedData = await runReactiveTestScript({
        'dataAcc': sensorData.formattedAccData(),
        'dataRot': sensorData.formattedGyrData(),
        'timeStamps': sensorData.timeStamps,
        'fs': sensorData.fs
      });

      timeToStab = decodedData['TTS'];
      nextTest();
    } catch (e) {
      if (context.mounted) {
        throwTestError();
      }
    }
  }

  void nextTest() async {
    sensorRecorder.endSensors();
    // Check for bad time
    if (timeToStab == 0) {
      throwTestError();
    } else if (widget.direction == 'Forward') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            direction: 'Backward',
            forward: timeToStab,
            left: widget.left,
            right: widget.right,
            backward: widget.backward,
            tID: widget.tID,
          ),
        ),
      );
    } else if (widget.direction == 'Backward') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            direction: 'Left',
            forward: widget.forward,
            left: widget.left,
            right: widget.right,
            backward: timeToStab,
            tID: widget.tID,
          ),
        ),
      );
    } else if (widget.direction == 'Left') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            direction: 'Right',
            forward: widget.forward,
            left: timeToStab,
            right: widget.right,
            backward: widget.backward,
            tID: widget.tID,
          ),
        ),
      );
    } else if (widget.direction == 'Right') {
      List<double> vals = [
        widget.forward,
        widget.left,
        timeToStab,
        widget.backward
      ];
      vals.sort();
      double median = (vals[1] + vals[2]) / 2;
      Reactive? createdReactive =
          await createReactiveTest(double.parse(median.toStringAsFixed(2)));
      if (createdReactive != null && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReactiveTestResultsPage(
              forward: widget.forward,
              left: widget.left,
              right: timeToStab,
              backward: widget.backward,
              median: double.parse(median.toStringAsFixed(2)),
              tID: widget.tID,
            ),
          ),
        );
      }
    }
  }

  Future<dynamic> createReactiveTest(double median) async {
    try {
      dynamic jsonReactive = await createReactive({
        "fTime": widget.forward,
        "rTime": widget.right,
        "lTime": widget.left,
        "bTime": timeToStab,
        "mTime": median,
        "tID": widget.tID,
      });
      Reactive reactiveTest = Reactive.fromJson(jsonReactive);
      return reactiveTest;
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  TextEditingController startButton = TextEditingController();
  late final AnimationController animation_controller =
      AnimationController(vsync: this, duration: const Duration(minutes: 1))
        ..repeat();

  bool start = true;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return MaterialApp(
      title: "Reactive",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Reactive"),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              try {
                if (!start) {
                  sensorRecorder.endSensors();
                  sensorRecorder.cancelPreTimer();
                  if (sensorRecorder.getRunning()) {
                    sensorRecorder.endRecording();
                  }
                  start = true;
                  setState(() {});
                }
              } catch (e) {
                throwTestError();
              }
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (!start) {
                    sensorRecorder.endSensors();
                    sensorRecorder.cancelPreTimer();
                    if (sensorRecorder.getRunning()) {
                      sensorRecorder.endRecording();
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TestsPage(tID: widget.tID),
                    ),
                  );
                },
                child: const Text('Cancel'))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                        child: const Text(
                          '1. Attach phone to lumbar spine',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '2. Press the start button',
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
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
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
                      const Divider(
                        color: Colors.transparent,
                      ),
                      start
                          ? RawMaterialButton(
                              onPressed: () async {
                                if (start) {
                                  if (widget.direction == 'Forward') {
                                    sensorRecorder =
                                        ReactiveSensorRecorder("forward");
                                  } else if (widget.direction == 'Right') {
                                    sensorRecorder =
                                        ReactiveSensorRecorder("right");
                                  } else if (widget.direction == 'Left') {
                                    sensorRecorder =
                                        ReactiveSensorRecorder("left");
                                  } else if (widget.direction == 'Backward') {
                                    sensorRecorder =
                                        ReactiveSensorRecorder("backward");
                                  }
                                  sensorRecorder.stopEvent.subscribe((args) {
                                    getTTS();
                                  });
                                  start = false;
                                  setState(() {});
                                }
                              },
                              shape: CircleBorder(
                                side: BorderSide(
                                  width: 10,
                                  color: cs.background,
                                ),
                              ),
                              fillColor: const Color.fromRGBO(255, 220, 212, 1),
                              padding: const EdgeInsets.all(87),
                              elevation: 0,
                              highlightElevation: 0,
                              child: Text(
                                start ? "Start" : "Running",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black54,
                                ),
                              ))
                          : AnimatedBuilder(
                              animation: animation_controller,
                              builder: (context, child) {
                                PatientAngle pa =
                                    PatientAngle(widget.direction);
                                double angle = pa.angle;
                                return Transform.rotate(
                                  // angle: animation_controller.value * 2 * pi,
                                  angle: angle,
                                  child: child,
                                );
                              },
                              child: const Icon(
                                Icons.angle,
                                color: Colors.black,
                                size: 180,
                              )
                              // child: FlutterLogo(size: 200),
                              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    timeToStab = 0;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }
}
