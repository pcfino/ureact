import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/static_results_page.dart';
import 'package:capstone_project/static_dynamic_recorder.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/static.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class StaticTestPage extends StatefulWidget {
  const StaticTestPage({
    super.key,
    required this.tID,
    required this.stance,
    required this.tlSolidML,
    required this.tlFoamML,
    required this.slSolidML,
    required this.slFoamML,
    required this.tandSolidML,
    required this.tandFoamML,
  });

  final String stance;
  final double tlSolidML;
  final double tlFoamML;
  final double slSolidML;
  final double slFoamML;
  final double tandSolidML;
  final double tandFoamML;

  final int tID;

  @override
  State<StaticTestPage> createState() => _StaticTestPage();
}

class _StaticTestPage extends State<StaticTestPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  late StaticDynamicRecorder sensorRecorder;
  Duration duration = Duration();
  Timer? timer;

  Future<dynamic> getStaticData() async {
    var sensorData = sensorRecorder.endRecording();

    var decodedData = await runSwayTestScript({
      'dataAcc': sensorData.formattedAccData(),
      'dataRot': sensorData.formattedGyrData(),
      'timeStamps': sensorData.timeStamps,
      'fs': sensorData.fs
    });
    double dataML = decodedData["rmsMl"];
    return dataML;
  }

  Future<dynamic> createStaticTest(double dataML) async {
    try {
      dynamic jsonStatic = await createStatic({
        "tlSolidML": widget.tlSolidML,
        "tlFoamML": widget.tlFoamML,
        "slSolidML": widget.slSolidML,
        "slFoamML": double.parse(dataML.toStringAsFixed(2)),
        "tandSolidML": widget.tandSolidML,
        "tandFoamML": widget.tandFoamML,
        "tID": widget.tID,
      });
      Static staticTest = Static.fromJson(jsonStatic);
      return staticTest;
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  Future stopRecording() async {
    timer!.cancel();
    dynamic dataML = await getStaticData();

    if (context.mounted) {
      if (widget.stance == "Two Leg Stance (Solid)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              stance: "Single Leg Stance (Solid)",
              tID: widget.tID,
              tlSolidML: double.parse(dataML.toStringAsFixed(2)),
              tlFoamML: widget.tlFoamML,
              slSolidML: widget.slSolidML,
              slFoamML: widget.slFoamML,
              tandSolidML: widget.tandSolidML,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Single Leg Stance (Solid)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              stance: "Tandem Stance (Solid)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: double.parse(dataML.toStringAsFixed(2)),
              slFoamML: widget.slFoamML,
              tandSolidML: widget.tandSolidML,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Tandem Stance (Solid)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              stance: "Two Leg Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: widget.slSolidML,
              slFoamML: widget.slFoamML,
              tandSolidML: double.parse(dataML.toStringAsFixed(2)),
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Two Leg Stance (Foam)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              stance: "Single Leg Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: double.parse(dataML.toStringAsFixed(2)),
              slSolidML: widget.slSolidML,
              slFoamML: widget.slFoamML,
              tandSolidML: widget.tandSolidML,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Single Leg Stance (Foam)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              stance: "Tandem Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: widget.slSolidML,
              slFoamML: double.parse(dataML.toStringAsFixed(2)),
              tandSolidML: widget.tandSolidML,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Tandem Stance (Foam)") {
        Static? createdStatic = await createStaticTest(dataML);
        if (createdStatic != null && context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StaticResultsPage(
                tID: widget.tID,
                tlSolidML: widget.tlSolidML,
                tlFoamML: widget.tlFoamML,
                slSolidML: widget.slSolidML,
                slFoamML: widget.slFoamML,
                tandSolidML: widget.tandSolidML,
                tandFoamML: double.parse(dataML.toStringAsFixed(2)),
              ),
            ),
          );
        }
      }
    }
  }

  void checkTime() {
    int seconds = duration.inSeconds + 1;
    duration = Duration(seconds: seconds);
    if (duration.inSeconds == 30) {
      stopRecording();
    }
  }

  void start() {
    sensorRecorder = StaticDynamicRecorder(true);
    timer = Timer.periodic(Duration(seconds: 1), (_) => checkTime());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return MaterialApp(
      title: 'Static',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Static'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: () {
              if (timer != null) {
                timer!.cancel();
              }
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => widget,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (timer != null) {
                  timer!.cancel();
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestsPage(
                      tID: widget.tID,
                    ),
                  ),
                );
              },
              child: const Text('Cancel'),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
            child: Row(
              children: [
                Expanded(
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
                          '3. On the start chime, take the stance denoted below',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '4. Stand for 30 seconds until you hear the end chime',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '5. Repeat for 3 stances',
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
                          widget.stance,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      if (timer == null)
                        RawMaterialButton(
                          onPressed: () {
                            start();
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
                      if (timer != null)
                        const CircularCountDownTimer(
                          width: 200,
                          height: 200,
                          duration: 30,
                          fillColor: Colors.black54,
                          ringColor: Colors.transparent,
                          backgroundColor: Color.fromRGBO(255, 220, 212, 1),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.black45,
                          ),
                          strokeCap: StrokeCap.round,
                          strokeWidth: 10,
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
