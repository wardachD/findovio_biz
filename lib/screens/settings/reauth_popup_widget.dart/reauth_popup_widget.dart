import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ReauthPopupWidget extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ReauthPopupWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: const Text('Ponowne logowanie'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Potrzebujemy ponownej weryfikacji żebyśmy mogli zmienić adres email. Zaloguj się przy użyciu maila lub korzystając z Google.'),
          const SizedBox(
            height: 12,
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor:
                  const Color.fromARGB(255, 240, 240, 240), // Lekko szare tło
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Hasło',
              filled: true,
              fillColor:
                  const Color.fromARGB(255, 240, 240, 240), // Lekko szare tło
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0), // Zaokrąglone rogi
              ),
            ),
            obscureText: true, // Ukrywa wprowadzane dane (hasło)
          ),
          const SizedBox(height: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    String email = emailController.text.trim();
                    String password = passwordController.text;
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    Navigator.pop(context, userCredential.user != null);
                  } catch (e) {
                    print('Login failed: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logowanie nieudane')),
                    );
                  }
                },
                child: const Text('Zaloguj się'),
              ),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await GoogleSignIn().signIn();

                    // Obtain the auth details from the request
                    final GoogleSignInAuthentication? googleAuth =
                        await googleUser?.authentication;

                    // Create a new credential
                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth?.accessToken,
                      idToken: googleAuth?.idToken,
                    );

                    // Once signed in, return the UserCredential
                    await FirebaseAuth.instance
                        .signInWithCredential(credential);

                    Navigator.pop(context);
                  } catch (e) {
                    print('Google sign in failed: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Logowanie przez Google nieudane')),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
