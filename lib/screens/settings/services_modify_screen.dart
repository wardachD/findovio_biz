import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/main_menu/widgets/alertdialog_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class ServicesModifyScreen extends StatefulWidget {
  final Services service;

  const ServicesModifyScreen({super.key, required this.service});

  @override
  State<ServicesModifyScreen> createState() => _EditServiceScreenState();
}

class _EditServiceScreenState extends State<ServicesModifyScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final valueListenable = ValueNotifier<int?>(null);
  int? _selectedCategory;
  int? _selectedDuration;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.service.title);
    _descriptionController =
        TextEditingController(text: widget.service.description);
    _selectedDuration = widget.service.durationMinutes;

    // Setting the default value for _selectedCategory
    final categories = Provider.of<GetSalonProvider>(context, listen: false)
            .salon
            ?.categories ??
        [];
    if (categories.isNotEmpty && _selectedCategory == null) {
      _selectedCategory = categories.first.id;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateServiceSettings(String option) async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final category = _selectedCategory;
    final duration = _selectedDuration;
    final provider = Provider.of<GetSalonProvider>(context, listen: false);

    // Log the collected data
    log('Title: $title');
    log('Description: $description');
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
          message: 'Zmieniamy cenę twojej usługi.',
        );
      },
    );
    switch (option) {
      case 'delete':
        var res = await provider.deleteService(widget.service.id!);
        if (res) {
          await provider.fetchSalon(false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Usunięto: ${widget.service.title}')),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Błąd podczas usuwania: ${widget.service.title}')),
          );
        }
      case 'save':
        if (title != widget.service.title ||
            description != widget.service.description ||
            category != widget.service.category ||
            duration != widget.service.durationMinutes) {
          Services changeIsAvailableService =
              widget.service.copyWith(isAvailable: false);
          Services updatedService = widget.service.copyWith(
              title: title,
              description: description,
              durationMinutes: duration,
              category: category,
              price: widget.service.price);

          final successDeleteOld =
              await provider.updateService(changeIsAvailableService);
          final successCreateNew =
              await provider.createServices(updatedService);

          // Close the loading dialog

          if (successDeleteOld && successCreateNew) {
            await provider.fetchSalon(false);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cena zaktualizowana pomyślnie')),
            );
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Błąd przy aktualizacji ceny')),
            );
          }
        } else {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Brak zmian.')),
          );
        }
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                      color: Color.fromARGB(255, 228, 228, 228), height: 24),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLength: 60,
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Nazwa usługi',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    maxLength: 100,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Opis',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField2<int>(
                    value: _selectedDuration,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
                            BorderSide.none)),
                    onPressed: () => _updateServiceSettings('delete'),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Usuń usługę',
                            style: TextStyle(
                                color: Color.fromARGB(255, 252, 89, 78))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
