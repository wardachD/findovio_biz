import 'package:flutter/material.dart';

class ProfileWidgets {
  static Future<dynamic> showDialogLoading(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(), // Add CircularProgressIndicator
              SizedBox(width: 20),
              Text('Proszę czekać...'), // Add a text for context
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> showDialogWithTitleAndButton(
      BuildContext context, String title, String buttonText) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          content: Text(title),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop(); // Dismiss the dialog
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: Text(buttonText),
            ),
          ],
        );
      },
    );
  }
}
