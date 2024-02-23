import 'package:flutter/material.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/dynamic_results_page.dart';

class DynamicTestPage extends StatefulWidget {
  const DynamicTestPage({
    super.key,
    required this.tID,
    required this.trialNumber,
    required this.start,
    required this.trialOne,
    required this.trialTwo,
    required this.trialThree,
  });

  final int trialNumber;
  final bool start;
  final String trialOne;
  final String trialTwo;
  final String trialThree;

  final int tID;

  @override
  State<DynamicTestPage> createState() => _DynamicTestPage();
}

class _DynamicTestPage extends State<DynamicTestPage> {
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
                            onPressed: () {
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
                                          trialOne: widget.trialOne,
                                          trialTwo: widget.trialTwo,
                                          trialThree: widget.trialThree),
                                    ),
                                  );
                                } else {
                                  double median =
                                      (double.parse(widget.trialOne) +
                                              double.parse(widget.trialTwo) +
                                              double.parse(widget.trialThree)) /
                                          3;
                                  String medianString = median.toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DynamicResultsPage(
                                        trialOne: widget.trialOne,
                                        trialTwo: widget.trialTwo,
                                        trialThree: widget.trialThree,
                                        average: medianString,
                                        tID: widget.tID,
                                      ),
                                    ),
                                  );
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
                                        trialOne: widget.trialOne,
                                        trialTwo: widget.trialTwo,
                                        trialThree: widget.trialThree),
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
