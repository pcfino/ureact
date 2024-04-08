// import 'package:capstone_project/main.dart';
import 'package:capstone_project/main.dart';
import 'package:flutter/material.dart';
// import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/api/login_api.dart';
import 'package:capstone_project/slide_right_transition.dart';
import 'package:capstone_project/confirmation_code_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
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
      print(signedUp);
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
                  Navigator.pushReplacement(
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

  ColorScheme cs = ColorScheme.fromSeed(seedColor: Colors.red);
  bool hidePassword = true;
  bool hideConfirmationPassword = true;
  bool passwordsMatch = true;
  String errorMessage = "";
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Up',
      theme: ThemeData(
        colorScheme: cs,
        useMaterial3: true,
      ),
      home: GestureDetector(
        onPanUpdate: (details) {
          // Swiping in right direction.
          if (details.delta.dx > 0) {
            Navigator.pushReplacement(
              context,
              SlideRightRoute(
                page: const MyApp(),
              ),
            );
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: BackButton(onPressed: () {
              Navigator.pushReplacement(
                context,
                SlideRightRoute(
                  page: const MyApp(),
                ),
              );
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
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.email),
                      prefixIconColor: cs.primary,
                      fillColor: const Color.fromARGB(255, 240, 240, 240),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(42),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _password,
                    obscureText: hidePassword,
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
                      contentPadding: const EdgeInsets.all(42),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _confirm,
                    obscureText: hideConfirmationPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(Icons.lock),
                      prefixIconColor: cs.primary,
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (hideConfirmationPassword) {
                                hideConfirmationPassword = false;
                              } else {
                                hideConfirmationPassword = true;
                              }
                            });
                          },
                          icon: hideConfirmationPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      fillColor: const Color.fromARGB(255, 240, 240, 240),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(42),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
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
                      contentPadding: const EdgeInsets.all(42),
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.transparent,
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: TextField(
                          controller: _first,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'First',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: const Color.fromARGB(255, 240, 240, 240),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 42, 15, 42),
                          ),
                        ),
                      ),
                      const Spacer(flex: 1),
                      Expanded(
                        flex: 10,
                        child: TextField(
                          controller: _last,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            labelText: 'Last',
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            fillColor: const Color.fromARGB(255, 240, 240, 240),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(15, 42, 15, 42),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
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
                        passwordsMatch = _password.text == _confirm.text;
                        if (passwordsMatch) {
                          dynamic signedUp = await signUp();
                          if (context.mounted) {
                            if (signedUp['status'].toString().startsWith(
                                "Password did not conform with policy:")) {
                              errorMessage = signedUp['status']
                                  .toString()
                                  .substring(signedUp['status']
                                          .toString()
                                          .indexOf(':') +
                                      2);
                              error = true;
                            } else if (signedUp['status'].toString() ==
                                "Invalid email address format.") {
                              errorMessage = "Invalid email";
                              error = true;
                            } else if (signedUp['status'] == true) {
                              errorMessage =
                                  "An account with this username already exists";
                              error = true;
                            } else if (signedUp['status'] == false) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConfirmationCodePage(
                                      username: _username.text),
                                ),
                              );
                            }
                          }
                        } else {
                          errorMessage = "Passwords must match";
                          error = true;
                        }
                        setState(() {});
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
      ),
    );
  }
}
