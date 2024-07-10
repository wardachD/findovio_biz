import 'dart:convert';

import 'package:findovio_business/models/create_category_model.dart';
import 'package:findovio_business/models/create_foh_model.dart';
import 'package:findovio_business/models/create_salon_model.dart';
import 'package:findovio_business/models/create_service_model.dart';
import 'package:findovio_business/provider/api_service.dart';
import 'package:findovio_business/provider/globals.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateSalonProvider extends ChangeNotifier {
  CreateSalonModel _salons = CreateSalonModel(errorCode: 1);
  List<CreateCategoryModel> _categories = [];
  List<CreateServiceModel> _services = [];
  List<CreateFOHModel> _operatingHours = [];
  late SharedPreferences _prefs;

  CreateSalonProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    bool isConnected = await hasInternetConnection();
    if (!isConnected) {
      const SnackBar snackBar = SnackBar(
          content: Text("Brak internetu. Sprawdź połączenie."),
          duration: Duration(seconds: 3));
      snackbarKey.currentState?.showSnackBar(snackBar);

      return;
    }
    _prefs = await SharedPreferences.getInstance();
    String? salonsJson = _prefs.getString('salons');
    if (salonsJson != null) {
      _salons = CreateSalonModel.fromJson(jsonDecode(salonsJson));
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    await _prefs.setString('salons', jsonEncode(_salons.toJson()));
  }

  // Metody do ustawiania danych w providera
  void setSalons(CreateSalonModel salons) {
    _salons = salons;
    notifyListeners();
  }

  void setSalonsWithoutNotify(CreateSalonModel salons) {
    _salons = salons;
  }

  void setCategories(List<CreateCategoryModel> categories) {
    _categories = categories;
    notifyListeners();
  }

  void setServices(List<CreateServiceModel> services) {
    _services = services;
    notifyListeners();
  }

  void setOperatingHours(List<CreateFOHModel> operatingHours) {
    _operatingHours = operatingHours;
    notifyListeners();
  }

  // Metody do pobierania danych z providera
  CreateSalonModel get salons => _salons;
  List<CreateCategoryModel> get categories => _categories;
  List<CreateServiceModel> get services => _services;
  List<CreateFOHModel> get operatingHours => _operatingHours;
}
