// import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/slide_right_transition.dart';

class DynamicResultsPage extends StatefulWidget {
  const DynamicResultsPage({
    super.key,
    required this.pID,
    required this.administeredBy,
    required this.t1Duration,
    required this.t1TurnSpeed,
    required this.t1MLSway,
    required this.t2Duration,
    required this.t2TurnSpeed,
    required this.t2MLSway,
    required this.t3Duration,
    required this.t3TurnSpeed,
    required this.t3MLSway,
    required this.dMin,
    required this.dMean,
    required this.dMedian,
    required this.tsMax,
    required this.tsMin,
    required this.tsMean,
    required this.dMax,
    required this.tsMedian,
    required this.mlMax,
    required this.mlMin,
    required this.mlMean,
    required this.mlMedian,
    required this.tID,
  });

  final int pID;
  final String administeredBy;
  final double t1Duration;
  final double t1TurnSpeed;
  final double t1MLSway;
  final double t2Duration;
  final double t2TurnSpeed;
  final double t2MLSway;
  final double t3Duration;
  final double t3TurnSpeed;
  final double t3MLSway;
  final double dMax;
  final double dMin;
  final double dMean;
  final double dMedian;
  final double tsMax;
  final double tsMin;
  final double tsMean;
  final double tsMedian;
  final double mlMax;
  final double mlMin;
  final double mlMean;
  final double mlMedian;

  final int tID;

  @override
  State<DynamicResultsPage> createState() => _DynamicResultsPage();
}

class _DynamicResultsPage extends State<DynamicResultsPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return MaterialApp(
        title: 'Test Results',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
          dividerColor: Colors.transparent,
          highlightColor: Colors.white,
        ),
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Test Results'),
              centerTitle: true,
              leading: BackButton(onPressed: () {
                Navigator.pushReplacement(
                  context,
                  SlideRightRoute(
                    page: TestsPage(tID: widget.tID, pID: widget.pID),
                  ),
                );
              }),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Administered by ${widget.administeredBy}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.transparent,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Summary",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Max",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Min",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Mean",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Median",
                                    textAlign: TextAlign.center,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 0.8,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Duration (s)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.dMax.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.dMin.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.dMean.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.dMedian.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Turn Speed (deg/s)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.tsMax.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.tsMin.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.tsMean.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.tsMedian.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    "ML Sway (cm/s\u00B2)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.mlMax.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.mlMin.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.mlMean.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    widget.mlMedian.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.5,
                        color: Colors.transparent,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color.fromRGBO(255, 220, 212, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ExpansionTile(
                            title: const Text(
                              'Trial 1',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            children: [
                              ListTile(
                                title: const Text('Duration (s)'),
                                trailing: Text(
                                  widget.t1Duration.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text('Turn Speed (deg/s)'),
                                trailing: Text(
                                  widget.t1TurnSpeed.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'ML Sway (cm/s\u00B2)',
                                ),
                                trailing: Text(
                                  widget.t1MLSway.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color.fromRGBO(255, 220, 212, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ExpansionTile(
                            title: const Text(
                              'Trial 2',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            children: [
                              ListTile(
                                title: const Text('Duration (s)'),
                                trailing: Text(
                                  widget.t2Duration.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text('Turn Speed (deg/s)'),
                                trailing: Text(
                                  widget.t2TurnSpeed.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'ML Sway (cm/s\u00B2)',
                                ),
                                trailing: Text(
                                  widget.t2MLSway.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.transparent,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: const Color.fromRGBO(255, 220, 212, 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: ExpansionTile(
                            title: const Text(
                              'Trial 3',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            children: [
                              ListTile(
                                title: const Text('Duration (s)'),
                                trailing: Text(
                                  widget.t3Duration.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text('Turn Speed (deg/s)'),
                                trailing: Text(
                                  widget.t3TurnSpeed.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              ListTile(
                                title: const Text(
                                  'ML Sway (cm/s\u00B2)',
                                ),
                                trailing: Text(
                                  widget.t3MLSway.toString(),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
