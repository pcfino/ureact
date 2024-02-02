import 'package:capstone_project/main.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
          leading: BackButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp(),
              ),
            );
          }),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                      child: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.black,
                        size: 100.0,
                      ),
                    ),
                  ],
                ),
                const Row(children: [
                  Expanded(
                    child: Text(
                      "James Smith",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "jamessmith@email.com",
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SwitchListTile(
                        title: const Text("Dark Mode"),
                        shape: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        value: darkMode,
                        onChanged: (bool value) {
                          setState(() {
                            darkMode = value;
                          });
                        },
                      ),
                      const ListTile(
                        title: Text("Sign Out"),
                      ),
                    ],
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
