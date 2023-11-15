import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// *******************************************************************************************
// START
// ignore: non_constant_identifier_names
String IOS_URL = 'http://127.0.0.1:5000/';
// ignore: non_constant_identifier_names
String ANDROID_URL = 'http://10.0.2.2:5000/';
// ignore: non_constant_identifier_names
String VERSION_URL = ANDROID_URL;

// these methods send/issue get and post requests to the python server
Future getData(url) async {
  var url2 = Uri.parse(url);
  Response response = await get(url2);
  return response.body;
}

Future sendData(int newNum) async {
  final response = await post(
    // ignore: prefer_interpolation_to_compose_strings
    Uri.parse(VERSION_URL + 'postData'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'counter': newNum}),
  );

  return response.body;
}
// END
// *******************************************************************************************

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patients',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patients'),
        ),
        body: ElevatedButton(
          child: const Text('Patient'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PatientPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PatientPage extends StatelessWidget {
  const PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Patient'),
        ),
        body: ElevatedButton(
          child: const Text('Incident'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const IncidentPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class IncidentPage extends StatelessWidget {
  const IncidentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Incident',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Incident'),
        ),
        body: ElevatedButton(
          child: const Text('Run Test'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RunTestPage(title: 'Run Test'),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RunTestPage extends StatefulWidget {
  const RunTestPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<RunTestPage> createState() => _RunTestPageState();
}

class _RunTestPageState extends State<RunTestPage> {
  // *******************************************************************************************
  // START
  String result = "0";
  int startUp = 0;

  void sendANumber() async {
    await sendData(49);
    // ignore: prefer_interpolation_to_compose_strings
    var data = await getData(VERSION_URL + 'current');
    var decodedData = jsonDecode(data);
    setState(() {
      result = decodedData['counter'].toString();
    });
  }

  void onLoadApp() async {
    var data = await getData(VERSION_URL);
    var decodedData = jsonDecode(data);
    setState(() {
      result = decodedData['counter'].toString();
    });
  }

  void _incrementCounter() async {
    // ignore: prefer_interpolation_to_compose_strings
    var data = await getData(VERSION_URL + 'incre');
    var decodedData = jsonDecode(data);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      result = decodedData['counter'].toString();
    });
  }

  void _resetToZero() async {
    // ignore: prefer_interpolation_to_compose_strings
    var data = await getData(VERSION_URL + 'zero');
    var decodedData = jsonDecode(data);
    setState(() {
      result = decodedData['counter'].toString();
    });
  }
  // END
  // *******************************************************************************************

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (startUp == 0) {
      onLoadApp();
      startUp++;
    }
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              result,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
      //here is my back arrow outlined button
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // *******************************************************************************************
          // START
          // here there are three buttons. When pressed, they call these methods
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            backgroundColor: Colors.purple,
            foregroundColor: Colors.black,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16.0),
          FloatingActionButton(
            onPressed: _resetToZero,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
          FloatingActionButton(
            onPressed: sendANumber,
            backgroundColor: Colors.green,
            foregroundColor: Colors.yellow,
            child: const Icon(Icons.arrow_circle_right_outlined),
          ),
          // END
          // *******************************************************************************************
        ],
      ),
    );
  }
}
