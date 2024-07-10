import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveFieldsToSharedPreferences({
  required TextEditingController salonNameController,
  required TextEditingController salonAboutController,
  required TextEditingController salonCityController,
  required TextEditingController salonStreetController,
  required TextEditingController salonAddressNumberController,
  required TextEditingController salonPostcodeController,
  required TextEditingController salonCategoryController,
  required TextEditingController salonGenderController,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('salonName', salonNameController.text);
  prefs.setString('salonAbout', salonAboutController.text);
  prefs.setString('salonCity', salonCityController.text);
  prefs.setString('salonStreet', salonStreetController.text);
  prefs.setString('salonAddressNumber', salonAddressNumberController.text);
  prefs.setString('salonPostcode', salonPostcodeController.text);
  prefs.setString('salonCategory', salonCategoryController.text);
  prefs.setString('salonGender', salonGenderController.text);
}
