import 'dart:convert';
// import 'dart:io';
import 'package:capstone_project/reactive_start_test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/reactive_test_results_page.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/models/reactive.dart';
import 'reactive_sensor_recorder.dart';
import 'dart:async';
import 'api/test_api.dart';

class ReactiveEndTestPage extends StatefulWidget {
  const ReactiveEndTestPage(
      {super.key,
      required this.title,
      required this.direction,
      required this.forward,
      required this.left,
      required this.right,
      required this.backward,
      required this.tID});

  final String title;
  final String direction;

  final double forward;
  final double left;
  final double right;
  final double backward;

  final int tID;

  @override
  State<ReactiveEndTestPage> createState() => _EndTestPageState();
}

class _EndTestPageState extends State<ReactiveEndTestPage> {
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  late double timeToStab;
  late ReactiveSensorRecorder sensorRecorder;

  Future getTTS() async {
    var sensorData = sensorRecorder.endRecording();

    var decodedData = await runReactiveTestScript({
      'dataAcc': sensorData.formattedAccData(),
      'dataRot': sensorData.formattedGyrData(),
      'timeStamps': sensorData.timeStamps,
      'fs': sensorData.fs
    });

    timeToStab = decodedData['TTS'];
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

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

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
          leading: IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              if (sensorRecorder.getReady()) {
                sensorRecorder.endRecording();
              }
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ReactiveStartTestPage(
                          title: widget.title,
                          direction: widget.direction,
                          forward: widget.forward,
                          left: widget.left,
                          right: widget.right,
                          backward: widget.backward,
                          tID: widget.tID),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  if (sensorRecorder.getReady()) {
                    sensorRecorder.endRecording();
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
            padding: const EdgeInsets.all(16.0),
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
                      RawMaterialButton(
                        onPressed: () async {
                          await getTTS();
                          if (context.mounted) {
                            if (widget.direction == 'Forward') {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ReactiveStartTestPage(
                                    title: 'Reactive',
                                    direction: 'Right',
                                    forward: timeToStab,
                                    left: widget.left,
                                    right: widget.right,
                                    backward: widget.backward,
                                    tID: widget.tID,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            } else if (widget.direction == 'Right') {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ReactiveStartTestPage(
                                    title: 'Reactive',
                                    direction: 'Left',
                                    forward: widget.forward,
                                    left: widget.left,
                                    right: timeToStab,
                                    backward: widget.backward,
                                    tID: widget.tID,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            } else if (widget.direction == 'Left') {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ReactiveStartTestPage(
                                    title: 'Reactive',
                                    direction: 'Backward',
                                    forward: widget.forward,
                                    left: timeToStab,
                                    right: widget.right,
                                    backward: widget.backward,
                                    tID: widget.tID,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            } else if (widget.direction == 'Backward') {
                              List<double> vals = [
                                widget.forward,
                                widget.left,
                                widget.right,
                                timeToStab
                              ];
                              vals.sort();
                              double median = (vals[1] + vals[2]) / 2;
                              Reactive? createdReactive =
                                  await createReactiveTest(
                                      double.parse(median.toStringAsFixed(2)));
                              if (createdReactive != null && context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReactiveTestResultsPage(
                                      forward: widget.forward,
                                      left: widget.left,
                                      right: widget.right,
                                      backward: timeToStab,
                                      median: median,
                                      tID: widget.tID,
                                    ),
                                  ),
                                );
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
                        fillColor: const Color.fromRGBO(255, 220, 212, 1),
                        padding: const EdgeInsets.all(87),
                        elevation: 0,
                        highlightElevation: 0,
                        child: const Text(
                          'Start',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // body: Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Column(
            //     children: [
            //       Expanded(
            //         flex: 3,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Center(
            //               child: Text(
            //                 'Directions',
            //                 style: TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Divider(
            //                 height: 1,
            //                 thickness: 1,
            //                 color: Colors.grey,
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '1. Attach phone to lumbar spine',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '2. Press the start button',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '3. Lean participant until you hear the chime',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '4. Hold participant steady and release after 2-5 seconds',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '5. Press the end test button once the participant has regained their balance',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //             Container(
            //               margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
            //               child: const Text(
            //                 '6. Repeat for each direction',
            //                 style: TextStyle(fontSize: 20),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         flex: 2,
            //         child: Column(
            //           children: [
            //             Center(
            //               child: Text(
            //                 'Lean ${widget.direction}',
            //                 style: const TextStyle(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //             const Divider(
            //               color: Colors.transparent,
            //             ),
            //             RawMaterialButton(
            //               onPressed: () async {
            //                 await getTTS();
            //                 if (context.mounted) {
            //                   if (widget.direction == 'Forward') {
            //                     Navigator.pushReplacement(
            //                       context,
            //                       PageRouteBuilder(
            //                         pageBuilder:
            //                             (context, animation1, animation2) =>
            //                                 ReactiveStartTestPage(
            //                           title: 'Reactive',
            //                           direction: 'Right',
            //                           forward: timeToStab,
            //                           left: widget.left,
            //                           right: widget.right,
            //                           backward: widget.backward,
            //                           tID: widget.tID,
            //                         ),
            //                         transitionDuration: Duration.zero,
            //                         reverseTransitionDuration: Duration.zero,
            //                       ),
            //                     );
            //                   } else if (widget.direction == 'Right') {
            //                     Navigator.pushReplacement(
            //                       context,
            //                       PageRouteBuilder(
            //                         pageBuilder:
            //                             (context, animation1, animation2) =>
            //                                 ReactiveStartTestPage(
            //                           title: 'Reactive',
            //                           direction: 'Left',
            //                           forward: widget.forward,
            //                           left: widget.left,
            //                           right: timeToStab,
            //                           backward: widget.backward,
            //                           tID: widget.tID,
            //                         ),
            //                         transitionDuration: Duration.zero,
            //                         reverseTransitionDuration: Duration.zero,
            //                       ),
            //                     );
            //                   } else if (widget.direction == 'Left') {
            //                     Navigator.pushReplacement(
            //                       context,
            //                       PageRouteBuilder(
            //                         pageBuilder:
            //                             (context, animation1, animation2) =>
            //                                 ReactiveStartTestPage(
            //                           title: 'Reactive',
            //                           direction: 'Backward',
            //                           forward: widget.forward,
            //                           left: timeToStab,
            //                           right: widget.right,
            //                           backward: widget.backward,
            //                           tID: widget.tID,
            //                         ),
            //                         transitionDuration: Duration.zero,
            //                         reverseTransitionDuration: Duration.zero,
            //                       ),
            //                     );
            //                   } else if (widget.direction == 'Backward') {
            //                     List<double> vals = [
            //                       widget.forward,
            //                       widget.left,
            //                       widget.right,
            //                       timeToStab
            //                     ];
            //                     vals.sort();
            //                     double median = (vals[1] + vals[2]) / 2;
            //                     Reactive? createdReactive =
            //                         await createReactiveTest(
            //                             double.parse(median.toStringAsFixed(2)));
            //                     if (createdReactive != null && context.mounted) {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) =>
            //                               ReactiveTestResultsPage(
            //                             forward: widget.forward,
            //                             left: widget.left,
            //                             right: widget.right,
            //                             backward: timeToStab,
            //                             median: median,
            //                             tID: widget.tID,
            //                           ),
            //                         ),
            //                       );
            //                     }
            //                   }
            //                 }
            //               },
            //               shape: CircleBorder(
            //                 side: BorderSide(
            //                   width: 10,
            //                   color: cs.background,
            //                 ),
            //               ),
            //               fillColor: const Color.fromRGBO(255, 220, 212, 1),
            //               padding: const EdgeInsets.all(87),
            //               elevation: 0,
            //               highlightElevation: 0,
            //               child: const Text(
            //                 'End',
            //                 style: TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 18,
            //                   color: Colors.black54,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    timeToStab = 0;
    if (widget.direction == 'Forward') {
      sensorRecorder = ReactiveSensorRecorder("forward");
    } else if (widget.direction == 'Right') {
      sensorRecorder = ReactiveSensorRecorder("right");
    } else if (widget.direction == 'Left') {
      sensorRecorder = ReactiveSensorRecorder("left");
    } else if (widget.direction == 'Backward') {
      sensorRecorder = ReactiveSensorRecorder("backward");
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }
}
