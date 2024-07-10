import 'package:findovio_business/screens/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final _firestore = FirebaseFirestore.instance;
  String _email = '';

  void _startChat(types.User otherUser) async {
    final User? user = FirebaseAuth.instance.currentUser;

    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined)),
                const Text(
                  'Szukaj użytkownika',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 6,
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Email lub nazwa',
                  labelText: 'Wyszukaj',
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 180, 180, 180)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 180, 180, 180)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 180, 180, 180)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.search), Text('Wyszukaj')],
                  ),
                ),
                onPressed: () async {
                  final userQuery = await _firestore
                      .collection('users')
                      .where('firstName', isEqualTo: _email)
                      .get();

                  if (userQuery.docs.isNotEmpty) {
                    final userData = userQuery.docs.first.data();
                    var userRole = userData['role'] == types.Role.user
                        ? types.Role.user
                        : types.Role.agent;
                    final otherUser = types.User(
                        id: userQuery.docs.first.id,
                        firstName: userData['firstName'],
                        lastName: userData['lastName'],
                        imageUrl: userData['imageUrl'],
                        role: userRole);
                    _startChat(otherUser);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Brak użytkownika o nazwie (adresie email): $_email')),
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 64,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/glassessearch.png',
                        height: 60,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Szukaj po adresie email lub nazwie',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Szukając po nazwie użytkownika możesz natrafić na te same wyniki, dlatego najlepiej używać adresu email.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
