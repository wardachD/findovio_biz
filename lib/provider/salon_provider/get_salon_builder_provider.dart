import 'package:flutter/material.dart';

import '../../models/get_salon_model.dart';

class GetSalonBuilderProvider extends ChangeNotifier {
  List<Categories> _categories = [];

  List<Categories> get categories => _categories;
  List<Services> _services = [];

  List<Services> get services => _services;
  bool get isServicesEmptyVariable => _services.isEmpty;

  // Dodaj metodę do aktualizacji usługi
  void updateService(Services updatedService, Services oldService) {
    final index =
        _services.indexWhere((service) => service.id == oldService.id);
    if (index != -1) {
      _services[index] = updatedService;
      print('Usługa zaktualizowana: ${updatedService.title}');
      notifyListeners();
    }
  }

  int getTotalServicesCount() {
    return _services.length;
  }

  int getServicesWithNullCategoryCount() {
    return _services.where((service) => service.category == null).length;
  }

  bool isServicesEmpty() {
    return _services.isEmpty;
  }

  // Metoda do pobierania usługi na podstawie jej ID
  Services? getServiceById(int id) {
    return _services.firstWhere((service) => service.id == id);
  }

  // Dodaj metodę do usuwania usługi
  void removeService(int index) {
    _services.removeAt(index);
    if (_services.isEmpty) {}
    notifyListeners();
  }

  // Dodaj metodę do dodawania usługi
  void addService(Services service) {
    _services.add(service);
    print('Nowa usługa dodana: ${service.title}');
    notifyListeners();
  }

  // Dodaj metodę do ustawiania listy usług
  void setServices(List<Services> newServices) {
    _services = newServices;
    notifyListeners();
  }

  // Dodaj metodę do aktualizacji kategorii
  void updateCategory(Categories updatedCategory, Categories oldCategory) {
    final index =
        _categories.indexWhere((category) => category.name == oldCategory.name);
    if (index != -1) {
      _categories[index] = updatedCategory;
      print('kategoria zaktualizowana: $updatedCategory');
      notifyListeners();
    }
  }

  bool isCategoriesListEmpty() {
    return _categories.isEmpty;
  }

  // Dodaj metodę do usuwania kategorii
  void removeCategory(int index) {
    _categories.removeAt(index);
    notifyListeners();
  }

  // Dodaj metodę do dodawania kategorii
  void addCategory(Categories category) {
    _categories.add(category);
    print('Nowa kategoria dodana: ${category.name}');
    notifyListeners();
  }

  void setCategories(List<Categories> newCategories) {
    _categories = newCategories;
    notifyListeners();
  }
}
