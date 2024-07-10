import 'package:findovio_business/screens/intro/register/screens/widgets/popup_dialog.dart';
import 'package:findovio_business/screens/settings/reauth_popup_widget.dart/reauth_popup_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main_menu/widgets/alertdialog_loading.dart';

class NameSettingsScreen extends StatefulWidget {
  const NameSettingsScreen({super.key});

  @override
  State<NameSettingsScreen> createState() => _FirebaseEditScreenState();
}

class _FirebaseEditScreenState extends State<NameSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nameController.text = user?.displayName ?? '';
    _emailController = TextEditingController();
    _emailController.text = user?.email ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateUser(String option) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final email = _emailController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialogLoading(
          icon: Icon(Icons.update),
          title: 'Aktualizuję dane',
          message: 'Proszę czekać...',
        );
      },
    );

    switch (option) {
      case 'name':
        try {
          user?.updateDisplayName(name);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd $e')),
          );
        }
      case 'mail':
        try {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return ReauthPopupWidget();
            },
          );
          const PopupDialog(
              title: 'Zmiana adresu Email',
              text:
                  'Na podany adres został wysłany link potwierdzający. Po jego kliknięciu adres zostanie zmieniony.');
          user?.verifyBeforeUpdateEmail(email);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Błąd $e')),
          );
        }
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Żadna opcja nie została wybrana.')),
        );
        return;
    }
    Navigator.of(context, rootNavigator: true).pop();
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
                          'Dodaj/usuń lub modyfikuj usługi',
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
                      'Nazwa użytkownika',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tutaj zmienisz swoją nazwę, którą użytkownik widzi podczas składania rezerwacji 😊.',
                    style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    onTapOutside: ((event) =>
                        FocusManager.instance.primaryFocus?.unfocus()),
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nazwa użytkownika',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Imię nie może być puste';
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
                    onPressed: () => _updateUser('name'),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Zmień swoją nazwę',
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ),
                  // const Divider(
                  //   color: Color.fromARGB(255, 228, 228, 228),
                  //   height: 24,
                  // ),
                  // const SizedBox(height: 16),
                  // Container(
                  //   width: MediaQuery.sizeOf(context).width,
                  //   child: const Text(
                  //     'Adres Email',
                  //     textAlign: TextAlign.left,
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  //   ),
                  // ),
                  // const SizedBox(height: 8),
                  // const Text(
                  //   'W tym miejscu zmienisz swój adres mailowy. Po wprowadzeniu nowego możesz zostać poproszony o ponowne zalogowanie.',
                  //   style: TextStyle(color: Color.fromARGB(255, 85, 85, 85)),
                  // ),
                  // const SizedBox(height: 16),
                  // TextFormField(
                  //   textInputAction: TextInputAction.done,
                  //   onTapOutside: ((event) =>
                  //       FocusManager.instance.primaryFocus?.unfocus()),
                  //   controller: _emailController,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Adres mailowy',
                  //     border: OutlineInputBorder(),
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Email nie może być pusty';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 16),
                  // OutlinedButton(
                  //   style: ButtonStyle(
                  //       backgroundColor: MaterialStateProperty.all<Color>(
                  //           const Color.fromARGB(255, 20, 20, 20)),
                  //       side: MaterialStateProperty.all<BorderSide>(
                  //           BorderSide.none)),
                  //   onPressed: () => _updateUser('mail'),
                  //   child: const Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text('Zmień swój adres mailowy',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
