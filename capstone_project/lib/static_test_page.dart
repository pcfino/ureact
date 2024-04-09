import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/static_results_page.dart';
import 'package:capstone_project/static_dynamic_recorder.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/api/imu_api.dart';
import 'package:capstone_project/models/static.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class StaticTestPage extends StatefulWidget {
  StaticTestPage({
    super.key,
    required this.pID,
    required this.thirdPartyID,
    required this.tID,
    required this.stance,
    required this.tlSolidML,
    required this.tlFoamML,
    required this.slSolidML,
    required this.slFoamML,
    required this.tandSolidML,
    required this.tandFoamML,
    this.tlSolidDataAcc,
    this.tlSolidDataRot,
    this.tlSolidDataFs,
    this.slSolidDataAcc,
    this.slSolidDataRot,
    this.slSolidDataFs,
    this.tandSolidDataAcc,
    this.tandSolidDataRot,
    this.tandSolidDataFs,
    this.tlFoamDataRot,
    this.tlFoamDataAcc,
    this.tlFoamDataFs,
    this.slFoamDataAcc,
    this.slFoamDataRot,
    this.slFoamDataFs,
    this.tandFoamDataAcc,
    this.tandFoamDataRot,
    this.tandFoamDataFs,
  });

  final int pID;
  final String? thirdPartyID;
  final String stance;
  final double tlSolidML;
  final double tlFoamML;
  final double slSolidML;
  final double slFoamML;
  final double tandSolidML;
  final double tandFoamML;

  dynamic tlSolidDataAcc;
  dynamic tlSolidDataRot;
  dynamic tlSolidDataFs;
  dynamic slSolidDataAcc;
  dynamic slSolidDataRot;
  dynamic slSolidDataFs;
  dynamic tandSolidDataAcc;
  dynamic tandSolidDataRot;
  dynamic tandSolidDataFs;
  dynamic tlFoamDataRot;
  dynamic tlFoamDataAcc;
  dynamic tlFoamDataFs;
  dynamic slFoamDataAcc;
  dynamic slFoamDataRot;
  dynamic slFoamDataFs;
  dynamic tandFoamDataAcc;
  dynamic tandFoamDataRot;
  dynamic tandFoamDataFs;

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
    if (widget.stance == "Two Leg Stance (Solid)") {
      widget.tlSolidDataAcc = sensorData.formattedAccData();
      widget.tlSolidDataRot = sensorData.formattedGyrData();
      widget.tlSolidDataFs = sensorData.fs;
    } else if (widget.stance == "Single Leg Stance (Solid)") {
      widget.slSolidDataAcc = sensorData.formattedAccData();
      widget.slSolidDataRot = sensorData.formattedGyrData();
      widget.slSolidDataFs = sensorData.fs;
    } else if (widget.stance == "Tandem Leg Stance (Solid)") {
      widget.tandSolidDataAcc = sensorData.formattedAccData();
      widget.tandSolidDataRot = sensorData.formattedGyrData();
      widget.tandSolidDataFs = sensorData.fs;
    } else if (widget.stance == "Two Leg Stance (Foam)") {
      widget.tlFoamDataAcc = sensorData.formattedAccData();
      widget.tlFoamDataRot = sensorData.formattedGyrData();
      widget.tlFoamDataFs = sensorData.fs;
    } else if (widget.stance == "Single Leg Stance (Foam)") {
      widget.slFoamDataAcc = sensorData.formattedAccData();
      widget.slFoamDataRot = sensorData.formattedGyrData();
      widget.slFoamDataFs = sensorData.fs;
    } else if (widget.stance == "Tandem Leg Stance (Foam)") {
      widget.tandFoamDataAcc = sensorData.formattedAccData();
      widget.tandFoamDataRot = sensorData.formattedGyrData();
      widget.tandFoamDataFs = sensorData.fs;
    }
    return dataML;
  }

  Future<dynamic> sendIMU(int sID) async {
    dynamic imuData = {
      "sID": sID,
      "tlSolid": {
        "dataAcc": widget.tlSolidDataAcc,
        "dataRot": widget.tlSolidDataRot,
        "fps": widget.tlSolidDataFs,
      },
      "slSolid": {
        "dataAcc": widget.slSolidDataAcc,
        "dataRot": widget.slSolidDataRot,
        "fps": widget.slSolidDataFs,
      },
      "tandSolid": {
        "dataAcc": widget.tandSolidDataAcc,
        "dataRot": widget.tandSolidDataRot,
        "fps": widget.tandSolidDataFs,
      },
      "tlFoam": {
        "dataAcc": widget.tlFoamDataAcc,
        "dataRot": widget.tlFoamDataRot,
        "fps": widget.tlFoamDataFs,
      },
      "slFoam": {
        "dataAcc": widget.slFoamDataAcc,
        "dataRot": widget.slFoamDataRot,
        "fps": widget.slFoamDataFs,
      },
      "tandFoam": {
        "dataAcc": widget.tandFoamDataAcc,
        "dataRot": widget.tandFoamDataRot,
        "fps": widget.tandFoamDataFs,
      },
    };
    dynamic inserted = await insertIMU(imuData);
    return inserted;
  }

  Future<dynamic> createStaticTest(double dataML) async {
    try {
      dynamic jsonStatic = await createStatic({
        "tlSolidML": widget.tlSolidML,
        "tlFoamML": widget.tlFoamML,
        "slSolidML": widget.slSolidML,
        "slFoamML": widget.slFoamML,
        "tandSolidML": widget.tandSolidML,
        "tandFoamML": double.parse(dataML.toStringAsFixed(2)),
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
    double mlSway = double.parse(dataML.toStringAsFixed(5));
    if (context.mounted) {
      if (widget.stance == "Two Leg Stance (Solid)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              pID: widget.pID,
              thirdPartyID: widget.thirdPartyID,
              stance: "Single Leg Stance (Solid)",
              tID: widget.tID,
              tlSolidML: mlSway,
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
              pID: widget.pID,
              thirdPartyID: widget.thirdPartyID,
              stance: "Tandem Stance (Solid)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: mlSway,
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
              pID: widget.pID,
              thirdPartyID: widget.thirdPartyID,
              stance: "Two Leg Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: widget.slSolidML,
              slFoamML: widget.slFoamML,
              tandSolidML: mlSway,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Two Leg Stance (Foam)") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StaticTestPage(
              pID: widget.pID,
              thirdPartyID: widget.thirdPartyID,
              stance: "Single Leg Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: mlSway,
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
              pID: widget.pID,
              thirdPartyID: widget.thirdPartyID,
              stance: "Tandem Stance (Foam)",
              tID: widget.tID,
              tlSolidML: widget.tlSolidML,
              tlFoamML: widget.tlFoamML,
              slSolidML: widget.slSolidML,
              slFoamML: mlSway,
              tandSolidML: widget.tandSolidML,
              tandFoamML: widget.tandFoamML,
            ),
          ),
        );
      } else if (widget.stance == "Tandem Stance (Foam)") {
        Static? createdStatic = await createStaticTest(mlSway);
        if (createdStatic != null && context.mounted) {
          await sendIMU(createdStatic.sID);
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StaticResultsPage(
                  pID: widget.pID,
                  thirdPartyID: widget.thirdPartyID,
                  tID: widget.tID,
                  tlSolidML: widget.tlSolidML * 100,
                  tlFoamML: widget.tlFoamML * 100,
                  slSolidML: widget.slSolidML * 100,
                  slFoamML: widget.slFoamML * 100,
                  tandSolidML: widget.tandSolidML * 100,
                  tandFoamML: mlSway * 100,
                ),
              ),
            );
          }
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

  void restart() {
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
  }

  void skip() async {
    if (widget.stance == "Two Leg Stance (Solid)") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StaticTestPage(
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            stance: "Single Leg Stance (Solid)",
            tID: widget.tID,
            tlSolidML: widget.tlSolidML,
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
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            stance: "Tandem Stance (Solid)",
            tID: widget.tID,
            tlSolidML: widget.tlSolidML,
            tlFoamML: widget.tlFoamML,
            slSolidML: widget.slSolidML,
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
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            stance: "Two Leg Stance (Foam)",
            tID: widget.tID,
            tlSolidML: widget.tlSolidML,
            tlFoamML: widget.tlFoamML,
            slSolidML: widget.slSolidML,
            slFoamML: widget.slFoamML,
            tandSolidML: widget.tandSolidML,
            tandFoamML: widget.tandFoamML,
          ),
        ),
      );
    } else if (widget.stance == "Two Leg Stance (Foam)") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StaticTestPage(
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            stance: "Single Leg Stance (Foam)",
            tID: widget.tID,
            tlSolidML: widget.tlSolidML,
            tlFoamML: widget.tlFoamML,
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
            pID: widget.pID,
            thirdPartyID: widget.thirdPartyID,
            stance: "Tandem Stance (Foam)",
            tID: widget.tID,
            tlSolidML: widget.tlSolidML,
            tlFoamML: widget.tlFoamML,
            slSolidML: widget.slSolidML,
            slFoamML: widget.slFoamML,
            tandSolidML: widget.tandSolidML,
            tandFoamML: widget.tandFoamML,
          ),
        ),
      );
    } else if (widget.stance == "Tandem Stance (Foam)") {
      Static? createdStatic = await createStaticTest(0);
      if (createdStatic != null && context.mounted) {
        await sendIMU(createdStatic.sID);
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StaticResultsPage(
                pID: widget.pID,
                thirdPartyID: widget.thirdPartyID,
                tID: widget.tID,
                tlSolidML: widget.tlSolidML,
                tlFoamML: widget.tlFoamML,
                slSolidML: widget.slSolidML,
                slFoamML: widget.slFoamML,
                tandSolidML: widget.tandSolidML,
                tandFoamML: widget.tandFoamML,
              ),
            ),
          );
        }
      }
    }
  }

  void cancel() {
    if (timer != null) {
      timer!.cancel();
    }
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
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return MaterialApp(
      title: 'Static',
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
            'Static',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
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
                          '1. Attach phone on lumbar spine',
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
                          '3. On the start chime, take the stance denoted below',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '4. Stand for 30 seconds until you hear the end chime',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: const Text(
                          '5. Repeat for 3 stances',
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
                          widget.stance,
                          style: const TextStyle(
                            fontSize: 18,
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
                          fillColor: cs.primary.withOpacity(0.1),
                          padding: const EdgeInsets.all(87),
                          elevation: 0,
                          highlightElevation: 0,
                          child: Text(
                            'Start',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: cs.secondary,
                            ),
                          ),
                        ),
                      if (timer != null)
                        CircularCountDownTimer(
                          width: 200,
                          height: 200,
                          duration: 30,
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
