// import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:flutter/material.dart';

class DynamicResultsPage extends StatefulWidget {
  const DynamicResultsPage(
      {super.key,
      required this.trialOne,
      required this.trialTwo,
      required this.trialThree,
      required this.average,
      required this.tID});

  final String trialOne;
  final String trialTwo;
  final String trialThree;
  final String average;

  final int tID;

  @override
  State<DynamicResultsPage> createState() => _DynamicResultsPage();
}

class _DynamicResultsPage extends State<DynamicResultsPage> {
  Future<dynamic> createDynamicTest() async {
    try {
      // create dynamic
      // return await createReactive({
      //   "fTime": widget.forward,
      //   "rTime": widget.right,
      //   "lTime": widget.left,
      //   "bTime": widget.backward,
      //   "mTime": median,
      //   "tID": widget.tID,
      // });
      return 1;
    } catch (e) {
      print("Error creating reactive test: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: createDynamicTest(),
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
                                    '${widget.average}s',
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
                                    'Trial 1',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.trialOne}s',
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.trialTwo}s',
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    '${widget.trialThree}s',
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
