import 'dart:convert';
import 'package:findovio_business/provider/api_service.dart';
import 'package:findovio_business/provider/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.findovio.nl/api';

  static Future<bool> checkNameExists(String name) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final url = Uri.parse('$baseUrl/check-name-exists/');
    if (name.length > 6) {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['exists'];
      } else {
        throw Exception('Failed to check name existence');
      }
    }
    return Future.value(false);
  }

  // Dodaj inne metody API tutaj
}
