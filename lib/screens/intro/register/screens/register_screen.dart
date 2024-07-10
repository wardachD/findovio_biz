import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findovio_business/routes/app_pages.dart';
import 'package:findovio_business/screens/intro/register/screens/widgets/popup_private_data.dart';
import 'package:findovio_business/screens/intro/register/screens/widgets/profile_widgets.dart';
import 'package:findovio_business/utilities/authentication/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:passwordfield/passwordfield.dart';

import '../../../../models/license_model.dart';

class RegisterScreen extends StatefulWidget {
  final String name;
  final String email;

  const RegisterScreen({super.key, required this.name, required this.email});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  final bool _highlightGDPR = false;
  bool _highlightTerms = false;
  bool enableSocialButton = false;
  bool goNext = false;
  final RegExp regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  User? user;
  String? res;
  String? resPy;
  String passwordErrorCodes = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final keyboardHeight = WidgetsBinding.instance.window.viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    if (_isKeyboardVisible != isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }
  }

  int countSpecialCharacters(String input, bool countDigits) {
    RegExp digitRegex = RegExp(r'\d');
    RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    Iterable<RegExpMatch> matches;

    if (countDigits) {
      matches = digitRegex.allMatches(input);
    } else {
      matches = specialCharRegex.allMatches(input);
    }

    return matches.length;
  }

  List<String> errorCodes = [
    'Hasło powinno jeszcze zawierać:\n',
    'Minimum 8 znaków\n',
    '1 Wielką literę (A)\n',
    '1 Małą literę (a)\n',
    '1 Cyfrę (1)\n',
    '1 Znak specjalny (#)\n',
  ];

  String buildErrorMessage(String password) {
    if (password.isEmpty) {
      return errorCodes.join();
    }

    List<String> errors = List.from(errorCodes);

    if (password.length >= 8) {
      errors.remove('Minimum 8 znaków\n');
    }
    if (password.contains(RegExp(r'[A-Z]'))) {
      errors.remove('1 Wielką literę (A)\n');
    }
    if (password.contains(RegExp(r'[a-z]'))) {
      errors.remove('1 Małą literę (a)\n');
    }
    if (password.contains(RegExp(r'[0-9]'))) {
      errors.remove('1 Cyfrę (1)\n');
    }
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.remove('1 Znak specjalny (#)\n');
    }

    return errors.join();
  }

  void isPasswordValid() {
    RegExp passwordRegex = RegExp(r'^.{10,}$');
    String password = _passwordController.value.text;
    bool hasMinimumLength = passwordRegex.hasMatch(password);

    if (hasMinimumLength) {
      passValidator = true;
    }
    if (!hasMinimumLength) {
      passValidator = false;
    }
  }

  // Use this form key to validate user's input
  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  final _firestore = FirebaseFirestore.instance;

  // Use this to store user inputs
  bool passValidator = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var isCheckedTerms = false;
  var isCheckedGDPR = false;

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible ? 60.0 : 150.0;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/images/findovio_business_logo_full.svg',
                    fit: BoxFit.fitHeight,
                    height: MediaQuery.sizeOf(context).width *
                        0.15, // Adjust height as needed
                  ),
                ),
                AnimatedPadding(
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeIn,
                  padding: EdgeInsets.fromLTRB(25, topMargin, 25, 25),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                        child: GestureDetector(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Row(
                              children: [
                                Icon(Icons.arrow_back),
                                Text(
                                  'Cofnij',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      /// Title
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: const Text(
                          'Wprowadź hasło',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),

                      /// Zaakceptuj też regulamin i politykę prywatności.
                      const Text(
                        'Zapoznaj się z regulaminem i polityką prywatności.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 73, 73, 73),
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 22.0),

                      /// Hasło
                      PasswordField(
                        key: formKeys[0],
                        controller: _passwordController,
                        onChanged: (_) => {
                          setState(() {
                            isPasswordValid();
                          })
                        },
                        color: Colors.blue,
                        passwordConstraint: r'^.{10,}$',
                        hintText: 'Hasło',
                        border: PasswordBorder(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade100,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blue.shade100,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                width: 2, color: Colors.red.shade200),
                          ),
                        ),
                        errorMessage: '''
                        Hasło musi zawierać minimum 10 znaków
                         ''',
                      ),

                      /// Terms and conditions
                      const SizedBox(
                        height: 12,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Akceptuję warunki korzystania z Findovio',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: _highlightTerms
                                            ? Colors.red
                                            : const Color.fromARGB(
                                                255, 53, 53, 53)),
                                  ),
                                  Container(
                                    decoration: _highlightTerms
                                        ? BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color.fromARGB(
                                                        255, 250, 195, 143)
                                                    .withOpacity(0.5),
                                                spreadRadius: 4,
                                                blurRadius: 12,
                                              ),
                                            ],
                                          )
                                        : null,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                        side: _highlightTerms
                                            ? const BorderSide(
                                                color: Colors.orangeAccent,
                                                width: 2)
                                            : null,
                                        fillColor: _highlightTerms
                                            ? const MaterialStatePropertyAll(
                                                Colors.white)
                                            : null,
                                        key: formKeys[2],
                                        value: isCheckedTerms,
                                        onChanged: (value) => {
                                          setState(() {
                                            isCheckedTerms = value!;
                                            if (isCheckedTerms) {
                                              enableSocialButton = true;
                                              _highlightTerms = false;
                                            } else {
                                              enableSocialButton = false;
                                              _highlightTerms = true;
                                            }
                                          })
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showUserProfileOptions(context, 'Regulamin');
                                },
                                child: const Text(
                                  'Regulamin Findovio',
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aby dowiedzieć się więcej o tym, jak Findovio gromadzi, wykorzystuje, udostępnia i chroni Twoje dane osobowe, zapoznaj się z Polityką prywatności Findovio.',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _highlightGDPR
                                        ? Colors.red
                                        : const Color.fromARGB(
                                            255, 53, 53, 53)),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  showUserProfileOptions(
                                      context, 'Polityka prywatności');
                                },
                                child: const Text(
                                  'Polityka prywatności Findovio',
                                  style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),

                      /// Button
                      GestureDetector(
                        onTap: () async {
                          if (isCheckedTerms && passValidator) {
                            ProfileWidgets.showDialogLoading(context);
                            FocusManager.instance.primaryFocus?.unfocus();
                            final FirebaseAuth auth = FirebaseAuth.instance;
                            try {} catch (e) {}
                            res = await Auth.registerWithEmailAndPassword(
                                widget.email, _passwordController.value.text);
                            if (res == null) {
                              user = auth.currentUser;
                              auth.currentUser?.updateDisplayName(widget.name);
                              try {
                                LicenseModel newUserLicense = LicenseModel(
                                    username: user?.uid ?? 'error',
                                    kindOfLicense: 1,
                                    planType: 0,
                                    isActive: true);
                              } catch (e) {}
                            }
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      res == null ? Colors.green : Colors.red,
                                  content: res == null
                                      ? const Text("Zostałeś Zarejestrowany!")
                                      : const Text("Coś poszło nie tak!"),
                                ),
                              );
                            }

                            if (res == null) {
                              Get.offAllNamed(Routes.HOME);
                            } else {
                              if (mounted) {
                                _passwordController.text = '';
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            }
                          } else if (!isCheckedTerms) {
                            setState(() {
                              _highlightTerms = true;
                            });
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: isCheckedTerms && passValidator
                                    ? Colors.transparent
                                    : Colors.black),
                            color: isCheckedTerms && passValidator
                                ? Colors.orange
                                : Colors.white,
                          ),
                          child: Text(
                            'Zarejestruj',
                            style: TextStyle(
                              color: isCheckedTerms && passValidator
                                  ? const Color.fromARGB(255, 255, 255, 255)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      // if (!_isKeyboardVisible)
                      //   const Expanded(
                      //     child: Align(
                      //       alignment: Alignment.bottomCenter,
                      //       child: Text(
                      //         'Lub',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           color: Color.fromARGB(255, 73, 73, 73),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Container passwordCharsLeftWidget(BuildContext context, String password) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.83,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.red,
              blurRadius: 0.5,
              spreadRadius: 0.0,
              offset: Offset(0, 2),
            )
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${8 - password.length} znaków',
            style: TextStyle(
                color: password.length < 8
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
          Text(
            '${1 - countSpecialCharacters(password, false)} specjalnych',
            style: TextStyle(
                color: countSpecialCharacters(password, false) < 1
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
          Text(
            '${1 - countSpecialCharacters(password, true)} cyfr',
            style: TextStyle(
                color: countSpecialCharacters(password, true) < 1
                    ? const Color.fromARGB(255, 26, 26, 26)
                    : Colors.transparent),
          ),
        ],
      ),
    );
  }
}
