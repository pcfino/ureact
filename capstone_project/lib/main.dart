import 'package:flutter/material.dart';
import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/sign_up_page.dart';
import 'package:capstone_project/api/login_api.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    String defaultValue = "University of Utah";
    ColorScheme cs = Theme.of(context).colorScheme;
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Institution",
                    contentPadding: EdgeInsets.all(11),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    prefixIconColor: cs.primary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  obscureText: true,
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: cs.primary,
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
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
                      if (context.mounted && loggedIn['status'] != 'error') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
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
              Navigator.push(
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
