import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/reactive_test_results_page.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/models/reactive.dart';
import 'reactive_sensor_recorder.dart';
import 'dart:async';
import 'api/test_api.dart';
import 'api/imu_api.dart';
import 'package:event/event.dart';
import 'package:session_manager/session_manager.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class ReactiveTestPage extends StatefulWidget {
  ReactiveTestPage({
    super.key,
    required this.pID,
    required this.tID,
    required this.direction,
    required this.forward,
    required this.left,
    required this.right,
    required this.backward,
    this.forwardDataAcc,
    this.forwardDataRot,
    this.forwardDataFs,
    this.backwardDataAcc,
    this.backwardDataRot,
    this.backwardDataFs,
    this.leftDataAcc,
    this.leftDataRot,
    this.leftDataFs,
    this.rightDataAcc,
    this.rightDataRot,
    this.rightDataFs,
  });

  final String direction;
  final int pID;
  final double forward;
  final double left;
  final double right;
  final double backward;

  dynamic forwardDataAcc;
  dynamic forwardDataRot;
  dynamic forwardDataFs;
  dynamic backwardDataAcc;
  dynamic backwardDataRot;
  dynamic backwardDataFs;
  dynamic leftDataAcc;
  dynamic leftDataRot;
  dynamic leftDataFs;
  dynamic rightDataAcc;
  dynamic rightDataRot;
  dynamic rightDataFs;

  final int tID;

  @override
  State<ReactiveTestPage> createState() => _ReactiveTestPage();
}

