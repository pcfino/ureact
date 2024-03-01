// import 'package:capstone_project/main.dart';
import 'package:capstone_project/main.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/api/login_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _first = TextEditingController();
  final TextEditingController _last = TextEditingController();
  final TextEditingController _code = TextEditingController();

  Future<dynamic> signUp() async {
    try {
      var signedUp = await signUpUser({
        "firstName": _first.text,
        "lastName": _last.text,
        "userName": _username.text,
        "password": _password.text,
        "email": _email.text,
      });
      return signedUp;
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<dynamic> confirm() async {
    try {
      var confirmed = await confirmSignUp({
        "userName": _username.text,
        "confirmationCode": _code.text,
      });
      return confirmed;
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  void confirmationCodeAlert() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation Code'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('A confirmation code was sent to your email'),
                TextField(
                  controller: _code,
                  decoration: const InputDecoration(
                    labelText: 'Code',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Enter'),
              onPressed: () async {
                dynamic confirmed = await confirm();
                if (context.mounted && confirmed['status'] == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            Navigator.pop(context);
          }),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Sign Up',
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
                child: TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    prefixIconColor: cs.primary,
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
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: cs.primary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 10,
                      child: TextField(
                        controller: _first,
                        decoration: const InputDecoration(
                          labelText: 'First*',
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 10,
                      child: TextField(
                        controller: _last,
                        decoration: const InputDecoration(
                          labelText: 'Last*',
                        ),
                      ),
                    ),
                  ],
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
                      dynamic signedUp = await signUp();
                      if (context.mounted && signedUp['status'] == false) {
                        confirmationCodeAlert();
                      }
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ),
              const Spacer(
                flex: 7,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
