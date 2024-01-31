// import 'package:capstone_project/main.dart';
import 'package:capstone_project/start_test_page.dart';
import 'package:flutter/material.dart';

class TestsPage extends StatefulWidget {
  const TestsPage(
      {super.key,
      required this.reactive,
      required this.dynamic,
      required this.static});

  final bool reactive;
  final bool dynamic;
  final bool static;

  @override
  State<TestsPage> createState() => _TestsPage();
}

class _TestsPage extends State<TestsPage> {
  @override
  Widget build(BuildContext context) {
    bool reactiveTile = false;

    return MaterialApp(
      title: 'Tests',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tests'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'May 5, 2023',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey,
              ),
              if (widget.reactive)
                ExpansionTile(
                  title: const Text(
                    'Reactive',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    reactiveTile
                        ? Icons.arrow_drop_down_circle
                        : Icons.arrow_drop_down_circle,
                  ),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      reactiveTile = expanded;
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const StartTestPage(
                      //       title: 'Reactive',
                      //       direction: 'Forward',
                      //     ),
                      //   ),
                      // );
                    });
                  },
                  children: const [
                    ListTile(
                      title: Text('Average', style: TextStyle(fontSize: 16)),
                      trailing: Text('0', style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      title: Text('Forward', style: TextStyle(fontSize: 16)),
                      trailing: Text('0', style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      title: Text('Right', style: TextStyle(fontSize: 16)),
                      trailing: Text('0', style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      title: Text('Left', style: TextStyle(fontSize: 16)),
                      trailing: Text('0', style: TextStyle(fontSize: 16)),
                    ),
                    ListTile(
                      title: Text('Backward', style: TextStyle(fontSize: 16)),
                      trailing: Text('0', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              if (!widget.reactive)
                ExpansionTile(
                  title: const Text(
                    'Reactive',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.play_arrow_rounded),
                  onExpansionChanged: (bool expanded) {
                    setState(() {
                      if (!widget.reactive) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StartTestPage(
                              title: 'Reactive',
                              direction: 'Forward',
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
              // const Divider(
              //   height: 1,
              //   thickness: 1,
              //   color: Colors.grey,
              // ),
              ExpansionTile(
                title: const Text(
                  'Dynamic',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.play_arrow_rounded),
                onExpansionChanged: (bool? value) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartTestPage(
                          title: 'Dynamic',
                          direction: 'Forward',
                        ),
                      ),
                    );
                  });
                },
              ),
              // const Divider(
              //   height: 1,
              //   thickness: 1,
              //   color: Colors.grey,
              // ),
              ExpansionTile(
                title: const Text(
                  'Static',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.play_arrow_rounded),
                onExpansionChanged: (bool? value) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartTestPage(
                          title: 'Static',
                          direction: 'Forward',
                        ),
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
