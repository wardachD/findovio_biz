import 'package:findovio_business/screens/chat/chat_screen.dart';
import 'package:findovio_business/screens/chat/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUser = user;
      });
    }
  }

  Stream<List<types.Room>> _getRooms() {
    return FirebaseChatCore.instance.rooms();
  }

  Future<String> _getLastMessage(types.Room room) async {
    final messagesQuery = await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (messagesQuery.docs.isNotEmpty) {
      final data = messagesQuery.docs.first.data();
      return data['text'] as String;
    }

    return 'No messages yet';
  }

  Future<DateTime?> _getLastMessageDate(types.Room room) async {
    final messagesQuery = await FirebaseFirestore.instance
        .collection('rooms/${room.id}/messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();

    if (messagesQuery.docs.isNotEmpty) {
      final data = messagesQuery.docs.first.data();
      final timestamp = data['createdAt'] as Timestamp;
      return timestamp.toDate();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Text(
                    'Wiadomości',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 24,
            ),
            Expanded(
              child: StreamBuilder<List<types.Room>>(
                stream: _getRooms(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final rooms = snapshot.data!;

                  return ListView.builder(
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];

                      return FutureBuilder<String>(
                        future: _getLastMessage(room),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const LinearProgressIndicator();
                          }
                          final lastMessage =
                              snapshot.data ?? 'No messages yet';

                          return FutureBuilder<DateTime?>(
                            future: _getLastMessageDate(room),
                            builder: (context, dateSnapshot) {
                              final lastMessageDate = dateSnapshot.data;
                              final formattedDate = lastMessageDate != null
                                  ? DateFormat('dd.MM, HH:mm')
                                      .format(lastMessageDate)
                                  : 'No date available';

                              return Column(
                                children: [
                                  ListTile(
                                    leading: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(24),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Color.fromARGB(
                                                255, 236, 236, 236),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                      width: 48,
                                      height: 48,
                                      child: room.imageUrl != null
                                          ? Image.network(room.imageUrl!)
                                          : const Icon(Icons.home_outlined),
                                    ),
                                    title: Text(
                                      room.name ?? 'Chat',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    trailing: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    subtitle: Text(
                                      lastMessage,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 71, 71, 71)),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChatScreen(room: room),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 228, 228, 228),
                                  ), // Dodaje linię horyzontalną między elementami listy
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            // Dodajemy nową sekcję poniżej listy wiadomości
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 12),
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.6,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/messages.png', // Tutaj ustaw URL swojego obrazka
                        height: MediaQuery.sizeOf(context).height * 0.15,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Nowy kontakt?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Wciśnij niebieski przycisk u dołu ekranu by dodać użytkownika używając jego adres email.',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  UserSearchScreen(), // Tutaj ustaw ekran dodawania użytkownika
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
