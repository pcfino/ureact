import 'package:flutter/material.dart';

class TestResultsPage extends StatefulWidget {
  const TestResultsPage({super.key, required this.accelData});

  final List<String>? accelData;

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
            ),
            body: Center(
              child: Text("Results: ${widget.accelData}"),
            )));
  }
}
