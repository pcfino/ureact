// import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:flutter/material.dart';

class TestResultsPage extends StatefulWidget {
  const TestResultsPage(
      {super.key,
      required this.forward,
      required this.left,
      required this.right,
      required this.backward,
      required this.median,
      required this.tID});

  final String forward;
  final String left;
  final String right;
  final String backward;
  final String median;

  final int tID;

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  Future<dynamic> createReactiveTest() async {
    try {
      return await createReactive({
        "fTime": widget.forward,
        "rTime": widget.right,
        "lTime": widget.left,
        "bTime": widget.backward,
        "mTime": widget.median,
        "tID": widget.tID,
      });
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createReactiveTest(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                                  child: Text(
                                    '${widget.median}s',
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
                                    'Forward',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.forward}s',
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
                                    'Right',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.right}s',
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
                                    'Left',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.left}s',
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
                                    "Backward",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.backward}s',
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }
}
