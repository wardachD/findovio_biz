import 'package:flutter/material.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
  userNotFound
}

class PopupStatusEmailReset extends StatelessWidget {
  final AuthStatus status;

  const PopupStatusEmailReset({super.key, required this.status});

  String getTitle() {
    switch (status) {
      case AuthStatus.successful:
        return 'Link wysłany 📪';
      case AuthStatus.wrongPassword:
        return 'Błędne hasło';
      case AuthStatus.emailAlreadyExists:
        return 'Email już istnieje';
      case AuthStatus.invalidEmail:
        return 'Link wysłany 📪';
      case AuthStatus.weakPassword:
        return 'Słabe hasło';
      case AuthStatus.userNotFound:
        return 'Link wysłany 📪';
      default:
        return 'Coś poszło nie tak 🧐';
    }
  }

  String getText() {
    switch (status) {
      case AuthStatus.successful:
        return 'Sprawdź swoją skrzynkę mailową i postępuj według instrukcji';
      case AuthStatus.wrongPassword:
        return 'Spróbuj ponownie z poprawnym hasłem';
      case AuthStatus.emailAlreadyExists:
        return 'Sprawdź swoją skrzynkę mailową i postępuj według instrukcji';
      case AuthStatus.invalidEmail:
        return 'Sprawdź swoją skrzynkę mailową i postępuj według instrukcji';
      case AuthStatus.weakPassword:
        return 'Hasło jest zbyt słabe';
      case AuthStatus.userNotFound:
        return 'Sprawdź swoją skrzynkę mailową i postępuj według instrukcji';
      default:
        return 'Spróbuj ponownie później';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: SingleChildScrollView(
        child: Text(getText()),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
