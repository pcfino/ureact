// import 'package:capstone_project/main.dart';
import 'package:capstone_project/tests_page.dart';
import 'package:capstone_project/api/test_api.dart';
import 'package:flutter/material.dart';

class StaticResultsPage extends StatefulWidget {
  const StaticResultsPage(
      {super.key,
      required this.doubleLeg,
      required this.tandem,
      required this.singleLeg,
      required this.total,
      required this.nonDominantFoot,
      required this.tID});

  final String doubleLeg;
  final String tandem;
  final String singleLeg;
  final String total;
  final String nonDominantFoot;

  final int tID;

  @override
  State<StaticResultsPage> createState() => _StaticResultsPage();
}

class _StaticResultsPage extends State<StaticResultsPage> {
  Future<dynamic> createStaticTest() async {
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
      future: createStaticTest(),
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
                          const Text('Errors',
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
                                    'Double Leg Stance',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    widget.doubleLeg,
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
                                    'Tandem',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    widget.tandem,
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
                                    'Single Leg Stance',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    widget.singleLeg,
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
                                    'Total',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.all(15.0),
                                  child: Text(
                                    widget.total,
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
