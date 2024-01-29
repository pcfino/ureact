import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:flutter/material.dart';

class TestResultsPage extends StatefulWidget {
  const TestResultsPage({super.key, required this.timeToStab});

  final String timeToStab;

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
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
                        builder: (context) => const TestsPage(
                            reactive: true, dynamic: false, static: false),
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
                    const Text('Time To Stability',
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
                            child: const Text(
                              '0',
                              style: TextStyle(
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
                              'Forwards',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              '0',
                              style: TextStyle(
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
                              'Right',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              '0',
                              style: TextStyle(
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
                              'Left',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              '0',
                              style: TextStyle(
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
                              'Backwards',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(15.0),
                            child: const Text(
                              '0',
                              style: TextStyle(
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
