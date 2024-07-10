// ignore_for_file: avoid_print

import 'dart:io';
import 'package:findovio_business/models/firebase_user_model.dart';
import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/models/get_salon_schedule.dart';
import 'package:findovio_business/models/license_model.dart';
import 'package:findovio_business/provider/api_service.dart';
import 'package:findovio_business/provider/globals.dart';
import 'package:findovio_business/screens/main_menu/widgets/license_snackbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../models/appointment_model.dart';
import '../../models/get_salon_images.dart';
import '../../screens/main_menu/pulpit_screen/screens/add_details_screen.dart';

class GetSalonProvider with ChangeNotifier {
  ///Fields
  GetSalonModel? _salon;
  File? _salonAvatar;
  List<Services>? _services;
  List<AppointmentModel> _appointments = [];
  List<GetSalonSchedule>? _schedules;
  final List<GetSalonImage> _salonImagesModel = [];
  File? _salonImagesFiles;
  final List<File> _salonImagesGalleryFiles = [];
  bool isComplete = false;
  LicenseStatusModel license =
      LicenseStatusModel(remainingDays: -999, isActive: false);

  ///Getters
  final Map<int, double> _monthlyCosts = {};
  final Map<int, int> _monthlyVisitsWithStatusC = {};
  final Map<int, int> _monthlyVisitsWithStatusX = {};
  final Map<int, Set<String>> _monthlyUniqueClients =
      {}; // Zbiór unikalnych klientów dla statusu 'C'

  void clear() {
    _salon = null;
    _salonAvatar = null;
    _services = null;
    _appointments.clear();
    _schedules = null;
    _salonImagesModel.clear();
    _salonImagesFiles = null;
    _salonImagesGalleryFiles.clear();
    isComplete = false;

    _monthlyCosts.clear();
    _monthlyVisitsWithStatusC.clear();
    _monthlyVisitsWithStatusX.clear();
    _monthlyUniqueClients.clear();
  }

  ///Getters
  GetSalonModel? get salon => _salon;
  File? get salonAvatar => _salonAvatar;
  List<Services>? get services => _services;
  List<AppointmentModel>? get appointments => _appointments;
  List<GetSalonSchedule>? get schedules => _schedules;
  List<GetSalonImage> get salonImagesModel => _salonImagesModel;
  File? get salonImagesFiles => _salonImagesFiles;
  List<File> get salonImagesGalleryFiles => _salonImagesGalleryFiles;
  bool get isServicesEmpty => _services == null;
  bool get isSchedulesEmpty => _schedules == null;
  String? get newestAppointmentDate =>
      _appointments.isNotEmpty ? _appointments.last.dateOfBooking : '';

  int getVisitsWithStatusForMonth(int month, String status) {
    switch (status) {
      case 'C':
        return _monthlyVisitsWithStatusC[month] ?? 0;
      case 'X':
        return _monthlyVisitsWithStatusX[month] ?? 0;
      default:
        return _monthlyVisitsWithStatusC[month] ?? 0;
    }
  }

  double getTotalCostForMonth(int month) {
    return _monthlyCosts[month] ?? 0.0;
  }

  void calculateMonthlyUsage() {
    // Clear previous values
    _monthlyCosts.clear();
    _monthlyVisitsWithStatusC.clear();
    _monthlyVisitsWithStatusX.clear();
    _monthlyUniqueClients.clear(); // Clear unique clients map

    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');

    for (final appointment in _appointments) {
      if (appointment.dateOfBooking != null && appointment.services != null) {
        final DateTime date = dateFormat.parse(appointment.dateOfBooking!);
        final int month = date.month;

        double total = 0.0;
        if (appointment.status == 'C' || appointment.status == 'F') {
          total = double.tryParse(appointment.totalAmount ?? '') ?? 0.0;
        }

        // Calculate monthly costs
        if (_monthlyCosts.containsKey(month)) {
          if (appointment.status == 'C' || appointment.status == 'F') {
            _monthlyCosts[month] = _monthlyCosts[month]! + total;
          }
        } else {
          _monthlyCosts[month] = total;
        }

        // Calculate monthly visits with status 'C' or 'F'
        if (appointment.status == 'C' || appointment.status == 'F') {
          if (_monthlyVisitsWithStatusC.containsKey(month)) {
            _monthlyVisitsWithStatusC[month] =
                _monthlyVisitsWithStatusC[month]! + 1;
          } else {
            _monthlyVisitsWithStatusC[month] = 1;
          }
          // Update unique clients
          _updateUniqueClients(
              _monthlyUniqueClients, month, appointment.customer ?? '');
        } else if (appointment.status == 'X') {
          // Calculate monthly visits with status 'X'
          if (_monthlyVisitsWithStatusX.containsKey(month)) {
            _monthlyVisitsWithStatusX[month] =
                _monthlyVisitsWithStatusX[month]! + 1;
          } else {
            _monthlyVisitsWithStatusX[month] = 1;
          }
        }

        // Debug prints to trace calculation
        print('Appointment ID: ${appointment.id}');
        print('Status: ${appointment.status}');
        print('Total for appointment: $total');
        print('Monthly costs for month $month: ${_monthlyCosts[month]}');
        print(
            'Monthly visits with status C or F for month $month: ${_monthlyVisitsWithStatusC[month]}');
        print(
            'Monthly visits with status X for month $month: ${_monthlyVisitsWithStatusX[month]}');
      }
    }
    notifyListeners();
  }

