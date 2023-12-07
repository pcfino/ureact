import 'package:flutter/material.dart';
import 'package:capstone_project/end_test_page.dart';

class StartTestPage extends StatefulWidget {
  const StartTestPage({super.key, required this.title});

  final String title;

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
          ),
          body: const Center(
              child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'Directions',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('1. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Attach phone to belt',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('2. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Position phone over participant\'s lumbar spine',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('3. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Lean participant until you hear the chime',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('4. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Hold participant steady and release after 2-5 seconds',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('5. ', style: TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      'Press the end test button once the participant has regained their balance',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
          bottomNavigationBar: BottomAppBar(
              surfaceTintColor: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EndTestPage(title: 'Reactive Test'),
                          ),
                        );
                      },
                      child: const Text('Start Test',
                          style: TextStyle(fontSize: 20))),
                ],
              )),
        ));
  }
}
