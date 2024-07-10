import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/main_menu/widgets/alertdialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class ServicesAddScreen extends StatefulWidget {
  const ServicesAddScreen({super.key});

  @override
  State<ServicesAddScreen> createState() => _ServicesAddScreenState();
}

class _ServicesAddScreenState extends State<ServicesAddScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  final valueListenable = ValueNotifier<int?>(null);
  int? _selectedCategory;
  int? _selectedDuration;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _selectedDuration = null;
    _selectedCategory = null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateServiceSettings(String option) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text;
    final description = _descriptionController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final category = _selectedCategory;
    final duration = _selectedDuration;
    final provider = Provider.of<GetSalonProvider>(context, listen: false);

    // Validate price range (already validated in TextFormField validator)

    // Log the collected data
    log('Title: $title');
    log('Description: $description');
    log('Price: $price');
    log('Category: $category');
    log('Duration: $duration');

    // Perform the saving logic here
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return const AlertDialogLoading(
          icon: Icon(Icons.download),
          title: 'Aktualizuję bazę danych',
          message: 'Zmieniamy dane twojej usługi.',
        );
      },
    );
    switch (option) {
      case 'save':
        Services newService = Services(
            title: title,
            description: description,
            durationMinutes: duration,
            category: category,
            price: price.toString(),
            salon: provider.salon!.id!);

        final successCreateNew = await provider.createServices(newService);

        if (successCreateNew) {
          await provider.fetchSalon(false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usługa została dodana pomyślnie')),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Błąd przy dodawaniu usługi')),
          );
        }
        break;
      default:
        return;
    }

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<GetSalonProvider>(context).salon?.categories ?? [];
    final durationOptions = List<int>.generate(26, (index) => (index + 1) * 5);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Dodaj/usuń lub modyfikuj usługi',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Divider(
                    color: Color.fromARGB(255, 228, 228, 228), height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Pamiętaj żeby używać łatwych nazw i opisów w których umieścisz jak najwięcej informacji przydatnych dla użytkownika, zwiększy to ilość Twoich rezerwacji.',
                      ),
                      const Divider(
                          color: Color.fromARGB(255, 228, 228, 228),
                          height: 24),
                      const SizedBox(height: 12),
                      TextFormField(
                        maxLines: null,
                        maxLength: 60,
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nazwa usługi',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nazwa usługi nie może być pusta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        maxLength: 100,
                        maxLines: null,
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Opis',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Opis usługi nie może być pusty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        maxLength: 6,
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Cena',
                          helperText: 'Cena od 1 do 500.99',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Cena nie może być pusta';
                          }
                          final price = double.tryParse(value);
                          if (price == null || price < 1 || price > 500.99) {
                            return 'Podaj cenę od 1 do 500.99';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField2<int>(
                        value: _selectedDuration,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: const Text('Czas trwania (minuty)'),
                          helperText:
                              'Czas można wybrać tylko w interwałach 5 minutowych.',
                        ),
                        hint: const Text(
                          'Zmień czas trwania',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: durationOptions.map((duration) {
                          return DropdownMenuItem(
                            value: duration,
                            child: Text('$duration minut'),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Proszę wybrać czas trwania.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedDuration = value;
                          });
                        },
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: const Offset(0, 20),
                          maxHeight: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField2<int>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          label: const Text('Kategoria usługi'),
                          helperText:
                              'Tworzenie nowej kategorii znajdziesz na poprzedniej stronie.',
                        ),
                        value: _selectedCategory,
                        hint: const Text(
                          'Zmień kategorię',
                          style: TextStyle(fontSize: 14),
                        ),
                        items: categories.map((category) {
                          return DropdownMenuItem(
                            value: category.id,
                            child: Text(category.name!),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Proszę wybrać kategorię.';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                        ),
                        dropdownStyleData: DropdownStyleData(
                          offset: const Offset(0, 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none)),
                        onPressed: () => _updateServiceSettings('save'),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Zapisz',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Cofnij',
                            style: TextStyle(
                                color: Color.fromARGB(255, 128, 128, 128)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