  void _updateUniqueClients(
      Map<int, Set<String>> clientMap, int month, String customer) {
    if (!clientMap.containsKey(month)) {
      clientMap[month] = {};
    }
    clientMap[month]!.add(customer);
  }

  int getUniqueClientCountUpToMonth(int month) {
    Set<String> uniqueClients = {};
    for (int m = 1; m <= month; m++) {
      if (_monthlyUniqueClients.containsKey(m)) {
        uniqueClients.addAll(_monthlyUniqueClients[m]!);
      }
    }
    return uniqueClients.length;
  }

  List<AppointmentModel> getAppointmentsForMonthNumber(int monthNumber) {
    if (appointments != null) {
      return appointments!
          .where((element) =>
              (DateTime.parse(element.dateOfBooking ?? '').month) ==
              monthNumber)
          .toList();
    } else {
      return [];
    }
  }

  List<String> get getMonthsWithAppointments {
    final DateFormat dateFormat = DateFormat(
        'yyyy-MM-dd'); // Adjust the format according to your date string
    final Set<String> months = {};

    for (final appointment in _appointments) {
      if (appointment.dateOfBooking != null) {
        final DateTime date = dateFormat.parse(appointment.dateOfBooking!);
        final String monthYear = DateFormat('MMMM', 'pl_PL').format(date);
        months.add(monthYear);
      }
    }

    return months.toList()
      ..sort((a, b) {
        final DateFormat format = DateFormat('MMMM', 'pl_PL');
        return format.parse(a).compareTo(format.parse(b));
      });
  }

  void addSalonManually(GetSalonModel salon) {
    _salon = salon;
    notifyListeners();
  }

  bool isSalonCategoriesEmpty() {
    print(_salon?.categories == null ? true : false);
    return _salon?.categories == null ? true : false;
  }

  bool isSalonServicesEmpty() {
    return _salon?.categories?.length == 0;
  }

  bool isSalonSchedulesEmpty() {
    return _schedules == null;
  }

