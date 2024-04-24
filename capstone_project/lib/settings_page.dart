import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/main.dart';
import 'package:capstone_project/slide_right_transition.dart';
import 'package:flutter/material.dart';
import 'package:session_manager/session_manager.dart';
import 'package:capstone_project/api/login_api.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  bool darkMode = false;

  Future<dynamic> signOutUser() async {
    try {
      String token = await SessionManager().getString("token");
      var message = {"AccessToken": token};
      var confirmed = await signOut(message);
      return confirmed;
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SessionManager().getString("username"),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          String username = snapshot.data;
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
                  Navigator.pushReplacement(
                    context,
                    SlideRightRoute(
                      page: const HomePage(),
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
                      Row(children: [
                        Expanded(
                          child: Text(
                            username,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ]),
                      Expanded(
                        child: ListView(
                          children: [
                            ListTile(
                              title: const Text("Sign Out"),
                              onTap: () async {
                                dynamic signedOut = await signOutUser();
                                if (signedOut['status'] != false ||
                                    signedOut['status'] != null) {
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      SlideRightRoute(
                                        page: const MyApp(),
                                      ),
                                    );
                                  }
                                }
                              },
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
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Text('Error: ${snapshot.error}');
        }
      },
    );
  }
}
