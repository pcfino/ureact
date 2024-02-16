import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/static_results_page.dart';

class StaticTestPage extends StatefulWidget {
  const StaticTestPage({
    super.key,
    required this.tID,
    required this.stance,
    required this.start,
    required this.doubleLeg,
    required this.tandem,
    required this.singleLeg,
    required this.nonDominantFoot,
  });

  final String stance;
  final String doubleLeg;
  final String tandem;
  final String singleLeg;

  final String nonDominantFoot;

  final bool start;

  final int tID;

  @override
  State<StaticTestPage> createState() => _StaticTestPage();
}

class _StaticTestPage extends State<StaticTestPage> {
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
                            onPressed: () {
                              if (widget.stance == "Single Leg Stance") {
                                if (widget.start) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StaticTestPage(
                                        stance: widget.start
                                            ? widget.stance
                                            : "Tandem Stance",
                                        tID: widget.tID,
                                        start: !widget.start,
                                        doubleLeg: widget.doubleLeg,
                                        tandem: widget.tandem,
                                        singleLeg: widget.singleLeg,
                                        nonDominantFoot: widget.nonDominantFoot,
                                      ),
                                    ),
                                  );
                                } else {
                                  double total =
                                      (double.parse(widget.doubleLeg) +
                                              double.parse(widget.tandem) +
                                              double.parse(widget.singleLeg)) /
                                          3;
                                  String totalString = total.toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StaticResultsPage(
                                        tID: widget.tID,
                                        doubleLeg: widget.doubleLeg,
                                        tandem: widget.tandem,
                                        singleLeg: widget.singleLeg,
                                        total: totalString,
                                        nonDominantFoot: widget.nonDominantFoot,
                                      ),
                                    ),
                                  );
                                }
                                // go to results
                                // double median = (double.parse(widget.trialOne) +
                                //         double.parse(widget.trialTwo) +
                                //         double.parse(widget.trialThree)) /
                                //     3;
                                // String medianString = median.toString();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => DynamicResultsPage(
                                //       trialOne: widget.trialOne,
                                //       trialTwo: widget.trialTwo,
                                //       trialThree: widget.trialThree,
                                //       average: medianString,
                                //       tID: widget.tID,
                                //     ),
                                //   ),
                                // );
                              } else if (widget.stance == "Double Leg Stance") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Tandem Stance",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      doubleLeg: widget.doubleLeg,
                                      tandem: widget.tandem,
                                      singleLeg: widget.singleLeg,
                                      nonDominantFoot: widget.nonDominantFoot,
                                    ),
                                  ),
                                );
                              } else if (widget.stance == "Tandem Stance") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StaticTestPage(
                                      stance: widget.start
                                          ? widget.stance
                                          : "Single Leg Stance",
                                      tID: widget.tID,
                                      start: !widget.start,
                                      doubleLeg: widget.doubleLeg,
                                      tandem: widget.tandem,
                                      singleLeg: widget.singleLeg,
                                      nonDominantFoot: widget.nonDominantFoot,
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
