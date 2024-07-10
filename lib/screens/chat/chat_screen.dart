import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';

class ChatScreen extends StatefulWidget {
  final types.Room room;

  const ChatScreen({super.key, required this.room});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  User? _currentUser;
  types.Message? lastMessage;
  final TextEditingController _controller = TextEditingController();

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

  void _handleSendPressed(types.PartialText message) {
    final newMessage = types.PartialText(
      text: message.text,
    );

    FirebaseChatCore.instance.sendMessage(newMessage, widget.room.id);
  }

  void _markMessagesAsRead(List<types.Message> messages) {
    final batch = FirebaseFirestore.instance.batch();
    for (var message in messages) {
      if (message.metadata?['status'] != 'seen' &&
          message.author.id != _currentUser?.uid) {
        final messageRef = FirebaseFirestore.instance
            .collection('rooms/${widget.room.id}/messages')
            .doc(message.id);
        batch.update(messageRef, {'status': 'seen'});
      }
    }
    batch.commit();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_outlined)),
                if (widget.room.imageUrl != null)
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          fit: BoxFit.fill,
                          widget.room.imageUrl!,
                          width: 32,
                          height: 32,
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                Text(
                  widget.room.name ?? 'Wiadomość',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 24,
            ),
            Expanded(
              child: StreamBuilder<List<types.Message>>(
                stream: FirebaseChatCore.instance.messages(widget.room),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data ?? [];
                  lastMessage = messages.isNotEmpty
                      ? messages.first
                      : const types.UnsupportedMessage(
                          id: '', author: types.User(id: 'system'));

                  _markMessagesAsRead(messages);

                  return Chat(
                    customBottomWidget: _customBottomWidget(context),
                    messages: messages,
                    showUserAvatars: true,
                    bubbleBuilder: _bubbleBuilder,
                    onSendPressed: _handleSendPressed,
                    user: types.User(id: _currentUser?.uid ?? ''),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customBottomWidget(BuildContext context) {
    final query = MediaQuery.of(context);
    final safeAreaInsets = EdgeInsets.fromLTRB(
        12, 12, 6, query.viewInsets.bottom + query.padding.bottom + 12);

    return Container(
      padding: safeAreaInsets,
      color: Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 241, 241, 241),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                maxLines: null,
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Wiadomość...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(
              width: 8), // Odstęp między polem tekstowym a przyciskiem
          Material(
            color:
                const Color.fromARGB(255, 135, 191, 255), // Kolor tła przycisku
            shape: const CircleBorder(), // Okrągły kształt przycisku
            child: InkWell(
              onTap: () {
                types.PartialText tempMessage = types.PartialText(
                  text: _controller.text,
                  metadata: const {'status': 'sent'},
                );
                _handleSendPressed(tempMessage);
                _controller.clear();
              },
              borderRadius: BorderRadius.circular(
                  20.0), // Te same zaokrąglenia co pole tekstowe
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  Icons.send,
                  color: Colors.white, // Biały kolor ikony
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubbleBuilder(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  }) {
    final isLastMessage = !nextMessageInGroup;
    final isCurrentUserMessage = message.author.id == _currentUser?.uid;

    return Bubble(
      child: child,
      style: BubbleStyle(),
      padding: const BubbleEdges.all(0),
      radius: const Radius.circular(12),
      nipRadius: 0,
      color: isCurrentUserMessage || message.type == types.MessageType.image
          ? const Color.fromARGB(255, 135, 191, 255)
          : const Color.fromARGB(255, 236, 236, 236),
      margin: nextMessageInGroup
          ? const BubbleEdges.symmetric(horizontal: 2)
          : null,
      nip: nextMessageInGroup
          ? BubbleNip.no
          : isCurrentUserMessage
              ? BubbleNip.rightBottom
              : BubbleNip.leftBottom,
    );
  }
}
