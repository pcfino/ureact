// import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:u_react/tests_page.dart';
import 'package:u_react/dynamic_results_page.dart';
import 'package:u_react/static_dynamic_recorder.dart';
import 'package:u_react/api/test_api.dart';
import 'package:u_react/api/imu_api.dart';
import 'package:u_react/models/dynamic.dart';
import 'package:session_manager/session_manager.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class DynamicTestPage extends StatefulWidget {
  DynamicTestPage({
    super.key,
    required this.pID,
    required this.thirdPartyID,
    required this.tID,
    required this.trialNumber,
    required this.start,
    required this.t1Duration,
    required this.t1TurnSpeed,
    required this.t1MLSway,
    required this.t2Duration,
    required this.t2TurnSpeed,
    required this.t2MLSway,
    required this.t3Duration,
    required this.t3TurnSpeed,
    required this.t3MLSway,
    this.t1DataAcc,
    this.t1DataRot,
    this.t1DataFs,
    this.t1TimeStamps,
    this.t2DataAcc,
    this.t2DataRot,
    this.t2DataFs,
    this.t2TimeStamps,
  });

  final int pID;
  final String? thirdPartyID;
  final int trialNumber;
  bool start;
  final double t1Duration;
  final double t1TurnSpeed;
  final double t1MLSway;
  final double t2Duration;
  final double t2TurnSpeed;
  final double t2MLSway;
  final double t3Duration;
  final double t3TurnSpeed;
  final double t3MLSway;
  dynamic t1DataAcc;
  dynamic t1DataRot;
  dynamic t1DataFs;
  dynamic t1TimeStamps;
  dynamic t2DataAcc;
  dynamic t2DataRot;
  dynamic t2DataFs;
  dynamic t2TimeStamps;
  dynamic t3DataAcc;
  dynamic t3DataRot;
  dynamic t3DataFs;
  dynamic t3TimeStamps;

  final int tID;

  @override
  State<DynamicTestPage> createState() => _DynamicTestPage();
}

