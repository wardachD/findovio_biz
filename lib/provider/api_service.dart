import 'dart:convert';

import 'package:findovio_business/models/create_salon_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

Future<bool> hasInternetConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult.contains(ConnectivityResult.mobile) ||
      connectivityResult.contains(ConnectivityResult.wifi)) {
    return true;
  } else {
    return false;
  }
}

Future<bool> createSalon(
    CreateSalonModel salonData, BuildContext context) async {
  final Uri url = Uri.parse('https://api.findovio.nl/api/salons/');

  bool isConnected = await hasInternetConnection();
  if (!isConnected) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
            Text('Brak połączenia z internetem. Sprawdź swoje połączenie.'),
        duration: Duration(seconds: 3),
      ),
    );
    return false;
  }

  try {
    User? user = FirebaseAuth.instance.currentUser;

    /// Check if user is authenticated
    if (user != null) {
      /// Get the Firebase user token
      String? token = await user.getIdToken();

      /// Check if token is available
      if (token != null && token.isNotEmpty) {
        /// Include the token in the headers
        final response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(salonData.toJson()),
        );

        if (response.statusCode == 201) {
          print(jsonEncode(salonData.toJson()));
          print('Salon created successfully!');

          return true;
        } else {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Błąd podczas dodawania salonu.'),
              duration: Duration(seconds: 3),
            ),
          );
          throw Exception('Unable to fetch salon working hours/');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Użytkownik niepoprawny'),
            duration: Duration(seconds: 3),
          ),
        );
        throw Exception('Użytkownik niepoprawny');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Użytkownik nieautoryzowany'),
          duration: Duration(seconds: 3),
        ),
      );
      throw Exception('Użytkownik nieautoryzowany');
    }
  } catch (e) {
    /// Handle any errors
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Błąd: $e'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
  return false;
}
