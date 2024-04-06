import 'package:capstone_project/main.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/home_page.dart';
import 'package:capstone_project/api/login_api.dart';
import 'package:capstone_project/slide_right_transition.dart';
import 'package:flutter/services.dart';

class ConfirmationCodePage extends StatefulWidget {
  const ConfirmationCodePage({
    super.key,
    required this.username,
  });

  final String username;

  @override
  State<ConfirmationCodePage> createState() => _ConfirmationCodePage();
}

class _ConfirmationCodePage extends State<ConfirmationCodePage> {
  ColorScheme cs = ColorScheme.fromSeed(seedColor: Colors.red);
  FocusNode one = FocusNode();
  FocusNode two = FocusNode();
  FocusNode three = FocusNode();
  FocusNode four = FocusNode();
  FocusNode five = FocusNode();
  FocusNode six = FocusNode();
  FocusNode btn = FocusNode();

  final TextEditingController _controllerOne = TextEditingController();
  final TextEditingController _controllerTwo = TextEditingController();
  final TextEditingController _controllerThree = TextEditingController();
  final TextEditingController _controllerFour = TextEditingController();
  final TextEditingController _controllerFive = TextEditingController();
  final TextEditingController _controllerSix = TextEditingController();

  Future<dynamic> confirm() async {
    try {
      String code = _controllerOne.text +
          _controllerTwo.text +
          _controllerThree.text +
          _controllerFour.text +
          _controllerFive.text +
          _controllerSix.text;
      var confirmed = await confirmSignUp({
        "userName": widget.username,
        "confirmationCode": code,
      });
      return confirmed;
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  void enter() async {
    dynamic confirmed = await confirm();
    if (context.mounted && confirmed['status'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyApp(),
        ),
      );
    } else {
      error = true;
      errorMessage = "Incorrect code or email is already in use";
      setState(() {});
    }
  }

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
      home: Scaffold(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter Code",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const Text(
                  "A verification code was sent to your email",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerOne,
                        autofocus: true,
                        focusNode: one,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(one);
                          _controllerOne.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controllerOne.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerOne.text = value.substring(1);
                            } else {
                              _controllerOne.text = value;
                            }
                          });
                          if (_controllerOne.text != "" &&
                              _controllerTwo.text == "") {
                            FocusScope.of(context).requestFocus(two);
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerTwo,
                        focusNode: two,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(two);
                          _controllerTwo.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controllerTwo.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerTwo.text = value.substring(1);
                            } else {
                              _controllerTwo.text = value;
                            }
                          });
                          if (_controllerTwo.text != "" &&
                              _controllerThree.text == "") {
                            FocusScope.of(context).requestFocus(three);
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerThree,
                        focusNode: three,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(three);
                          _controllerThree.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _controllerThree.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerThree.text = value.substring(1);
                            } else {
                              _controllerThree.text = value;
                            }
                          });
                          if (_controllerThree.text != "" &&
                              _controllerFour.text == "") {
                            FocusScope.of(context).requestFocus(four);
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerFour,
                        focusNode: four,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(four);
                          _controllerFour.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _controllerFour.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerFour.text = value.substring(1);
                            } else {
                              _controllerFour.text = value;
                            }
                          });
                          if (_controllerFour.text != "" &&
                              _controllerFive.text == "") {
                            FocusScope.of(context).requestFocus(five);
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerFive,
                        focusNode: five,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(five);
                          _controllerFive.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _controllerFive.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerFive.text = value.substring(1);
                            } else {
                              _controllerFive.text = value;
                            }
                          });
                          if (_controllerFive.text != "" &&
                              _controllerSix.text == "") {
                            FocusScope.of(context).requestFocus(six);
                          }
                        },
                      ),
                    ),
                    const Spacer(flex: 1),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _controllerSix,
                        focusNode: six,
                        textAlign: TextAlign.center,
                        showCursor: false,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onTap: () {
                          FocusScope.of(context).requestFocus(six);
                          _controllerSix.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controllerSix.text.length));
                        },
                        onChanged: (value) {
                          setState(() {
                            if (value.length > 1) {
                              _controllerSix.text = value.substring(1);
                            } else {
                              _controllerSix.text = value;
                            }
                          });
                          if (_controllerSix.text != "") {
                            FocusScope.of(context).requestFocus(btn);
                            enter();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 75,
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Text(
                      errorMessage,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: error ? Colors.red : Colors.transparent),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 75,
                  child: ElevatedButton(
                    focusNode: btn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.background,
                    ),
                    onPressed: () async {
                      enter();
                    },
                    child: const Text('Enter'),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
