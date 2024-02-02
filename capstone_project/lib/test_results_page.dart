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
      required this.tID});

  final String forward;
  final String left;
  final String right;
  final String backward;

  final int tID;

  @override
  State<TestResultsPage> createState() => _TestResultsPageState();
}

class _TestResultsPageState extends State<TestResultsPage> {
  Future<dynamic> createReactiveTest(String median) async {
    try {
      return await createReactive({
        "fTime": widget.forward,
        "rTime": widget.right,
        "lTime": widget.left,
        "bTime": widget.backward,
        "mTime": median,
        "tID": widget.tID,
      });
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double median = (double.parse(widget.forward) +
            double.parse(widget.left) +
            double.parse(widget.right) +
            double.parse(widget.backward)) /
        4;
    String medianString = median.toString();

    return FutureBuilder(
      future: createReactiveTest(medianString),
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
                                    medianString,
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
                                    widget.forward,
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
                                    widget.right,
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
                                    widget.left,
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
                                    widget.backward,
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
          return const SizedBox(
            width: 30.0,
            height: 30.0,
            child: Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.red,
                  strokeAlign: 0.0),
            ),
          ); // or any other loading indicator
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }
}
