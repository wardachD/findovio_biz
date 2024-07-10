import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class PasswordResetScreen extends StatelessWidget {
  PasswordResetScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final _formKeyRegister = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Form(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                  'assets/images/findovio_business_logo_full.svg',
                  fit: BoxFit.fitHeight,
                  height: MediaQuery.of(context).size.width * 0.15,
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.sizeOf(context).height * 0.2,
                    left: 25,
                    right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(0, 4, 4, 4),
                      child: Material(
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
                    const Text(
                      'Zresetuj swoje hasło',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    const Text(
                      'Wpisz swój adres e-mail, a my wyślemy Ci instrukcje resetowania hasła.',
                      style: TextStyle(
                        color: Color.fromARGB(255, 73, 73, 73),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKeyRegister,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Adres e-mail*',
                          icon: Icon(Icons.email),
                          contentPadding: const EdgeInsets.all(16.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Wprowadź adres e-mail';
                          }
                          final RegExp regex = RegExp(
                              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                          if (!regex.hasMatch(value)) {
                            return 'Nieprawidłowy format adresu e-mail';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () async {
                        if (_formKeyRegister.currentState != null &&
                            _formKeyRegister.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text.trim(),
                            );
                            Get.back();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Sukces'),
                                content: const Text(
                                    'Wiadomość z instrukcjami została wysłana.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Błąd'),
                                content: const Text(
                                    'Nie udało się wysłać wiadomości. Sprawdź adres e-mail i spróbuj ponownie.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
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
                          'Kontynuuj',
                          style: TextStyle(
                            color: Colors.white,
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
    );
  }
}
