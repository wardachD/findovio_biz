import 'package:findovio_business/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:findovio_business/utilities/authentication/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'password_reset_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  bool _isKeyboardVisible = false;
  bool _isEmailNeeded = false;
  bool _resetOKShowHelper = false;

  @override
  void initState() {
    super.initState();
    _isEmailNeeded = false;
    _resetOKShowHelper = false;
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

  // Use this form key to validate user's input
  final _formKey = GlobalKey<FormState>();

  // Use this to store user inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Regexp verificator email
  bool _validateEmail(String email) {
    final RegExp regex = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final double topMargin = _isKeyboardVisible
        ? MediaQuery.sizeOf(context).height * 0.1
        : MediaQuery.sizeOf(context).height * 0.2;
    // final double heightWithKeyboard = _isKeyboardVisible ? 5.0 : 25.0;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
          child: Form(
            key: _formKey,
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
                    padding: EdgeInsets.fromLTRB(0, topMargin, 0, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'Zaloguj się',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'BioRhyme',
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Text(
                            'Sporo Cię ominęło',
                            textAlign: TextAlign.start,
                            style: TextStyle(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const SizedBox(height: 4.0),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: _isEmailNeeded
                                  ? Colors.orangeAccent
                                  : Colors.grey[400]!,
                            ),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Wprowadź swój email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Adres Email',
                              contentPadding: EdgeInsets.all(16.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey[400]!),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Wprowadź hasło';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Hasło',
                              contentPadding: EdgeInsets.all(16.0),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                            onTap: () async {
                              Get.to(() => PasswordResetScreen());
                            },
                            child: const Text(
                              'Zapomniałeś hasła?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 94, 94, 94),
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26.0),
                        GestureDetector(
                          onTap: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            var res = await Auth.signInWithEmailAndPassword(
                                _emailController.value.text,
                                _passwordController.value.text);
                            if (res == null) {
                              Get.offAllNamed(Routes.HOME);
                            } else if (mounted) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text(
                                      'Nieprawidłowe dane logowania',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    content: const Text(
                                      'Podane dane logowania są nieprawidłowe. Proszę spróbować ponownie.',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );

                              _emailController.text = '';
                              _passwordController.text = '';
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.orange,
                            ),
                            child: const Text(
                              'Zaloguj',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
