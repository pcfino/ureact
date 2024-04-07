import 'package:flutter/material.dart';
import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/sign_up_page.dart';
import 'package:capstone_project/api/login_api.dart';

void main() => runApp(const MaterialApp(
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => App();
}

class App extends State<MyApp> {
  late Future<dynamic> future;

  @override
  void initState() {
    super.initState();
    future = getGroups();
  }

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<dynamic> logInUser() async {
    try {
      var confirmed = await logIn({
        "userName": _username.text,
        "password": _password.text,
      });
      return confirmed;
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<dynamic> getGroups() async {
    try {
      List<dynamic> jsonGroupList = await getOrgNames() as List;
      List<String> groupNames = List.empty(growable: true);
      for (var group in jsonGroupList) {
        groupNames.add(group["orgName"]);
      }
      return groupNames;
    } catch (e) {
      print("Error fetching patients: $e");
    }
  }

  List<DropdownMenuItem<String>> getDropdownItems(List<String> groupNames) {
    List<DropdownMenuItem<String>> dropdownGroups = List.empty(growable: true);
    for (String groupName in groupNames) {
      dropdownGroups.add(
        DropdownMenuItem(
          value: groupName,
          child: Text(
            groupName,
          ),
        ),
      );
    }
    return dropdownGroups;
  }

  bool hidePassword = true;
  ColorScheme cs = ColorScheme.fromSeed(seedColor: Colors.red);
  String errorMessage = "";
  bool error = false;

  List<String>? groups;

  @override
  Widget build(BuildContext context) {
    String defaultValue = "Test Organization";
    return FutureBuilder(
      future: future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        groups = snapshot.data! as List<String>;
        //print(groups);
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Login',
            theme: ThemeData(
              colorScheme: cs,
              useMaterial3: true,
            ),
            home: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Expanded(
                      flex: 2,
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ImageIcon(
                        const AssetImage("assets/images/app_icon.png"),
                        size: 75,
                        color: cs.primary,
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField(
                        value: defaultValue,
                        items: getDropdownItems(groups!),
                        onChanged: (value) {
                          defaultValue = value!;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            //borderSide: BorderSide.none,
                          ),
                          labelText: "Group",
                          contentPadding: const EdgeInsets.all(11),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _username,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: const Icon(Icons.person),
                          prefixIconColor: cs.primary,
                          fillColor: const Color.fromARGB(255, 240, 240, 240),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(45),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        obscureText: hidePassword,
                        controller: _password,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: cs.primary,
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (hidePassword) {
                                    hidePassword = false;
                                  } else {
                                    hidePassword = true;
                                  }
                                });
                              },
                              icon: hidePassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          fillColor: const Color.fromARGB(255, 240, 240, 240),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.all(45),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          errorMessage,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: error ? Colors.red : Colors.transparent),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: cs.background,
                          ),
                          onPressed: () async {
                            dynamic loggedIn = await logInUser();
                            if (context.mounted) {
                              if (loggedIn['status'] != 'error') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              } else {
                                errorMessage = "Incorrect username or password";
                                error = true;
                                setState(() {});
                              }
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.blueGrey,
                        ),
                        onPressed: () {},
                        child: const Text("Forgot password?"),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomAppBar(
                surfaceTintColor: cs.background,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Sign Up"),
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
