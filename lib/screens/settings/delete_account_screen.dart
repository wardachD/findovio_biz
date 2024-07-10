import 'package:findovio_business/routes/app_pages.dart';
import 'package:findovio_business/screens/intro/register/screens/password_reset_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _controlController;
  late TextEditingController _passwordController;
  var user = FirebaseAuth.instance.currentUser;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controlController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _controlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<bool> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user?.email ?? '', password: _passwordController.value.text);
      await user?.reauthenticateWithCredential(credential);
      await user?.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konto usunięte.')),
      );
      Get.offAllNamed(Routes.INTRO);
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Twoje stare hasło jest nieprawidłowe.')),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 12),
                        child: const Text(
                          'Usuń konto',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 228, 228, 228),
                    height: 24,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Usuwanie konta ',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Usunięcie konta jest nieodwracalne, przypisany salon to Twojego konta najpierw zostanie wyłączony - następnie po okresie 7 dni zostanie usunięta cała zawartość.',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Żeby potwierdzić wybór usunięcia konta wpisz',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  const Text(
                    'usuń konto',
                    style: TextStyle(color: Color.fromARGB(255, 255, 56, 56)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    enableSuggestions: false,
                    textInputAction: TextInputAction.next,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _controlController,
                    decoration: const InputDecoration(
                      labelText: 'Wpisz usuń konto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Wpisz "usuń konto"';
                      }
                      if (value.isNotEmpty) {
                        if (value == "usuń konto" ||
                            value == "usuńkonto" ||
                            value == "Usuń konto" ||
                            value == "usuń Konto" ||
                            value == "Usuń Konto") return null;
                        return 'Wpisz "usuń konto"';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    onEditingComplete: () => _deleteAccount(),
                    enableSuggestions: false,
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.done,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Stare hasło',
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          !_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hasło nie może być puste';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PasswordResetScreen(),
                            ));
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
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 20, 20, 20)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    onPressed: () => _deleteAccount(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Usuń konto',
                            style: TextStyle(
                              color: Colors.white,
                            )),
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