class _ReactiveTestPage extends State<ReactiveTestPage> {
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
                      pID: widget.pID,
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
      if (widget.direction == "Forward") {
        widget.forwardDataAcc = sensorData.formattedAccData();
        widget.forwardDataRot = sensorData.formattedGyrData();
        widget.forwardDataFs = sensorData.fs;
      } else if (widget.direction == "Backward") {
        widget.backwardDataAcc = sensorData.formattedAccData();
        widget.backwardDataRot = sensorData.formattedGyrData();
        widget.backwardDataFs = sensorData.fs;
      } else if (widget.direction == "Left") {
        widget.leftDataAcc = sensorData.formattedAccData();
        widget.leftDataRot = sensorData.formattedGyrData();
        widget.leftDataFs = sensorData.fs;
      } else if (widget.direction == "Right") {
        widget.rightDataAcc = sensorData.formattedAccData();
        widget.rightDataRot = sensorData.formattedGyrData();
        widget.rightDataFs = sensorData.fs;
      }
      nextTest();
    } catch (e) {
      if (context.mounted) {
        throwTestError();
      }
    }
  }

  Future<dynamic> sendIMU(int rID) async {
    dynamic imuData = {
      "rID": rID,
      "forward": {
        "dataAcc": widget.forwardDataAcc,
        "dataRot": widget.forwardDataRot,
        "fps": widget.forwardDataFs,
      },
      "backward": {
        "dataAcc": widget.backwardDataAcc,
        "dataRot": widget.backwardDataRot,
        "fps": widget.backwardDataFs,
      },
      "left": {
        "dataAcc": widget.leftDataAcc,
        "dataRot": widget.leftDataRot,
        "fps": widget.leftDataFs,
      },
      "right": {
        "dataAcc": widget.rightDataAcc,
        "dataRot": widget.rightDataRot,
        "fps": widget.rightDataFs,
      },
    };
    dynamic inserted = await insertIMU(imuData);
    return inserted;
  }

  void nextTest() async {
    sensorRecorder.endSensors();
    // Check for bad time
    if (timeToStab == 0) {
      throwTestError();
    } else if (widget.direction == 'Forward') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            pID: widget.pID,
            direction: 'Backward',
            forward: timeToStab,
            left: widget.left,
            right: widget.right,
            backward: widget.backward,
            tID: widget.tID,
            forwardDataAcc: widget.forwardDataAcc,
            forwardDataRot: widget.forwardDataRot,
            forwardDataFs: widget.forwardDataFs,
          ),
        ),
      );
    } else if (widget.direction == 'Backward') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            pID: widget.pID,
            direction: 'Left',
            forward: widget.forward,
            left: widget.left,
            right: widget.right,
            backward: timeToStab,
            tID: widget.tID,
            forwardDataAcc: widget.forwardDataAcc,
            forwardDataRot: widget.forwardDataRot,
            forwardDataFs: widget.forwardDataFs,
            backwardDataAcc: widget.backwardDataAcc,
            backwardDataRot: widget.backwardDataRot,
            backwardDataFs: widget.backwardDataFs,
          ),
        ),
      );
    } else if (widget.direction == 'Left') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            pID: widget.pID,
            direction: 'Right',
            forward: widget.forward,
            left: timeToStab,
            right: widget.right,
            backward: widget.backward,
            tID: widget.tID,
            forwardDataAcc: widget.forwardDataAcc,
            forwardDataRot: widget.forwardDataRot,
            forwardDataFs: widget.forwardDataFs,
            backwardDataAcc: widget.backwardDataAcc,
            backwardDataRot: widget.backwardDataRot,
            backwardDataFs: widget.backwardDataFs,
            leftDataAcc: widget.leftDataAcc,
            leftDataRot: widget.leftDataRot,
            leftDataFs: widget.leftDataFs,
          ),
        ),
      );
    } else if (widget.direction == 'Right') {
      double normMedian = calcMedian();
      Reactive? createdReactive = await createReactiveTest(normMedian);
      if (createdReactive != null && context.mounted) {
        await sendIMU(createdReactive.rID);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReactiveTestResultsPage(
                pID: widget.pID,
                administeredBy: createdReactive.administeredBy,
                forward: widget.forward * 1000,
                left: widget.left * 1000,
                right: timeToStab * 1000,
                backward: widget.backward * 1000,
                median: normMedian * 1000,
                tID: widget.tID,
              ),
            ),
          );
        }
      }
    }
  }

  double calcMedian() {
    List<double> vals = List.empty(growable: true);
    // Check for cases when test is skipped
    if (widget.forward != 0) {
      vals.add(widget.forward);
    }
    if (widget.backward != 0) {
      vals.add(widget.backward);
    }
    if (widget.left != 0) {
      vals.add(widget.left);
    }
    if (timeToStab != 0) {
      vals.add(timeToStab);
    }
    if (vals.isEmpty) {
      return 0;
    }
    vals.sort();
    double median = 0;
    if (vals.length == 4) {
      median = (vals[1] + vals[2]) / 2;
    } else if (vals.length == 3) {
      median = vals[1];
    } else if (vals.length == 2) {
      median = (vals[0] + vals[1]) / 2;
    } else {
      median = vals[0];
    }
    double normMedian = double.parse(median.toStringAsFixed(2));
    return normMedian;
  }

  void skip() async {
    if (!start) {
      sensorRecorder.endSensors();
      sensorRecorder.cancelPreTimer();
      if (sensorRecorder.getRunning()) {
        sensorRecorder.endRecording();
      }
    }
    if (widget.direction == "Right") {
      double median = calcMedian();
      Reactive? createdReactive = await createReactiveTest(median);
      if (createdReactive != null && context.mounted) {
        await sendIMU(createdReactive.rID);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ReactiveTestResultsPage(
                pID: widget.pID,
                administeredBy: createdReactive.administeredBy,
                forward: widget.forward,
                left: widget.left,
                right: widget.right,
                backward: widget.backward,
                median: double.parse(median.toStringAsFixed(2)),
                tID: widget.tID,
              ),
            ),
          );
        }
      }
    } else {
      String nextDir = "";
      if (widget.direction == "Forward") {
        nextDir = "Backward";
      } else if (widget.direction == "Backward") {
        nextDir = "Left";
      } else if (widget.direction == "Left") {
        nextDir = "Right";
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReactiveTestPage(
            pID: widget.pID,
            direction: nextDir,
            forward: widget.forward,
            left: widget.left,
            right: widget.right,
            backward: widget.backward,
            tID: widget.tID,
            forwardDataAcc: widget.forwardDataAcc,
            forwardDataRot: widget.forwardDataRot,
            forwardDataFs: widget.forwardDataFs,
            backwardDataAcc: widget.backwardDataAcc,
            backwardDataRot: widget.backwardDataRot,
            backwardDataFs: widget.backwardDataFs,
            leftDataAcc: widget.leftDataAcc,
            leftDataRot: widget.leftDataRot,
            leftDataFs: widget.leftDataFs,
          ),
        ),
      );
    }
  }

  void restart() {
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
  }

  void cancel() {
    if (!start) {
      sensorRecorder.endSensors();
      sensorRecorder.cancelPreTimer();
      if (sensorRecorder.getRunning()) {
        sensorRecorder.endRecording();
      }
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TestsPage(tID: widget.tID, pID: widget.pID),
      ),
    );
  }

  Future<dynamic> createReactiveTest(double median) async {
    try {
      String admin = await SessionManager().getString("username");
      dynamic jsonReactive = await createReactive({
        "administeredBy": admin,
        "fTime": widget.forward,
        "rTime": timeToStab,
        "lTime": widget.left,
        "bTime": widget.backward,
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
  bool start = true;
  bool inCountdown = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return MaterialApp(
      title: "Reactive",
      theme: ThemeData(
        colorScheme: cs,
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: cs.primary.withOpacity(0.1),
          scrolledUnderElevation: 0,
          title: const Text(
            "Reactive",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          //centerTitle: false,
          actions: <Widget>[
            TextButton(
              onPressed: () {
                restart();
              },
              child: const Text('Restart'),
            ),
            TextButton(
              onPressed: () {
                skip();
              },
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () {
                cancel();
              },
              child: const Text('Cancel'),
            ),
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
                      const Divider(color: Colors.transparent),
                      const Text(
                        'Directions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '1. Attach phone on patient\'s lumbar spine',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '2. Press the start button',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '3. Lean patient until you hear the chime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '4. Release patient when chime stops',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '5. Direct patient to stay still for 1 second after regaining stability',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '6. Repeat for each direction',
                          style: TextStyle(fontSize: 18),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      if (!inCountdown)
                        RawMaterialButton(
                          onPressed: () {
                            inCountdown = true;
                            setState(() {});
                          },
                          shape: CircleBorder(
                            side: BorderSide(
                              width: 10,
                              color: cs.background,
                            ),
                          ),
                          fillColor: cs.primary.withOpacity(0.1),
                          padding: const EdgeInsets.all(87),
                          elevation: 0,
                          highlightElevation: 0,
                          child: Text(
                            start ? 'Start' : 'Running',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: cs.secondary,
                            ),
                          ),
                        ),
                      if (inCountdown)
                        CircularCountDownTimer(
                          width: 200,
                          height: 200,
                          duration: 3,
                          fillColor: cs.secondary,
                          ringColor: Colors.transparent,
                          backgroundColor: cs.primary.withOpacity(0.1),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: cs.secondary,
                          ),
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
                          isReverse: true,
                          onComplete: () async {
                            inCountdown = false;
                            if (start) {
                              if (widget.direction == 'Forward') {
                                sensorRecorder =
                                    ReactiveSensorRecorder("forward");
                              } else if (widget.direction == 'Right') {
                                sensorRecorder =
                                    ReactiveSensorRecorder("right");
                              } else if (widget.direction == 'Left') {
                                sensorRecorder = ReactiveSensorRecorder("left");
                              } else if (widget.direction == 'Backward') {
                                sensorRecorder =
                                    ReactiveSensorRecorder("backward");
                              }
                              sensorRecorder.stopEvent.subscribe((args) {
                                getTTS();
                              });
                              start = false;
                            }
                            setState(() {});
                          },
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
