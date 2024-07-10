import 'dart:convert';
import 'package:findovio_business/provider/api_service.dart';
import 'package:findovio_business/provider/globals.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeoSuggestions {
  static const String apiKey = 'AIzaSyBaGjf8vohq-Cbm2W6qwm8vRXEWDW217eM';

  static Future<List<String>> getCitySuggestions(String query) async {
    if (query.isEmpty) {
      return [];
    }
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return List.empty();
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=(cities)&key=$apiKey&components=country:pl';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['predictions'];
      List<String> suggestions =
          data.map((e) => e['description'].split(',')[0] as String).toList();
      return suggestions.toSet().toList();
    } else {
      throw Exception('Failed to load city suggestions');
    }
  }

  static Future<Map<String, double>> getCityCoordinates(String city) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return {};
    }
    return {};

    /// Disabled because of unknown usage of Firebase API
    /// by chat which can lead to overexcess generating huge cost
    /// by now, address street prediction is disabled
    // final url =
    //     'https://maps.googleapis.com/maps/api/geocode/json?address=$city&key=$apiKey';
    // final response = await http.get(Uri.parse(url));

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   final location = data['results'][0]['geometry']['location'];
    //   return {
    //     'lat': location['lat'],
    //     'lng': location['lng'],
    //   };
    // } else {
    //   throw Exception('Failed to load city coordinates');
    // }
  }

  static Future<String?> getCityFromPostCode(String postcode) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return 'Brak inter';
    }
    final url = 'http://kodpocztowy.intami.pl/api/$postcode';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedBody);
      if (jsonResponse.isNotEmpty) {
        CityData response = CityData.fromJson(jsonResponse[0]);
        return response.miejscowosc;
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load city data');
    }
  }

  static Future<List<String>> getStreetSuggestions(
      String query, String city) async {
    if (query.isEmpty || city.isEmpty) {
      return [];
    }

    final cityCoords = await getCityCoordinates(city);
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&types=address&key=$apiKey&location=${cityCoords['lat']},${cityCoords['lng']}&radius=5000&components=country:pl';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['predictions'];
      List<String> suggestions = data.map((e) {
        String description = e['description'] as String;
        String streetName = description.split(',')[0];
        return streetName;
      }).toList();
      return suggestions.toSet().toList();
    } else {
      throw Exception('Failed to load street suggestions');
    }
  }
}

class CityData {
  final String? kod;
  final String? nazwa;
  final String? miejscowosc;
  final String? ulica;
  final String? gmina;
  final String? powiat;
  final String? wojewodztwo;
  final String? dzielnica;
  final List<Numeracja> numeracja;

  CityData({
    required this.kod,
    required this.nazwa,
    required this.miejscowosc,
    required this.ulica,
    required this.gmina,
    required this.powiat,
    required this.wojewodztwo,
    required this.dzielnica,
    required this.numeracja,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    var numeracjaList = json['numeracja'] as List;
    List<Numeracja> numeracja =
        numeracjaList.map((i) => Numeracja.fromJson(i)).toList();

    return CityData(
      kod: json['kod'],
      nazwa: json['nazwa'],
      miejscowosc: json['miejscowosc'],
      ulica: json['ulica'],
      gmina: json['gmina'],
      powiat: json['powiat'],
      wojewodztwo: json['wojewodztwo'],
      dzielnica: json['dzielnica'],
      numeracja: numeracja,
    );
  }
}

class Numeracja {
  final String od;
  final String doo;
  final String parzystosc;

  Numeracja({
    required this.od,
    required this.doo,
    required this.parzystosc,
  });

  factory Numeracja.fromJson(Map<String, dynamic> json) {
    return Numeracja(
      od: json['od'],
      doo: json['do'],
      parzystosc: json['parzystosc'],
    );
  }
}