  Future<bool> getAppointments(int id) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      final response = await http.get(
        Uri.parse('https://api.findovio.nl/api/salon/$id/appointments/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
      );
      String error = response.body;
      print(error);
      if (response.statusCode == 200) {
        final List<dynamic> responseBody =
            json.decode(utf8.decode(response.body.codeUnits));
        _appointments = responseBody
            .map((salonAppointmentsJson) =>
                AppointmentModel.fromJson(salonAppointmentsJson))
            .toList();
        print('[Success] Fetching appointments');
        print(response);
        // Assuming you want to handle multiple salons, you can notify listeners with the list
        print(
            '[Process] Start fetching users to appointments, needed amount: [${_appointments.length}]');
        // for (var appointment in _appointments) {
        //   appointment.customerObject =
        //      await fetchFirebaseUser(appointment.customer ?? '', false);
        // }
        final responseLicense = await fetchLicenseStatus();

        print('salon appointments length: ${_appointments.length}');
        calculateMonthlyUsage();
        notifyListeners();
        return true;
      } else {
        calculateMonthlyUsage();
        print('[Fail] Fetching appointments');
        return false;
      }
    } catch (e) {
      calculateMonthlyUsage();
      print('[Fail] Fetching appointments $e');
      return false;
    }
  }

  Future<FirebaseUser> fetchFirebaseUser(String id, bool isNotify) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return FirebaseUser.error();
    }
    final String? token = await _getUserToken();
    try {
      final response = await http.get(
        Uri.parse('https://api.findovio.nl/api/firebase-users/id/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
      );
      if (response.statusCode == 200) {
        final dynamic responseBody =
            json.decode(utf8.decode(response.body.codeUnits));
        var fetchedUser = FirebaseUser.fromJson(responseBody);
        print('[Success] Fetching FirebaseUser');
        // Assuming you want to handle multiple salons, you can notify listeners with the list

        print(fetchedUser.toString());
        if (isNotify) {
          notifyListeners();
        }
        return fetchedUser;
      } else {
        print('[Fail] Fetching FirebaseUser');
        return FirebaseUser(
            id: 0,
            firebaseName: 'error',
            firebaseEmail: 'error',
            firebaseUid: 'error',
            timestamp: DateTime.now());
      }
    } catch (e) {
      print('[Fail] Fetching FirebaseUser $e');
      return FirebaseUser(
          id: 0,
          firebaseName: 'error',
          firebaseEmail: 'error',
          firebaseUid: 'error',
          timestamp: DateTime.now());
    }
  }

  Future<String> fetchSalon(bool isAppointmentUpdateRequired) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return 'Błąd';
    }
    try {
      // Check if user is authenticated and get Firebase token
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return 'user_not_authenticated';
      }
      String? token = await user.getIdToken();
      if (token == null) {
        return 'firebase_token_not_available';
      }

      final response = await http.get(
          Uri.parse(
              'https://api.findovio.nl/api/get/salon/?email=${user.email}'),
          headers: <String, String>{
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        final List<dynamic> responseBody =
            json.decode(utf8.decode(response.body.codeUnits));
        List<GetSalonModel> salons = responseBody
            .map((salonJson) => GetSalonModel.fromJson(salonJson))
            .toList();
        // Assuming you want to handle multiple salons, you can notify listeners with the list
        _salon = salons.isNotEmpty ? salons.first : null;
        print('[Success] Fetching salon Data');
        print('[Process] Fetching salon Appointments');
        if (salon != null && isAppointmentUpdateRequired) {
          await getAppointments(salon!.id!);
        }
        final responseLicense = await fetchLicenseStatus();

        notifyListeners();
        return 'success';
      } else {
        return 'failed_to_load_salon';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<bool> finalSaveSalon() async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Check if user is authenticated and get Firebase token
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      String? token = await user.getIdToken();
      if (token == null) {
        throw Exception('Firebase token not available');
      }
      Map<String, dynamic> updatedData = {
        'error_code': 0,
        // Dodaj inne pola, jeśli to konieczne
      };
      String jsonBody = json.encode(updatedData);

      final response = await http.patch(
        Uri.parse('https://api.findovio.nl/api/salons/${_salon?.id}/'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );
      print(response.body);
      if (response.statusCode == 200) {
        await fetchSalon(true);
        print('Salon finaly saved succesfuly');
        notifyListeners();
        return true;
      } else {
        print('Salon finaly saved failed');
        throw Exception('Failed to load salon');
      }
    } catch (e) {
      print('Salon finaly saved failed');
      throw Exception('Failed to fetch salon: $e');
    }
  }

  Future<bool> fetchLicenseStatus() async {
    if (_salon != null) {
      final response = await http.get(Uri.parse(
          'https://api.findovio.nl/api/salon/license/status/${_salon!.email}/'));
      print(
          'https://api.findovio.nl/api/salon/license/status/${_salon!.email}/');

      if (response.statusCode == 200) {
        try {
          license = LicenseStatusModel.fromJson(jsonDecode(response.body));
          if (license.isActive == false) {
            showSnackbar(license.remainingDays.toString());
          }
          notifyListeners();
          return true;
        } catch (e) {
          print(e);
        }
      } else {
        throw Exception('Failed to load license status');
      }
    }
    return false;
  }

  /// It gets edited fields and using PATCH updates the fields in PostgreSQL
  Future<bool> updateEditedFieldsSalon(
      Map<String, dynamic> editedFields) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Check if user is authenticated and get Firebase token
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      String? token = await user.getIdToken();
      if (token == null) {
        throw Exception('Firebase token not available');
      }

      String jsonBody = json.encode(editedFields);

      final response = await http.patch(
        Uri.parse('https://api.findovio.nl/api/salons/${_salon?.id}/'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody,
      );

      print(response.body);

      if (response.statusCode == 200) {
        await fetchSalon(false);
        print('Salon finally saved successfully');
        notifyListeners();
        return true;
      } else {
        print('Salon finally saved failed');
        throw Exception('Failed to load salon');
      }
    } catch (e) {
      print('Salon finally saved failed');
      throw Exception('Failed to fetch salon: $e');
    }
  }

  Future<bool> createCategories(List<Categories> categories) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Pobierz zalogowanego użytkownika
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Pobierz token uwierzytelnienia
        String? token = await user.getIdToken();
        if (token != null) {
          final response = await http.post(
            Uri.parse('https://api.findovio.nl/api/categories/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token', // Dodaj token do nagłówka
            },
            body: jsonEncode(categories
                .map((category) => category.toJson())
                .toList()), // Przekonwertuj listę kategorii na listę JSON
          );
          print(jsonEncode(
              categories.map((category) => category.toJson()).toList()));
          if (response.statusCode == 201) {
            print('[createCategories] response status: ${response.body}');
            return true;
          } else {
            print('[createCategories] response status: ${response.body}');

            throw Exception('Failed to create categories');
          }
        } else {
          throw Exception('Failed to get user token');
        }
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Error creating categories: $e');
    }
  }

  Future<bool> updateCategory(Categories category) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    List<Categories> requestList = [];
    requestList.add(category);
    try {
      final response = await http.patch(
        Uri.parse(
            'https://api.findovio.nl/api/categories_update/${category.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
        body: jsonEncode(category.toJson()),
      );
      print(jsonEncode(category.toJson()));
      if (response.statusCode == 200) {
        print('[updateCategory] response status: ${response.body}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  /// "Deletes" category by setting isAvailable to false
  /// This behaviour is wanted to keep the old data
  /// i.e. old appointments history to be working
  Future<bool> deleteCategory(int id) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      final response = await http.delete(
        Uri.parse('https://api.findovio.nl/api/categories_delete/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
      );
      if (response.statusCode == 204) {
        print('[deleteCategory] response status: ${response.body}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }

  /// Update category which is assigned to user's salon
  /// Need to pass correct category element
  Future<bool> changeIsAvailableCategory(Categories category) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      // Kopiowanie kategorii z zmienioną wartością isAvailable na false
      Categories updatedCategory = category.copyWith(isAvailable: false);

      final response = await http.patch(
        Uri.parse(
            'https://api.findovio.nl/api/categories_update/${category.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
        body: jsonEncode(updatedCategory.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('[changeIsAvailableCategory] response status: ${response.body}');
        return true;
      } else {
        print('Failed to update category: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  /// Create a new service using following:
  /// int? id;
  /// int? salon;
  /// int? category;
  /// String? title;
  /// String? description;
  /// String? price;
  /// int? durationMinutes;
  /// bool? isAvailable;
  ///
  Future<bool> createServices(Services service) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Pobierz zalogowanego użytkownika
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Pobierz token uwierzytelnienia
        String? token = await user.getIdToken();
        if (token != null) {
          final response = await http.post(
            Uri.parse('https://api.findovio.nl/api/services/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token', // Dodaj token do nagłówka
            },
            body: jsonEncode(service
                .toJson()), // Przekonwertuj listę kategorii na listę JSON
          );
          print(jsonEncode(service.toJson()));
          if (response.statusCode == 201) {
            print('[createServices] response status: ${response.body}');

            return true;
          } else {
            throw Exception('Failed to create categories');
          }
        } else {
          throw Exception('Failed to get user token');
        }
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Error creating categories: $e');
    }
  }

  /// Function to fetch all services from salon model from PostgreSQL database
  /// Required [id] argument is a salon ID
  /// [token] required
  Future<bool> getServices(int id) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      final response = await http.get(
        Uri.parse('https://api.findovio.nl/api/salon/$id/services/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> responseBody =
            json.decode(utf8.decode(response.body.codeUnits));
        _services = responseBody
            .map((salonServicesJson) => Services.fromJson(salonServicesJson))
            .toList();
        // Assuming you want to handle multiple salons, you can notify listeners with the list

        print('salon services length: ${_services?.length}');
        notifyListeners();
        print('[getServices] response status: ${response.body}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  Future<bool> updateService(Services service) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      final response = await http.patch(
        Uri.parse('https://api.findovio.nl/api/services/${service.id}/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
        body: jsonEncode(service.toJson()),
      );
      print('json encode: ${jsonEncode(service.toJson())}');
      if (response.statusCode == 200) {
        print('[updateService] response status: ${response.body}');

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  Future<bool> deleteService(int id) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final String? token = await _getUserToken(); // Pobranie tokenu użytkownika
    try {
      final response = await http.delete(
        Uri.parse('https://api.findovio.nl/api/services/$id/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Dodanie nagłówka autoryzacji
        },
      );
      if (response.statusCode == 204) {
        print('[deleteService] response status: ${response.body}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }

  Future<String?> _getUserToken() async {
    // Tutaj należy zaimplementować pobieranie tokenu autoryzacyjnego z Firebase Auth
    // Można to zrobić poprzez wywołanie odpowiedniej funkcji z Firebase Auth lub z jakiegokolwiek innego źródła, z którego pobieramy token
    // Poniżej przykład pobierania tokenu z Firebase Auth (wymaga dostępu do instancji Firebase Auth)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      return token;
    } else {
      return null;
    }
  }

  GetSalonModel parseSalon(String responseBody) {
    final parsed = jsonDecode(responseBody) as Map<String, dynamic>;
    return GetSalonModel.fromJson(parsed);
  }

  List<Categories> parseCategories(String responseBody) {
    final parsed = jsonDecode(responseBody) as List<dynamic>;
    return parsed.map((category) => Categories.fromJson(category)).toList();
  }

  Future<bool> createSchedule(List<GetSalonSchedule> salonSchedules) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Pobierz zalogowanego użytkownika
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Pobierz token uwierzytelnienia
        String? token = await user.getIdToken();
        if (token != null) {
          final response = await http.post(
            Uri.parse('https://api.findovio.nl/api/fixed-operating-hours/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token', // Dodaj token do nagłówka
            },
            body: jsonEncode(salonSchedules
                .map((schedule) => schedule.toJson())
                .toList()), // Przekonwertuj listę kategorii na listę JSON
          );
          print(jsonEncode(
              salonSchedules.map((schedule) => schedule.toJson()).toList()));
          if (response.statusCode == 201) {
            return true;
          } else {
            throw Exception('Failed to create categories');
          }
        } else {
          throw Exception('Failed to get user token');
        }
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      throw Exception('Error creating categories: $e');
    }
  }

  Future<bool> fetchSalonSchedules(int salonId) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Get the current Firebase user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if user is authenticated
      if (user != null) {
        // Get the Firebase user token
        String? token = await user.getIdToken();

        // Check if token is available
        if (token != null && token.isNotEmpty) {
          // Include the token in the headers
          final response = await http.get(
            Uri.parse(
                'https://api.findovio.nl/api/fixed-operating-hours/?salon=$salonId'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            final List<dynamic> jsonResponse = json.decode(response.body);
            _schedules = jsonResponse
                .map((scheduleJson) => GetSalonSchedule.fromJson(scheduleJson))
                .toList();
            return true;
          } else {
            // Handle HTTP error
            throw Exception(
                'Failed to load schedules from API: ${response.statusCode}');
          }
        } else {
          // Token is not available
          throw Exception('Firebase user token not available');
        }
      } else {
        // User is not authenticated
        throw Exception('User not authenticated');
      }
    } catch (e) {
      // Handle any errors
      return false; // Return an empty list in case of error
    }
  }

  List<GetSalonSchedule> parseSchedules(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<GetSalonSchedule>((json) => GetSalonSchedule.fromJson(json))
        .toList();
  }

  Future<bool> uploadPhoto(File file, PhotoType photoType, int username) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    var photoTypeSplitted = photoType.toString().split('.')[1];
    var uri = Uri.parse(
        'https://api.findovio.nl/api/salon/$username/photos/$photoTypeSplitted/');
    // Ustalanie typu zawartości na podstawie rozszerzenia pliku
    String contentType;
    if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg')) {
      contentType = 'image/jpeg';
    } else if (file.path.endsWith('.png')) {
      contentType = 'image/png';
    } else {
      print('Unsupported file type');
      return false;
    }

    // Utwórz żądanie multipart
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType(
            'image', contentType.split('/').last), // Ustawienie typu zawartości
      ));
    print(request);

    // Dodaj dane typu zdjęcia do JSONa
    print(photoTypeSplitted);
    var jsonData = {'photoType': photoTypeSplitted, 'salon_id': username};
    // Dopisz odpowiedni typ zdjęcia do JSONa

    // Dodaj dane JSON do żądania
    request.fields['jsonData'] = jsonEncode(jsonData);

    try {
      // Wyślij żądanie multipart
      var response = await request.send();

      // Sprawdź odpowiedź
      if (response.statusCode == 201) {
        print('File uploaded successfully');
        return true;
      } else {
        print('Failed to upload file. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error uploading file: $e');
      return false;
    }
  }

  Future<bool> fetchSalonImagesModel(int salonId, PhotoType photoType) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    var photoTypeSplitted = photoType.toString().split('.')[1];
    try {
      // Wyślij żądanie HTTP do pobrania danych
      var response = await http.get(Uri.parse(
          'https://api.findovio.nl/api/salon/$salonId/photos/$photoTypeSplitted/'));

      // Sprawdź czy otrzymano poprawną odpowiedź
      if (response.statusCode == 200) {
        // Parsuj dane odpowiedzi JSON
        try {
          List<dynamic> jsonData = jsonDecode(response.body);
          print(jsonData);
          try {
            var salonImagesModelFetched =
                jsonData.map((map) => GetSalonImage.fromJson(map)).toList();
            for (var element in salonImagesModelFetched) {
              _salonImagesModel.add(element);
            }
          } catch (e) {
            print('Error saving $photoTypeSplitted data: $e');
          }
        } catch (e) {
          print('error jsonData: $e');
        }
        // Zapisz pobrane dane

        // Powiadom słuchaczy o zaktualizowanych danych
        notifyListeners();

        // Zwróć true, jeśli pobrano dane poprawnie
        return true;
      } else {
        // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
        return false;
      }
    } catch (e) {
      // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
      print('Error fetching $photoTypeSplitted data: $e');
      return false;
    }
  }

  Future<bool> fetchSalonImagesFiles(GetSalonImage salonImagesToFetch) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Wyślij żądanie HTTP do pobrania danych
      String originalUrl = salonImagesToFetch.imageUrl!;
      String uri = originalUrl.replaceAll(
          'https://185.180.204.182:8000', 'http://185.180.204.182');
      print(
          uri); // Output: https://api.findovio.nl/media/salon_images/58_avatar_hyMmXhF.webp

      var response = await http.get(Uri.parse(uri));

      // Sprawdź czy otrzymano poprawną odpowiedź
      if (response.statusCode == 200) {
        // Parsuj dane odpowiedzi JSON
        var bytes = response.bodyBytes;
        String directory;
        if (salonImagesToFetch.imageType == PhotoType.avatar) {
          directory = 'avatar';
        } else if (salonImagesToFetch.imageType == PhotoType.gallery) {
          directory = 'gallery';
        } else {
          throw Exception('Unknown file type');
        }
        try {
          try {
            String savePath = '/$directory/';
            String fileName = uri.substring(uri.lastIndexOf('/') + 1);
            File file = File('$savePath$fileName');
            await file.writeAsBytes(bytes);
            switch (salonImagesToFetch.imageType) {
              case PhotoType.avatar:
                _salonImagesFiles = file;
                print('Saving avatar complete');
                break;
              case PhotoType.gallery:
                _salonImagesGalleryFiles.add(file);
                print('Saving gallery complete');
                break;
              case null:
                print('Wrong PhotoType');
                break;
            }
          } catch (e) {
            print('Error saving $salonImagesModel data: $e');
          }
        } catch (e) {
          print('error jsonData: $e');
        }
        // Zapisz pobrane dane

        // Powiadom słuchaczy o zaktualizowanych danych
        notifyListeners();

        // Zwróć true, jeśli pobrano dane poprawnie
        return true;
      } else {
        // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
        return false;
      }
    } catch (e) {
      // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
      print('Error fetching $salonImagesModel data: $e');
      return false;
    }
  }

  Future<bool> deleteSalonImagesFiles(int photoId) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: const Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    try {
      // Wyślij żądanie HTTP do pobrania danych
      String uri = 'https://api.findovio.nl/api/salon_image/delete/$photoId/';
      print(uri);

      var response = await http.delete(Uri.parse(uri));
      print(response.reasonPhrase);
      // Sprawdź czy otrzymano poprawną odpowiedź
      if (response.statusCode == 204) {
        var res = _salonImagesModel.remove(_salonImagesModel
            .firstWhere((element) => element.photoId == photoId));
        print(res);

        // Powiadom słuchaczy o zaktualizowanych danych
        notifyListeners();

        return true;
      } else {
        // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
        return false;
      }
    } catch (e) {
      // Zwróć false, jeśli wystąpił błąd podczas pobierania danych
      print('Error fetching $salonImagesModel data: $e');
      return false;
    }
  }

  Future<bool> getVerificationStatus(BuildContext context) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return false;
    }
    final url = 'https://api.findovio.nl/api/salon/check/${_salon?.id}/';
    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      print(responseData['message']);
      print(responseData['status']);
      if (response.statusCode == 201) {
        isComplete = true;
        notifyListeners();
        return true;
      } else {
        isComplete = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd: $e.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  String getAppointmentsInfo() {
    if (_appointments.isEmpty) {
      return 'Brak wizyt';
    } else {
      // Pobranie aktualnej daty
      final currentDate = DateTime.now();

      // Wybór tylko tych wizyt, które są w przyszłości
      final futureAppointments = _appointments.where((appointment) {
        final bookingDate = DateTime.parse(appointment.dateOfBooking!);
        return bookingDate.isAfter(currentDate) ||
            bookingDate.isAtSameMomentAs(currentDate);
      }).toList();

      if (futureAppointments.isEmpty) {
        return 'Brak';
      }

      // Sortowanie wizyt po dacie
      futureAppointments
          .sort((a, b) => a.dateOfBooking!.compareTo(b.dateOfBooking!));

      // Pobranie daty pierwszej wizyty
      final firstAppointmentDate =
          DateTime.parse(futureAppointments.first.dateOfBooking!);

      // Jeżeli pierwsza wizyta jest dzisiaj
      if (firstAppointmentDate.day == currentDate.day &&
          firstAppointmentDate.month == currentDate.month &&
          firstAppointmentDate.year == currentDate.year) {
        return 'Dzisiaj';
      }
      // Jeżeli pierwsza wizyta jest jutro
      else if (firstAppointmentDate.isAfter(currentDate) &&
          firstAppointmentDate.day == currentDate.day + 1) {
        return 'Jutro';
      }
      // W przeciwnym przypadku zwróć datę pierwszej wizyty
      else {
        final dateFormat = DateFormat('dd.MM');
        return dateFormat.format(firstAppointmentDate);
      }
    }
  }

  bool isAfterBookingDate(AppointmentModel appointment, DateTime startDate) {
    final bookingDate = DateTime.parse(appointment.dateOfBooking!);
    final endDate = startDate.month;
    return bookingDate.month == endDate;
  }

  String getAppointmentsToAcceptInfo() {
    if (_appointments.isEmpty) {
      return 'Brak';
    } else {
      final now = DateTime.now();
      final fifteenMinutesBeforeNow = now.add(const Duration(minutes: 15));

      // Sortowanie wizyt po dacie
      int amountOfAppointmentsToAccept = 0;
      for (var element in _appointments) {
        if (element.status == "P" &&
            DateTime.parse(element.dateOfBooking!)
                .isAfter(fifteenMinutesBeforeNow)) {
          amountOfAppointmentsToAccept++;
        }
      }
      return amountOfAppointmentsToAccept > 0
          ? amountOfAppointmentsToAccept.toString()
          : 'Brak';
    }
  }

  Future<String> sendStatusUpdate(
      int appointmentID, String appointmentStatus) async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return 'Błąd';
    }
    try {
      // Get the current Firebase user
      User? user = FirebaseAuth.instance.currentUser;

      print('[PROCESS] Update status to: $appointmentStatus');
      // Check if user is authenticated
      if (user != null) {
        // Get the Firebase user token
        String? token = await user.getIdToken();

        // Check if token is available
        if (token != null && token.isNotEmpty) {
          // Include the token in the headers
          final response = await http.put(
            Uri.parse(
                'https://api.findovio.nl/api/appointments/${appointmentID.toString()}/update_status/?status=${appointmentStatus.toString()}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
          );
          if (response.statusCode == 200) {
            print('[SUCCESS] Update status to: $appointmentStatus');
            return '201';
          } else {
            print(
                '[FAIL] Update status to: $appointmentStatus, Error: ${response.statusCode.toString()}');
            return response.statusCode.toString();
          }
        } else {
          // Token is not available
          print(
              '[FAIL] Update status to: $appointmentStatus, Error: token_not_available');
          return 'token_not_available';
        }
      } else {
        // User is not authenticated
        print(
            '[FAIL] Update status to: $appointmentStatus, Error: user_not_authenticated');
        return 'user_not_authenticated';
      }
    } catch (e) {
      // Handle any exceptions
      print('[FAIL] Update status to: $appointmentStatus, Error: $e');
      return 'error';
    }
  }

  double calculateTotalPriceForStatusF({DateTime? startDate}) {
    // Jeżeli startDate nie jest dostarczona, ustaw ją na początek obecnego miesiąca
    startDate ??= DateTime.now();

    double totalPrice = 0.0;
    if (_appointments.isNotEmpty) {
      // Iteruj przez wszystkie usługi
      for (var appointment in appointments!) {
        // Sprawdź czy status jest 'F' i data rezerwacji jest po początkowej dacie
        if ((appointment.status == 'C' || appointment.status == 'F') &&
            isAfterBookingDate(appointment, startDate)) {
          String tempPrice = appointment.totalAmount ?? '';
          totalPrice += double.parse(tempPrice);
        }
      }
    }
    return totalPrice;
  }

  List<String> getShortWeekdayNames() {
    final now = DateTime.now();
    final shortWeekdayNames = <String>[];
    initializeDateFormatting('pl_PL');
    final dateFormat = DateFormat('EEEE', 'pl_PL');

    for (int i = 0; i < 7; i++) {
      final fullDayName = dateFormat.format(now.add(Duration(days: i)));
      final shortDayName = getShortDayName(fullDayName);
      shortWeekdayNames.add(shortDayName);
    }

    return shortWeekdayNames;
  }

  String getShortDayName(String fullDayName) {
    switch (fullDayName) {
      case 'poniedziałek':
        return 'PN';
      case 'wtorek':
        return 'WT';
      case 'środa':
        return 'ŚR';
      case 'czwartek':
        return 'CZW';
      case 'piątek':
        return 'PT';
      case 'sobota':
        return 'SO';
      case 'niedziela':
        return 'ND';
      default:
        return '';
    }
  }

  List<int> getAppointmentCountsPerDay(List<AppointmentModel> appointments) {
    final appointmentCounts = List<int>.filled(
        7, 0); // Inicjalizacja listy z zerami dla każdego dnia tygodnia

    final currentDate = DateTime.now();
    final futureAppointments = _appointments.where((appointment) {
      final bookingDate = DateTime.parse(appointment.dateOfBooking!);
      return (bookingDate.isAfter(currentDate) ||
              bookingDate.isAtSameMomentAs(currentDate)) &&
          bookingDate.isBefore(currentDate.add(const Duration(days: 6)));
    }).toList();

    // Sortowanie wizyt po dacie
    futureAppointments
        .sort((a, b) => a.dateOfBooking!.compareTo(b.dateOfBooking!));

    final tempFutureAppointments = getWeekdayNumbersFromToday();

    // Iteracja przez wizyty i zliczanie wizyt dla każdego dnia tygodnia
    for (var appointment in futureAppointments) {
      final bookingDate = DateTime.parse(appointment.dateOfBooking!);
      final weekday = bookingDate.weekday -
          1; // Weekday zwraca wartość od 1 (poniedziałek) do 7 (niedziela), więc odejmujemy 1

      // Jeżeli status wizyty jest 'C' lub 'F', zwiększ liczbę wizyt dla danego dnia tygodnia
      if (appointment.status == 'C' || appointment.status == 'P') {
        appointmentCounts[tempFutureAppointments.indexOf(weekday + 1)]++;
      }
    }

    return appointmentCounts;
  }

  List<int> getWeekdayNumbersFromToday() {
    final currentDate = DateTime.now();
    final weekdayNumbers = <int>[];

    for (int i = 0; i < 7; i++) {
      weekdayNumbers.add((currentDate.weekday + i) % 7 == 0
          ? 7
          : (currentDate.weekday + i) % 7);
    }

    return weekdayNumbers;
  }

  int getWeekNumber(DateTime date) {
    // Oblicz dzień tygodnia dla danej daty (0 - poniedziałek, 6 - niedziela)
    int weekday = date.weekday;

    // Jeśli dzień tygodnia to niedziela (7), ustaw go na 0 (poniedziałek)
    if (weekday == 7) {
      weekday = 0;
    }

    // Oblicz numer tygodnia na podstawie liczby dni, które minęły od początku roku
    int weekNumber =
        ((date.difference(DateTime(date.year, 1, 1)).inDays) / 7).ceil();

    // Jeśli numer tygodnia wynosi 0, oznacza to, że jesteśmy w ostatnim tygodniu poprzedniego roku
    if (weekNumber == 0) {
      weekNumber = getWeekNumber(DateTime(date.year - 1, 12, 31));
    }

    return weekNumber;
  }
}
