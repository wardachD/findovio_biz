import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> showCreatingSalonDialog(
  BuildContext context,
  String titleText,
  List<String> descriptions,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Apply
        child: AlertDialog(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                child: LinearProgressIndicator(
                  minHeight: 6,
                  color: const Color.fromARGB(255, 255, 162, 22),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  titleText,
                  style: TextStyle(
                    fontSize: 18, // Rozmiar czcionki
                  ),
                  textAlign: TextAlign.left, // Wyrównanie do lewej
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  descriptions[0],
                  textAlign: TextAlign.left, // Wyrównanie do lewej
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                child: Text(
                  descriptions[1],
                  textAlign: TextAlign.left, // Wyrównanie do lewej
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