/// Page to run a dynamic test.
class _DynamicTestPage extends State<DynamicTestPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  /// Records the smartphone sensor data.
  late StaticDynamicRecorder? sensorRecorder;

  /// Throw an error in case of invalid test.
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
                Text('Invalid test'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Try again'),
              onPressed: () {
                widget.start = true;
                sensorRecorder = null;
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  /// Skip the current trial of the test and move on to the next.
  void skip() async {
    if (widget.trialNumber == 3) {
      Dynamic? createdDynamic = await createDynamicTest(0, 0, 0);
      if (createdDynamic != null && context.mounted) {
        await sendIMU(createdDynamic.dID);
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DynamicResultsPage(
                pID: widget.pID,
                thirdPartyID: widget.thirdPartyID,
                administeredBy: createdDynamic.administeredBy,
                t1Duration: createdDynamic.t1Duration,
                t1TurnSpeed: createdDynamic.t1TurnSpeed,
                t1MLSway: createdDynamic.t1MLSway,
                t2Duration: createdDynamic.t2Duration,
                t2TurnSpeed: createdDynamic.t2TurnSpeed,
                t2MLSway: createdDynamic.t2MLSway,
                t3Duration: createdDynamic.t3Duration,
                t3TurnSpeed: createdDynamic.t3TurnSpeed,
                t3MLSway: createdDynamic.t3MLSway,
                dMax: createdDynamic.dMax,
                dMin: createdDynamic.dMin,
                dMean: createdDynamic.dMean,
                dMedian: createdDynamic.dMedian,
                tsMax: createdDynamic.tsMax,
                tsMin: createdDynamic.tsMin,
                tsMean: createdDynamic.tsMean,
                tsMedian: createdDynamic.tsMedian,
                mlMax: createdDynamic.mlMax,
                mlMin: createdDynamic.mlMin,
                mlMean: createdDynamic.mlMean,
                mlMedian: createdDynamic.mlMedian,
                tID: widget.tID,
              ),
            ),
          );
        }
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DynamicTestPage(
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            trialNumber: widget.trialNumber + 1,
            tID: widget.tID,
            start: true,
            t1Duration: widget.t1Duration,
            t1TurnSpeed: widget.t1TurnSpeed,
            t1MLSway: widget.t1MLSway,
            t2Duration: widget.t2Duration,
            t2TurnSpeed: widget.t2TurnSpeed,
            t2MLSway: widget.t2MLSway,
            t3Duration: widget.t1Duration,
            t3TurnSpeed: widget.t1TurnSpeed,
            t3MLSway: widget.t1MLSway,
            t1DataAcc: widget.t1DataAcc,
            t1DataRot: widget.t1DataAcc,
            t1DataFs: widget.t1DataAcc,
            t1TimeStamps: widget.t1TimeStamps,
            t2DataRot: widget.t2DataAcc,
            t2DataAcc: widget.t2DataAcc,
            t2DataFs: widget.t2DataAcc,
            t2TimeStamps: widget.t2TimeStamps,
          ),
        ),
      );
    }
  }

  /// Get the data from the sensor recorder and run the test script.
  Future<dynamic> getDynamicData() async {
    var sensorData = sensorRecorder!.endRecording();

    var decodedData = await runTandemGaitTestScript({
      'dataAcc': sensorData.formattedAccData(),
      'dataRot': sensorData.formattedGyrData(),
      'timeStamps': sensorData.timeStamps,
      'fs': sensorData.fs
    });
    if (widget.trialNumber == 1) {
      widget.t1DataAcc = sensorData.formattedAccData();
      widget.t1DataRot = sensorData.formattedGyrData();
      widget.t1DataFs = sensorData.fs;
      widget.t1TimeStamps = sensorData.timeStamps;
    } else if (widget.trialNumber == 2) {
      widget.t2DataAcc = sensorData.formattedAccData();
      widget.t2DataRot = sensorData.formattedGyrData();
      widget.t2DataFs = sensorData.fs;
      widget.t2TimeStamps = sensorData.timeStamps;
    } else if (widget.trialNumber == 3) {
      widget.t3DataAcc = sensorData.formattedAccData();
      widget.t3DataRot = sensorData.formattedGyrData();
      widget.t3DataFs = sensorData.fs;
      widget.t3TimeStamps = sensorData.timeStamps;
    }
    return decodedData;
  }

  /// Create a new dynamic test in the database.
  Future<dynamic> createDynamicTest(
      double duration, double turningSpeed, double mlSway) async {
    // Values for duration
    double dMax = max(widget.t1Duration, max(widget.t2Duration, duration));
    double dMin = min(widget.t1Duration, min(widget.t2Duration, duration));
    double dMean = (widget.t1Duration + widget.t2Duration + duration) / 3;
    double dMedian;
    if ((widget.t1Duration <= widget.t2Duration) &&
        (widget.t2Duration <= duration)) {
      dMedian = widget.t2Duration;
    } else if ((widget.t1Duration <= duration) &&
        (duration <= widget.t2Duration)) {
      dMedian = duration;
    } else if ((widget.t2Duration <= widget.t1Duration) &&
        (widget.t1Duration <= duration)) {
      dMedian = widget.t1Duration;
    } else if ((widget.t2Duration <= duration) &&
        (duration <= widget.t1Duration)) {
      dMedian = duration;
    } else if ((duration <= widget.t1Duration) &&
        (widget.t1Duration <= widget.t2Duration)) {
      dMedian = widget.t1Duration;
    }
    dMedian = widget.t2Duration;

    // Values for turning speed
    double tsMax =
        max(widget.t1TurnSpeed, max(widget.t2TurnSpeed, turningSpeed));
    double tsMin =
        min(widget.t1TurnSpeed, min(widget.t2TurnSpeed, turningSpeed));
    double tsMean =
        (widget.t1TurnSpeed + widget.t2TurnSpeed + turningSpeed) / 3;
    double tsMedian;
    if ((widget.t1TurnSpeed <= widget.t2TurnSpeed) &&
        (widget.t2TurnSpeed <= turningSpeed)) {
      tsMedian = widget.t2TurnSpeed;
    } else if ((widget.t1TurnSpeed <= turningSpeed) &&
        (turningSpeed <= widget.t2TurnSpeed)) {
      tsMedian = turningSpeed;
    } else if ((widget.t2TurnSpeed <= widget.t1TurnSpeed) &&
        (widget.t1TurnSpeed <= turningSpeed)) {
      tsMedian = widget.t1TurnSpeed;
    } else if ((widget.t2TurnSpeed <= turningSpeed) &&
        (turningSpeed <= widget.t1TurnSpeed)) {
      tsMedian = turningSpeed;
    } else if ((turningSpeed <= widget.t1TurnSpeed) &&
        (widget.t1TurnSpeed <= widget.t2TurnSpeed)) {
      tsMedian = widget.t1TurnSpeed;
    }
    tsMedian = widget.t2TurnSpeed;

    // Values for ML
    double mlMax = max(widget.t1MLSway, max(widget.t2MLSway, mlSway));
    double mlMin = min(widget.t1MLSway, min(widget.t2MLSway, mlSway));
    double mlMean = (widget.t1MLSway + widget.t2MLSway + mlSway) / 3;
    double mlMedian;
    if ((widget.t1MLSway <= widget.t2MLSway) && (widget.t2MLSway <= mlSway)) {
      mlMedian = widget.t2MLSway;
    } else if ((widget.t1MLSway <= mlSway) && (mlSway <= widget.t2MLSway)) {
      mlMedian = mlSway;
    } else if ((widget.t2MLSway <= widget.t1MLSway) &&
        (widget.t1MLSway <= mlSway)) {
      mlMedian = widget.t1MLSway;
    } else if ((widget.t2MLSway <= mlSway) && (mlSway <= widget.t1MLSway)) {
      mlMedian = mlSway;
    } else if ((mlSway <= widget.t1MLSway) &&
        (widget.t1MLSway <= widget.t2MLSway)) {
      mlMedian = widget.t1MLSway;
    }
    mlMedian = widget.t2MLSway;

    try {
      String admin = await SessionManager().getString("username");

      dynamic jsonDynamic = await createDynamic({
        "administeredBy": admin,
        "tID": widget.tID,
        "t1Duration": widget.t1Duration,
        "t1TurnSpeed": widget.t1TurnSpeed,
        "t1MLSway": widget.t1MLSway,
        "t2Duration": widget.t2Duration,
        "t2TurnSpeed": widget.t2TurnSpeed,
        "t2MLSway": widget.t2MLSway,
        "t3Duration": duration,
        "t3TurnSpeed": turningSpeed,
        "t3MLSway": mlSway,
        "dMax": dMax,
        "dMin": dMin,
        "dMean": dMean,
        "dMedian": dMedian,
        "tsMax": tsMax,
        "tsMin": tsMin,
        "tsMean": tsMean,
        "tsMedian": tsMedian,
        "mlMax": mlMax,
        "mlMin": mlMin,
        "mlMean": mlMean,
        "mlMedian": mlMedian,
      });
      Dynamic dynamicTest = Dynamic.fromJson(jsonDynamic);
      return dynamicTest;
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  /// Send the raw IMU data to the database.
  Future<dynamic> sendIMU(int dID) async {
    dynamic imuData = {
      "dID": dID,
      "t1": {
        "timeStamps": widget.t1TimeStamps,
        "dataAcc": widget.t1DataAcc,
        "dataRot": widget.t1DataRot,
        "fps": widget.t1DataFs,
      },
      "t2": {
        "timeStamps": widget.t2TimeStamps,
        "dataAcc": widget.t2DataAcc,
        "dataRot": widget.t2DataRot,
        "fps": widget.t2DataFs,
      },
      "t3": {
        "timeStamps": widget.t3TimeStamps,
        "dataAcc": widget.t3DataAcc,
        "dataRot": widget.t3DataRot,
        "fps": widget.t3DataFs,
      }
    };
    dynamic inserted = await insertIMU(imuData);
    return inserted;
  }

  bool inCountdown = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return MaterialApp(
      title: 'Dynamic',
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
            'Dynamic',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                widget.start = true;
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) => widget,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestsPage(
                      tID: widget.tID,
                      pID: widget.pID,
                      thirdPartyID: widget.thirdPartyID,
                    ),
                  ),
                );
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        color: Colors.transparent,
                      ),
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
                          '3. Walk heel-to-toe quickly to the end of the tape (3 meters)',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '4. Turn around and come back as fast as you can',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '5. Do not separate your feet or step off the line',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '6. Repeat for 3 trials',
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
                          'Trial ${widget.trialNumber}',
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
                          onPressed: () async {
                            if (widget.start) {
                              inCountdown = true;
                              setState(() {});
                            } else {
                              dynamic data = await getDynamicData();

                              if (context.mounted) {
                                double duration = data["duration"];
                                double turningSpeed = data["turningSpeed"];
                                double mlSway =
                                    (data["rmsMlGoing"] + data["rmsMlReturn"]) /
                                        2;

                                if (duration == 0) {
                                  throwTestError();
                                } else if (widget.trialNumber == 1) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DynamicTestPage(
                                        thirdPartyID: widget.thirdPartyID,
                                        pID: widget.pID,
                                        trialNumber: 2,
                                        tID: widget.tID,
                                        start: true,
                                        t1Duration: duration,
                                        t1TurnSpeed: turningSpeed,
                                        t1MLSway: mlSway,
                                        t2Duration: widget.t1Duration,
                                        t2TurnSpeed: widget.t1TurnSpeed,
                                        t2MLSway: widget.t1MLSway,
                                        t3Duration: widget.t1Duration,
                                        t3TurnSpeed: widget.t1TurnSpeed,
                                        t3MLSway: widget.t1MLSway,
                                        t1DataAcc: widget.t1DataAcc,
                                        t1DataRot: widget.t1DataRot,
                                        t1DataFs: widget.t1DataFs,
                                        t1TimeStamps: widget.t1TimeStamps,
                                      ),
                                    ),
                                  );
                                } else if (widget.trialNumber == 2) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DynamicTestPage(
                                        thirdPartyID: widget.thirdPartyID,
                                        pID: widget.pID,
                                        trialNumber: 3,
                                        tID: widget.tID,
                                        start: true,
                                        t1Duration: widget.t1Duration,
                                        t1TurnSpeed: widget.t1TurnSpeed,
                                        t1MLSway: widget.t1MLSway,
                                        t2Duration: duration,
                                        t2TurnSpeed: turningSpeed,
                                        t2MLSway: mlSway,
                                        t3Duration: widget.t1Duration,
                                        t3TurnSpeed: widget.t1TurnSpeed,
                                        t3MLSway: widget.t1MLSway,
                                        t1DataAcc: widget.t1DataAcc,
                                        t1DataRot: widget.t1DataRot,
                                        t1DataFs: widget.t1DataFs,
                                        t1TimeStamps: widget.t1TimeStamps,
                                        t2DataAcc: widget.t2DataAcc,
                                        t2DataRot: widget.t2DataRot,
                                        t2DataFs: widget.t2DataFs,
                                        t2TimeStamps: widget.t2TimeStamps,
                                      ),
                                    ),
                                  );
                                } else if (widget.trialNumber == 3) {
                                  Dynamic? createdDynamic =
                                      await createDynamicTest(
                                          duration, turningSpeed, mlSway);
                                  if (createdDynamic != null &&
                                      context.mounted) {
                                    await sendIMU(createdDynamic.dID);
                                    String admin = await SessionManager()
                                        .getString("username");

                                    if (context.mounted) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DynamicResultsPage(
                                            thirdPartyID: widget.thirdPartyID,
                                            administeredBy: admin,
                                            pID: widget.pID,
                                            t1Duration:
                                                createdDynamic.t1Duration,
                                            t1TurnSpeed:
                                                createdDynamic.t1TurnSpeed,
                                            t1MLSway: createdDynamic.t1MLSway,
                                            t2Duration:
                                                createdDynamic.t2Duration,
                                            t2TurnSpeed:
                                                createdDynamic.t2TurnSpeed,
                                            t2MLSway: createdDynamic.t2MLSway,
                                            t3Duration:
                                                createdDynamic.t3Duration,
                                            t3TurnSpeed:
                                                createdDynamic.t3TurnSpeed,
                                            t3MLSway: createdDynamic.t3MLSway,
                                            dMax: createdDynamic.dMax,
                                            dMin: createdDynamic.dMin,
                                            dMean: createdDynamic.dMean,
                                            dMedian: createdDynamic.dMedian,
                                            tsMax: createdDynamic.tsMax,
                                            tsMin: createdDynamic.tsMin,
                                            tsMean: createdDynamic.tsMean,
                                            tsMedian: createdDynamic.tsMedian,
                                            mlMax: createdDynamic.mlMax,
                                            mlMin: createdDynamic.mlMin,
                                            mlMean: createdDynamic.mlMean,
                                            mlMedian: createdDynamic.mlMedian,
                                            tID: widget.tID,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }
                              }
                            }
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
                            widget.start ? 'Start' : 'End',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black54,
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
                            sensorRecorder = StaticDynamicRecorder(false);
                            widget.start = false;
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
}
