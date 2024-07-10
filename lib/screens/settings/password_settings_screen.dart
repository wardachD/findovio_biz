import 'package:findovio_business/screens/intro/register/screens/password_reset_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_menu/widgets/alertdialog_loading.dart';

class PasswordSettingsScreen extends StatefulWidget {
  const PasswordSettingsScreen({super.key});

  @override
  State<PasswordSettingsScreen> createState() => _FirebaseEditScreenState();
}

class _FirebaseEditScreenState extends State<PasswordSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _passwordController;
  late TextEditingController _rePasswordController;
  var user = FirebaseAuth.instance.currentUser;
  bool _obscureText = true;
  bool _reObscureText = true;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _rePasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _rePasswordController.dispose();
    super.dispose();
  }

  Future<bool> _updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialogLoading(
          icon: Icon(Icons.update),
          title: 'Zmieniam hasło',
          message: 'Proszę czekać...',
        );
      },
    );
    try {
      AuthCredential credential = EmailAuthProvider.credential(
          email: user?.email ?? '', password: _passwordController.value.text);
      await user?.reauthenticateWithCredential(credential);
      await user?.updatePassword(_rePasswordController.value.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hasło zmieniono pomyślnie')),
      );

      _passwordController.text = '';
      _rePasswordController.text = '';
      print('done');
      Navigator.of(context, rootNavigator: true).pop();

      return true;
    } catch (e) {
      _passwordController.text = '';
      _rePasswordController.text = '';
      Navigator.of(context, rootNavigator: true).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Twoje stare hasło jest nieprawidłowe')),
      );
    }
    return false;
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
                          'Hasło',
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
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: const Text(
                      'Zmień hasło',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tutaj zmienisz swoje hasło, które powinno składać się z minimum 10 znaków, w tym 1 specjalnego i 1 cyfry.',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
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
                  TextFormField(
                    enableSuggestions: false,
                    obscureText: _reObscureText,
                    textInputAction: TextInputAction.done,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    controller: _rePasswordController,
                    decoration: InputDecoration(
                      labelText: 'Nowe hasło',
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _reObscureText = !_reObscureText;
                          });
                        },
                        child: Icon(
                          !_reObscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Hasło nie może być puste';
                      }
                      if (value.length < 10) {
                        return 'Hasło musi mieć co najmniej 10 znaków';
                      }
                      if (!value.contains(RegExp(r'[0-9]'))) {
                        return 'Hasło musi zawierać co najmniej jedną cyfrę';
                      }
                      if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                        return 'Hasło musi zawierać co najmniej jeden znak specjalny';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 20, 20, 20)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    onPressed: () => _updatePassword(),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Zmień hasło',
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
