import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:capstone_project/reactive_end_test_page.dart';
import 'package:capstone_project/tests_page.dart';

class ReactiveStartTestPage extends StatefulWidget {
  const ReactiveStartTestPage(
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

  final double forward;
  final double left;
  final double right;
  final double backward;

  final int tID;

  @override
  State<ReactiveStartTestPage> createState() => _StartTestPageState();
}

class _StartTestPageState extends State<ReactiveStartTestPage> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  void dispose() {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;

    return MaterialApp(
        title: widget.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.restart_alt),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        ReactiveStartTestPage(
                            title: widget.title,
                            direction: widget.direction,
                            forward: widget.forward,
                            left: widget.left,
                            right: widget.right,
                            backward: widget.backward,
                            tID: widget.tID),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
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
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
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
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
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
                          const Divider(
                            color: Colors.transparent,
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ReactiveEndTestPage(
                                    title: widget.title,
                                    direction: widget.direction,
                                    forward: widget.forward,
                                    left: widget.left,
                                    right: widget.right,
                                    backward: widget.backward,
                                    tID: widget.tID,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            shape: CircleBorder(
                              side: BorderSide(
                                width: 10,
                                color: cs.background,
                              ),
                            ),
                            fillColor: const Color.fromRGBO(255, 220, 212, 1),
                            padding: const EdgeInsets.all(87),
                            elevation: 0,
                            highlightElevation: 0,
                            child: const Text(
                              'Start',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                // child: Column(
                //   children: [
                //     Expanded(
                //       flex: 3,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Center(
                //             child: Text(
                //               'Directions',
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Divider(
                //               height: 1,
                //               thickness: 1,
                //               color: Colors.grey,
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '1. Attach phone to lumbar spine',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '2. Press the start button',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '3. Lean participant until you hear the chime',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '4. Hold participant steady and release after 2-5 seconds',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '5. Press the end test button once the participant has regained their balance',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //           Container(
                //             margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                //             child: const Text(
                //               '6. Repeat for each direction',
                //               style: TextStyle(fontSize: 20),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //     Expanded(
                //       flex: 2,
                //       child: Column(
                //         children: [
                //           Center(
                //             child: Text(
                //               'Lean ${widget.direction}',
                //               style: const TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //           const Divider(
                //             color: Colors.transparent,
                //           ),
                //           RawMaterialButton(
                //             onPressed: () {
                //               Navigator.pushReplacement(
                //                 context,
                //                 PageRouteBuilder(
                //                   pageBuilder: (context, animation1, animation2) =>
                //                       ReactiveEndTestPage(
                //                     title: widget.title,
                //                     direction: widget.direction,
                //                     forward: widget.forward,
                //                     left: widget.left,
                //                     right: widget.right,
                //                     backward: widget.backward,
                //                     tID: widget.tID,
                //                   ),
                //                   transitionDuration: Duration.zero,
                //                   reverseTransitionDuration: Duration.zero,
                //                 ),
                //               );
                //             },
                //             shape: CircleBorder(
                //               side: BorderSide(
                //                 width: 10,
                //                 color: cs.background,
                //               ),
                //             ),
                //             fillColor: const Color.fromRGBO(255, 220, 212, 1),
                //             padding: const EdgeInsets.all(87),
                //             elevation: 0,
                //             highlightElevation: 0,
                //             child: const Text(
                //               'Start',
                //               style: TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 fontSize: 18,
                //                 color: Colors.black54,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                ),
          ),
        ));
  }
}
