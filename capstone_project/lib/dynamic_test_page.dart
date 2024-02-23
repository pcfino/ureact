import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/dynamic_results_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/dynamic.dart';

class DynamicTestPage extends StatefulWidget {
  const DynamicTestPage({
    super.key,
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
  });

  final int trialNumber;
  final bool start;
  final double t1Duration;
  final double t1TurnSpeed;
  final double t1MLSway;
  final double t2Duration;
  final double t2TurnSpeed;
  final double t2MLSway;
  final double t3Duration;
  final double t3TurnSpeed;
  final double t3MLSway;

  final int tID;

  @override
  State<DynamicTestPage> createState() => _DynamicTestPage();
}

class _DynamicTestPage extends State<DynamicTestPage> {
  Future<dynamic> createDynamicTest(
      double dMax,
      double dMin,
      double dMean,
      double dMedian,
      double tsMax,
      double tsMin,
      double tsMean,
      double tsMedian,
      double mlMax,
      double mlMin,
      double mlMean,
      double mlMedian) async {
    try {
      dynamic jsonDynamic = await createDynamic({
        "tID": widget.tID,
        "t1Duration": widget.t1Duration,
        "t1TurnSpeed": widget.t1TurnSpeed,
        "t1MLSway": widget.t1MLSway,
        "t2Duration": widget.t2Duration,
        "t2TurnSpeed": widget.t2TurnSpeed,
        "t2MLSway": widget.t2MLSway,
        "t3Duration": widget.t3Duration,
        "t3TurnSpeed": widget.t3TurnSpeed,
        "t3MLSway": widget.t3MLSway,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Dynamic',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Dynamic'),
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
                        builder: (context) => TestsPage(
                          tID: widget.tID,
                        ),
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
                    '1. Attach phone on lumbar spine',
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
                    '3. Walk heel-to-toe quickly to the end of the tape',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '4. Turn around and come back as fast as you can',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '5. Do not separate your feet or step off the line',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '6. Repeat for 3 trials',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 5),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Trial ${widget.trialNumber}',
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
                              margin: const EdgeInsets.all(30),
                              color: Colors.black54,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              widget.start
                                  ? Icons.play_circle_fill_rounded
                                  : Icons.pause_circle_filled_rounded,
                              color: const Color.fromRGBO(255, 220, 212, 1),
                              size: 75,
                            ),
                            onPressed: () async {
                              if (widget.trialNumber == 3) {
                                if (widget.start) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DynamicTestPage(
                                        trialNumber: widget.start
                                            ? widget.trialNumber
                                            : widget.trialNumber + 1,
                                        tID: widget.tID,
                                        start: !widget.start,
                                        t1Duration: widget.t1Duration,
                                        t1TurnSpeed: widget.t1TurnSpeed,
                                        t1MLSway: widget.t1MLSway,
                                        t2Duration: widget.t1Duration,
                                        t2TurnSpeed: widget.t1TurnSpeed,
                                        t2MLSway: widget.t1MLSway,
                                        t3Duration: widget.t1Duration,
                                        t3TurnSpeed: widget.t1TurnSpeed,
                                        t3MLSway: widget.t1MLSway,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Values for duration
                                  double dMax = max(
                                      widget.t1Duration,
                                      max(widget.t2Duration,
                                          widget.t3Duration));
                                  double dMin = min(
                                      widget.t1Duration,
                                      min(widget.t2Duration,
                                          widget.t3Duration));
                                  double dMean = (widget.t1Duration +
                                          widget.t2Duration +
                                          widget.t3Duration) /
                                      3;
                                  double dMedian;
                                  if ((widget.t1Duration <=
                                          widget.t2Duration) &&
                                      (widget.t2Duration <=
                                          widget.t3Duration)) {
                                    dMedian = widget.t2Duration;
                                  } else if ((widget.t1Duration <=
                                          widget.t3Duration) &&
                                      (widget.t3Duration <=
                                          widget.t2Duration)) {
                                    dMedian = widget.t3Duration;
                                  } else if ((widget.t2Duration <=
                                          widget.t1Duration) &&
                                      (widget.t1Duration <=
                                          widget.t3Duration)) {
                                    dMedian = widget.t1Duration;
                                  } else if ((widget.t2Duration <=
                                          widget.t3Duration) &&
                                      (widget.t3Duration <=
                                          widget.t1Duration)) {
                                    dMedian = widget.t3Duration;
                                  } else if ((widget.t3Duration <=
                                          widget.t1Duration) &&
                                      (widget.t1Duration <=
                                          widget.t2Duration)) {
                                    dMedian = widget.t1Duration;
                                  }
                                  dMedian = widget.t2Duration;

                                  // Values for turning speed
                                  double tsMax = max(
                                      widget.t1TurnSpeed,
                                      max(widget.t2TurnSpeed,
                                          widget.t3TurnSpeed));
                                  double tsMin = min(
                                      widget.t1TurnSpeed,
                                      min(widget.t2TurnSpeed,
                                          widget.t3TurnSpeed));
                                  double tsMean = (widget.t1TurnSpeed +
                                          widget.t2TurnSpeed +
                                          widget.t3TurnSpeed) /
                                      3;
                                  double tsMedian;
                                  if ((widget.t1TurnSpeed <=
                                          widget.t2TurnSpeed) &&
                                      (widget.t2TurnSpeed <=
                                          widget.t3TurnSpeed)) {
                                    tsMedian = widget.t2TurnSpeed;
                                  } else if ((widget.t1TurnSpeed <=
                                          widget.t3TurnSpeed) &&
                                      (widget.t3TurnSpeed <=
                                          widget.t2TurnSpeed)) {
                                    tsMedian = widget.t3TurnSpeed;
                                  } else if ((widget.t2TurnSpeed <=
                                          widget.t1TurnSpeed) &&
                                      (widget.t1TurnSpeed <=
                                          widget.t3TurnSpeed)) {
                                    tsMedian = widget.t1TurnSpeed;
                                  } else if ((widget.t2TurnSpeed <=
                                          widget.t3TurnSpeed) &&
                                      (widget.t3TurnSpeed <=
                                          widget.t1TurnSpeed)) {
                                    tsMedian = widget.t3TurnSpeed;
                                  } else if ((widget.t3TurnSpeed <=
                                          widget.t1TurnSpeed) &&
                                      (widget.t1TurnSpeed <=
                                          widget.t2TurnSpeed)) {
                                    tsMedian = widget.t1TurnSpeed;
                                  }
                                  tsMedian = widget.t2TurnSpeed;

                                  // Values for ML
                                  double mlMax = max(widget.t1MLSway,
                                      max(widget.t2MLSway, widget.t3MLSway));
                                  double mlMin = min(widget.t1MLSway,
                                      min(widget.t2MLSway, widget.t3MLSway));
                                  double mlMean = (widget.t1MLSway +
                                          widget.t2MLSway +
                                          widget.t3MLSway) /
                                      3;
                                  double mlMedian;
                                  if ((widget.t1MLSway <= widget.t2MLSway) &&
                                      (widget.t2MLSway <= widget.t3MLSway)) {
                                    mlMedian = widget.t2MLSway;
                                  } else if ((widget.t1MLSway <=
                                          widget.t3MLSway) &&
                                      (widget.t3MLSway <= widget.t2MLSway)) {
                                    mlMedian = widget.t3MLSway;
                                  } else if ((widget.t2MLSway <=
                                          widget.t1MLSway) &&
                                      (widget.t1MLSway <= widget.t3MLSway)) {
                                    mlMedian = widget.t1MLSway;
                                  } else if ((widget.t2MLSway <=
                                          widget.t3MLSway) &&
                                      (widget.t3MLSway <= widget.t1MLSway)) {
                                    mlMedian = widget.t3MLSway;
                                  } else if ((widget.t3MLSway <=
                                          widget.t1MLSway) &&
                                      (widget.t1MLSway <= widget.t2MLSway)) {
                                    mlMedian = widget.t1MLSway;
                                  }
                                  mlMedian = widget.t2MLSway;

                                  Dynamic? createdDynamic =
                                      await createDynamicTest(
                                          dMax,
                                          dMin,
                                          dMean,
                                          dMedian,
                                          tsMax,
                                          tsMin,
                                          tsMean,
                                          tsMedian,
                                          mlMax,
                                          mlMin,
                                          mlMean,
                                          mlMedian);

                                  if (createdDynamic != null &&
                                      context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DynamicResultsPage(
                                          t1Duration: widget.t1Duration,
                                          t1TurnSpeed: widget.t1TurnSpeed,
                                          t1MLSway: widget.t1MLSway,
                                          t2Duration: widget.t1Duration,
                                          t2TurnSpeed: widget.t1TurnSpeed,
                                          t2MLSway: widget.t1MLSway,
                                          t3Duration: widget.t1Duration,
                                          t3TurnSpeed: widget.t1TurnSpeed,
                                          t3MLSway: widget.t1MLSway,
                                          dMax: dMax,
                                          dMin: dMin,
                                          dMean: dMean,
                                          dMedian: dMedian,
                                          tsMax: tsMax,
                                          tsMin: tsMin,
                                          tsMean: tsMean,
                                          tsMedian: tsMedian,
                                          mlMax: mlMax,
                                          mlMin: mlMin,
                                          mlMean: mlMean,
                                          mlMedian: mlMedian,
                                          tID: widget.tID,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DynamicTestPage(
                                      trialNumber: widget.start
                                          ? widget.trialNumber
                                          : widget.trialNumber + 1,
                                      tID: widget.tID,
                                      start: !widget.start,
                                      t1Duration: widget.t1Duration,
                                      t1TurnSpeed: widget.t1TurnSpeed,
                                      t1MLSway: widget.t1MLSway,
                                      t2Duration: widget.t1Duration,
                                      t2TurnSpeed: widget.t1TurnSpeed,
                                      t2MLSway: widget.t1MLSway,
                                      t3Duration: widget.t1Duration,
                                      t3TurnSpeed: widget.t1TurnSpeed,
                                      t3MLSway: widget.t1MLSway,
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
}
