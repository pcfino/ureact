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

  final double forward;
  final double left;
  final double right;
  final double backward;
  final double median;

  final int tID;

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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TestsPage(
                  tID: widget.tID,
                ),
              ),
            );
          }),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Administered by John Doe',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 220, 212, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: const Text(
                        'Median',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        widget.median.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 220, 212, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: const Text(
                        'Forward',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        widget.forward.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 220, 212, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: const Text(
                        'Right',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        widget.right.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 220, 212, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: const Text(
                        'Left',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        widget.left.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: const Color.fromRGBO(255, 220, 212, 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: const Text(
                        'Backward',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      trailing: Text(
                        widget.backward.toString(),
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
