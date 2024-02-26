import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/static_results_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:capstone_project/models/static.dart';

class StaticTestPage extends StatefulWidget {
  const StaticTestPage({
    super.key,
    required this.tID,
    required this.stance,
    required this.start,
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

  final bool start;

  final int tID;

  @override
  State<StaticTestPage> createState() => _StaticTestPage();
}

class _StaticTestPage extends State<StaticTestPage> {
  Future<dynamic> createStaticTest() async {
    try {
      dynamic jsonStatic = await createStatic({
        "tlSolidML": widget.tlSolidML,
        "tlFoamML": widget.slFoamML,
        "slSolidML": widget.slSolidML,
        "slFoamML": widget.slFoamML,
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Static',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Static'),
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
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 5),
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
                              if (widget.stance == "Single Leg Stance (Foam)") {
                                if (widget.start) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StaticTestPage(
                                        stance: widget.stance,
                                        tID: widget.tID,
                                        start: !widget.start,
                                        tlSolidML: widget.tlSolidML,
                                        tlFoamML: widget.tlFoamML,
                                        slSolidML: widget.slSolidML,
                                        slFoamML: widget.slFoamML,
                                        tandSolidML: widget.tandSolidML,
                                        tandFoamML: widget.tandFoamML,
                                      ),
                                    ),
                                  );
                                } else {
                                  Static? createdStatic =
                                      await createStaticTest();
                                  if (createdStatic != null &&
                                      context.mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StaticResultsPage(
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
                              } else if (widget.stance ==
                                  "Two Leg Stance (Solid)") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Two Leg Stance (Foam)",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      tlSolidML: widget.tlSolidML,
                                      tlFoamML: widget.tlFoamML,
                                      slSolidML: widget.slSolidML,
                                      slFoamML: widget.slFoamML,
                                      tandSolidML: widget.tandSolidML,
                                      tandFoamML: widget.tandFoamML,
                                    ),
                                  ),
                                );
                              } else if (widget.stance ==
                                  "Two Leg Stance (Foam)") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Tandem Stance (Solid)",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      tlSolidML: widget.tlSolidML,
                                      tlFoamML: widget.tlFoamML,
                                      slSolidML: widget.slSolidML,
                                      slFoamML: widget.slFoamML,
                                      tandSolidML: widget.tandSolidML,
                                      tandFoamML: widget.tandFoamML,
                                    ),
                                  ),
                                );
                              } else if (widget.stance ==
                                  "Tandem Stance (Solid)") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Tandem Stance (Foam)",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      tlSolidML: widget.tlSolidML,
                                      tlFoamML: widget.tlFoamML,
                                      slSolidML: widget.slSolidML,
                                      slFoamML: widget.slFoamML,
                                      tandSolidML: widget.tandSolidML,
                                      tandFoamML: widget.tandFoamML,
                                    ),
                                  ),
                                );
                              } else if (widget.stance ==
                                  "Tandem Stance (Foam)") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Single Leg Stance (Solid)",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      tlSolidML: widget.tlSolidML,
                                      tlFoamML: widget.tlFoamML,
                                      slSolidML: widget.slSolidML,
                                      slFoamML: widget.slFoamML,
                                      tandSolidML: widget.tandSolidML,
                                      tandFoamML: widget.tandFoamML,
                                    ),
                                  ),
                                );
                              } else if (widget.stance ==
                                  "Single Leg Stance (Solid)") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Single Leg Stance (Foam)",
                                      tID: widget.tID,
                                      start: !widget.start,
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
