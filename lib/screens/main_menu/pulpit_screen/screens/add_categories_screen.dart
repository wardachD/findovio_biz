// ignore_for_file: avoid_print

import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_builder_provider.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../../widgets/loading_popup.dart';
import '../widgets/go_back_arrow.dart';

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({super.key});

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final GetSalonProvider _salonModelProvider = GetSalonProvider();
  final TextEditingController _categoryNameController = TextEditingController();

  bool isDisabled = true;
  void mainSetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoBackArrow(),
              // Nagłówek, który będzie zajmował 15% wysokości ekranu
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dodaj kategorie usług',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Podaj tylko ich nazwę, będą to widzieli użytkownicy dzięki czemu łatwiej będzie im znaleźć odpowiednią usługę.',
                      style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 54, 206, 244),
                        Color.fromARGB(255, 243, 128, 33),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.0, 0.5, 1.0],
                      tileMode: TileMode.clamp,
                      transform: GradientRotation(135 * 3.1415926535 / 180),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              _buildBottomSheet(context, null),
                        ).then((value) => _categoryNameController.clear());
                      },
                      child: const Center(
                        child: Text(
                          'Dodaj kategorię',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 6,
                  ),
                  Text(
                    'Żeby edytować kliknij na kafelek usługi',
                    style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              // Reszta dostępnego miejsca zajęte przez Expanded
              Expanded(
                child: Consumer<GetSalonBuilderProvider>(
                  builder: (context, categoriesProvider, _) {
                    final categories = categoriesProvider.categories;
                    if (categories.isEmpty) {
                      return Container(); // Nic nie wyświetlamy, gdy brak kategorii
                    }
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 245, 245),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            onTap: () {
                              showModalBottomSheet(
                                showDragHandle: true,
                                context: context,
                                backgroundColor: Colors.white,
                                isScrollControlled: true,
                                builder: (context) =>
                                    _buildBottomSheet(context, category),
                              );
                            },
                            leading: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            title: Text(
                              category.name ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  // Remove category at this index
                                  if (context
                                          .read<GetSalonBuilderProvider>()
                                          .categories[index]
                                          .id !=
                                      null) {
                                    showDialog(
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const LoadingPopup();
                                      },
                                    );

                                    try {
                                      // Wykonanie żądania createCategories
                                      var res = await _salonModelProvider
                                          .deleteCategory(context
                                              .read<GetSalonBuilderProvider>()
                                              .categories[index]
                                              .id!);

                                      categoriesProvider.removeCategory(index);
                                      print(res);
                                    } catch (e) {
                                      // Obsługa błędu
                                      print(e);
                                    } finally {
                                      // Ukrycie popupu ładowania po zakończeniu żądania
                                      if (mounted) {
                                        Navigator.pop(
                                            context); // Zamknij popup ładowania}
                                      }
                                    }
                                  }
                                }),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: context
                            .read<GetSalonBuilderProvider>()
                            .categories
                            .isEmpty
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 185, 185, 185))
                        : MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 20, 20, 20)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                onPressed: () async {
                  _categoryNameController.clear();
                  showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const LoadingPopup();
                    },
                  );
                  context
                      .read<GetSalonBuilderProvider>()
                      .categories
                      .forEach((category) {
                    print(category.name);
                  });
                  Get.back();
                  Get.back();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Przejdź dalej',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context, Categories? categoryToEdit) {
    _categoryNameController.text =
        categoryToEdit?.name ?? _categoryNameController.text;
    return StatefulBuilder(builder: (BuildContext context,
        StateSetter setStateBottomSheet /*You can rename this!*/) {
      return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      categoryToEdit == null
                          ? 'Wpisz nazwę kategorii'
                          : 'Edytuj kategorię',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(categoryToEdit == null
                        ? 'Najlepiej użyj ogólnej nazwy dla większej ilości usług'
                        : categoryToEdit.name.toString()),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
              CustomTextField(
                textCapitalization: TextCapitalization.words,
                showSuffix: true,
                onChanged: (value) {
                  if (value.length > 1) {
                    setStateBottomSheet(() {
                      isDisabled = false;
                    });
                  } else {
                    setStateBottomSheet(() {
                      isDisabled = true;
                    });
                  }
                  print(value);
                },
                controller: _categoryNameController,
                labelText: categoryToEdit == null
                    ? 'Nazwa kategorii'
                    : 'Nowa nazwa kategorii',
                hintText: categoryToEdit == null
                    ? 'Przykład: Strzyżenie'
                    : 'Przykład: Farbowanie',
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: isDisabled
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 185, 185, 185))
                        : MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 20, 20, 20)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                onPressed: () async {
                  print('1');
                  if (_categoryNameController.text.length > 1) {
                    print('2');
                    // Dodaj nową kategorię po naciśnięciu przycisku "Zatwierdź"

                    if (categoryToEdit == null) {
                      print('4a');
                      context.read<GetSalonBuilderProvider>().addCategory(
                          Categories(
                              salon: context.read<GetSalonProvider>().salon?.id,
                              name: _categoryNameController.text));

                      try {
                        // Wykonanie żądania createCategories
                        List<Categories> categoryToCreate = [];
                        categoryToCreate.add(context
                            .read<GetSalonBuilderProvider>()
                            .categories
                            .firstWhere(
                              (element) =>
                                  element.name == _categoryNameController.text,
                            ));
                        var res = await _salonModelProvider
                            .createCategories(categoryToCreate);

                        print(res);
                      } catch (e) {
                        // Obsługa błędu
                        print(e);
                      } finally {
                        // Ukrycie popupu ładowania po zakończeniu żądania
                        Navigator.pop(context); // Zamknij popup ładowania
                      }
                    } else {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const LoadingPopup();
                        },
                      );
                      print('4b');
                      final categoryInProvider = context
                          .read<GetSalonBuilderProvider>()
                          .categories
                          .firstWhere(
                            (element) => element.name == categoryToEdit.name,
                          );

                      // Zaktualizuj nazwę kategorii
                      context.read<GetSalonBuilderProvider>().updateCategory(
                            categoryInProvider.copyWith(
                                name: _categoryNameController.text),
                            categoryToEdit,
                          );

                      var res = await _salonModelProvider.updateCategory(context
                          .read<GetSalonBuilderProvider>()
                          .categories
                          .firstWhere(
                            (element) =>
                                element.name == _categoryNameController.text,
                          ));
                      print(res);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                    print('5');
                    // Zamknij bottom sheet
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        categoryToEdit == null
                            ? 'Dodaj kategorię'
                            : 'Aktualizuj kategorię',
                        style: const TextStyle(
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
