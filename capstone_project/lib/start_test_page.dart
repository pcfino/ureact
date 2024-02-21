import 'package:flutter/material.dart';
import 'package:capstone_project/end_test_page.dart';
import 'package:capstone_project/tests_page.dart';

class StartTestPage extends StatefulWidget {
  const StartTestPage(
      {super.key,
      required this.title,
      required this.direction,
      required this.forward,
      required this.left,
      required this.right,
      required this.backward,
      required this.tID});

  final String title;
  final String direction;

  final String forward;
  final String left;
  final String right;
  final String backward;

  final int tID;

  @override
  State<StartTestPage> createState() => _StartTestPageState();
}

class _StartTestPageState extends State<StartTestPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: widget.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
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
                          tID: -1,
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
                    '1. Attach phone to lumbar spine',
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
                    '3. Lean participant until you hear the chime',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '4. Hold participant steady and release after 2-5 seconds',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '5. Press the end test button once the participant has regained their balance',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: const Text(
                    '6. Repeat for each direction',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 100, 0, 5),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'Lean ${widget.direction}',
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
                              margin: const EdgeInsets.all(
                                  30), // Modify this till it fills the color properly
                              color: Colors.black54, // Color
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.play_circle_fill_rounded,
                              color: Color.fromRGBO(255, 220, 212, 1),
                              size: 75,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EndTestPage(
                                    title: 'Reactive Test',
                                    direction: widget.direction,
                                    forward: widget.forward,
                                    left: widget.left,
                                    right: widget.right,
                                    backward: widget.backward,
                                    tID: widget.tID,
                                  ),
                                ),
                              );
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
