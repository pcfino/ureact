// import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:flutter/material.dart';

class DynamicResultsPage extends StatefulWidget {
  const DynamicResultsPage({
    super.key,
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
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Test Results',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Test Results'),
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
                  child: const Text('Next'),
                )
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Time to Complete Tandem Gait',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Card(
                      color: const Color.fromRGBO(255, 220, 212, 1),
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Average',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Text(
                              '${widget.dMean}s',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: const Color.fromRGBO(255, 220, 212, 1),
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Trial 1',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Text(
                              '${widget.t1Duration}s',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          //Text(widget.timeToStab)
                        ],
                      ),
                    ),
                    Card(
                      color: const Color.fromRGBO(255, 220, 212, 1),
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Trial 2',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Text(
                              '${widget.t2Duration}s',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          //Text(widget.timeToStab)
                        ],
                      ),
                    ),
                    Card(
                      color: const Color.fromRGBO(255, 220, 212, 1),
                      shadowColor: Colors.black,
                      margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              'Trial 3',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: Text(
                              '${widget.t3Duration}s',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          //Text(widget.timeToStab)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
