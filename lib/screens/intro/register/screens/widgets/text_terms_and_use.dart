import 'package:flutter/material.dart';

class TextTermsAndUse extends StatelessWidget {
  const TextTermsAndUse({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Rejestrując się, zgadzasz się na ',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
          TextSpan(
            text: 'Warunki usługi',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 14,
              color: Color.fromARGB(255, 0, 0, 255), // Niebieski kolor
            ),
          ),
          TextSpan(
            text: ' i ',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
          TextSpan(
            text: 'Politykę prywatności',
            style: TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 14,
              color: Color.fromARGB(255, 0, 0, 255), // Niebieski kolor
            ),
          ),
          TextSpan(
            text: ' Findovio',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 73, 73, 73),
            ),
          ),
        ],
      ),
    );
  }
}
