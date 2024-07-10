import 'dart:ui';

import 'package:findovio_business/provider/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showSnackbar(String remainingDays) {
  final snackBar2 = SnackBar(
    elevation: 0,
    duration: const Duration(days: 5), // Adjust the duration as needed
    backgroundColor: Colors.transparent,
    content: Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: const Color.fromARGB(17, 0, 0, 0)),
                      color: const Color.fromARGB(255, 241, 241, 241)
                          .withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wersja demo, Pozostało $remainingDays dni.\nWykup dostęp tutaj.',
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(
                            height: 40), // Placeholder for space before buttons
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: -60,
          right: -20,
          child: Image.asset(
            'assets/images/make_payment.png',
            width: 160, // Adjust the width as needed
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              // Align buttons to the left
              children: [
                CupertinoButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  onPressed: () {
                    snackbarKey.currentState?.clearSnackBars();
                  },
                  color: Colors.white,
                  child: const Text(
                    'Przypomnij',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14), // Adjust font size as needed
                  ),
                ),
                const SizedBox(width: 16), // Add spacing between buttons
                CupertinoButton(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                  onPressed: () async {
                    final url = Uri.parse("https://findovio.nl#pricing");

                    launchUrl(url).onError(
                      (error, stackTrace) {
                        print("Url is not valid!");
                        return false;
                      },
                    );
                  },
                  color: Colors.black,
                  child: const Text(
                    'Kup -60%!',
                    style:
                        TextStyle(fontSize: 14), // Adjust font size as needed
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  snackbarKey.currentState?.showSnackBar(snackBar2);
}
