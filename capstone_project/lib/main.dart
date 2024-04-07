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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> institutions = [
      const DropdownMenuItem(
        value: "University of Utah",
        child: Text(
          "University of Utah",
        ),
      ),
    ];
    return institutions;
  }

  bool hidePassword = true;
  ColorScheme cs = ColorScheme.fromSeed(seedColor: Colors.red);
  String errorMessage = "";
  bool error = false;

  @override
  Widget build(BuildContext context) {
    String defaultValue = "University of Utah";
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
                  items: dropdownItems,
                  onChanged: (value) {
                    defaultValue = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      //borderSide: BorderSide.none,
                    ),
                    labelText: "Institution",
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
  }
}
