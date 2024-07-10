import 'dart:convert';
import 'package:findovio_business/models/license_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.findovio.nl/api';

  // Create a new license
  Future<bool?> createLicense(String username) async {
    final response = await http.post(
      Uri.parse('$baseUrl/license/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw false;
    }
  }

  // Get license details
  Future<LicenseModel?> getLicense(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/license/$username/'),
    );

    if (response.statusCode == 200) {
      return LicenseModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load license');
    }
  }

  // Update license details
  Future<bool?> updateLicense(
      String username, Map<String, dynamic> updates) async {
    final response = await http.put(
      Uri.parse('$baseUrl/license/$username/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw false;
    }
  }

  // Delete license
  Future<bool> deleteLicense(String username) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/license/$username/'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  // Add a new payment
  Future<bool?> addPayment(Map<String, dynamic> paymentData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/payment/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(paymentData),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to add payment');
    }
  }
}
