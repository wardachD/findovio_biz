// Teraz suffix kontrolera czasu nie zmienia właściwości przycisku

import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/widgets/custom_text_field.dart';
import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_services_widgets/time_picker_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../../../../provider/salon_provider/get_salon_builder_provider.dart';
import '../../widgets/loading_popup.dart';
import '../widgets/go_back_arrow.dart';

class AddServicesScreen extends StatefulWidget {
  const AddServicesScreen({super.key});

  @override
  State<AddServicesScreen> createState() => _AddServicesScreenState();
}

class _AddServicesScreenState extends State<AddServicesScreen> {
  final TextEditingController _serviceNameController = TextEditingController();
  final TextEditingController _serviceDescriptionController =
      TextEditingController();
  final TextEditingController _servicePriceController = TextEditingController();
  final TextEditingController _serviceDurationController =
      TextEditingController();
  GetSalonProvider _salonModelProvider = GetSalonProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _salonModelProvider = Provider.of<GetSalonProvider>(context, listen: false);
  }

  void clearControllers() {
    _serviceNameController.clear();
    _serviceDescriptionController.clear();
    _servicePriceController.clear();
    _serviceDurationController.clear();
  }

  bool verifyControllers() {
    return _serviceNameController.text.length > 1 &&
        _serviceDescriptionController.text.length > 1 &&
        _servicePriceController.text.length > 1 &&
        _serviceDurationController.text.length > 1;
  }

  bool isDisabled = true;
  bool isTitle = false;
  bool isDescription = false;
  bool isPrice = false;
  bool isTime = false;

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
                      'Dodaj wszystkie usługi',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Podaj ich nazwę, opis, cenę oraz koszt. Wszystkie te informacje będą widoczne dla użytkownika, możesz je zmienić w przyszłości',
                      style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 50,
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
                          backgroundColor: Colors.white,
                          showDragHandle: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) =>
                              _buildBottomSheet(context, null),
                        ).then((value) => clearControllers());
                      },
                      child: const Center(
                        child: Text(
                          'Dodaj usługę',
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
                  builder: (context, servicesProvider, _) {
                    final services = servicesProvider.services;
                    if (services.isEmpty) {
                      return Container(); // Nic nie wyświetlamy, gdy brak kategorii
                    }
                    return ListView.builder(
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final service = services[index];
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
                                isScrollControlled: true,
                                builder: (context) =>
                                    _buildBottomSheet(context, service),
                              );
                            },
                            leading: Text(
                              '${index + 1}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            title: Text(
                              service.title ?? '',
                              style: const TextStyle(fontSize: 16),
                            ),
                            subtitle: Text(
                              service.description ?? '',
                            ),
                            trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  if (context
                                          .read<GetSalonBuilderProvider>()
                                          .services[index]
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
                                          .deleteService(context
                                              .read<GetSalonBuilderProvider>()
                                              .services[index]
                                              .id!);

                                      servicesProvider.removeService(index);

                                      print(
                                          _salonModelProvider.isSchedulesEmpty);
                                      print(res);
                                    } catch (e) {
                                      // Obsługa błędu
                                      print(e);
                                    } finally {
                                      // Ukrycie popupu ładowania po zakończeniu żądania
                                      if (mounted) {
                                        servicesProvider.notifyListeners();
                                      }
                                      Navigator.pop(
                                          context); // Zamknij popup ładowania
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
                    backgroundColor:
                        context.read<GetSalonBuilderProvider>().services.isEmpty
                            ? MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 185, 185, 185))
                            : MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                onPressed: () async {
                  showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const LoadingPopup();
                    },
                  );
                  _salonModelProvider.getVerificationStatus(context);
                  clearControllers();
                  Get.back();
                  Get.back();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Zapisz i przejdź dalej',
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

  Widget _buildBottomSheet(BuildContext context, Services? serviceToEdit) {
    _serviceNameController.text =
        serviceToEdit?.title ?? _serviceNameController.text;
    _serviceDescriptionController.text =
        serviceToEdit?.description ?? _serviceDescriptionController.text;
    _servicePriceController.text =
        serviceToEdit?.price ?? _servicePriceController.text;
    _serviceDurationController.text =
        serviceToEdit?.durationMinutes.toString() ??
            _serviceDurationController.text;

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateBottomSheet) {
      return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nagłówek
                    Text(
                      serviceToEdit == null
                          ? 'Stwórz nową usługę'
                          : 'Edytuj usługę',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(serviceToEdit == null
                        ? 'Wszystkie pola są wymagane, możesz je zmienić w przyszłości.'
                        : serviceToEdit.title.toString()),
                    const SizedBox(height: 18),
                  ],
                ),
              ),

              // Nazwa usługi
              const Text(
                'Wprowadź nazwę usługi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                showSuffix: true,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setStateBottomSheet(() {
                      isTitle = false;
                    });
                  } else {
                    setStateBottomSheet(() {
                      isTitle = true;
                    });
                  }
                  print(value);
                },
                controller: _serviceNameController,
                hintText: serviceToEdit == null
                    ? 'Przykład: Farbowanie Blond'
                    : 'Przykład: Strzyżenie Męskie',
                labelText: 'Nazwa usługi',
              ),
              const SizedBox(height: 12),
              // Opis usługi
              const Text(
                'Wprowadź jej opis',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                textCapitalization: TextCapitalization.words,
                showSuffix: true,
                onChanged: (value) {
                  if (value.isEmpty) {
                    setStateBottomSheet(() {
                      isDescription = false;
                    });
                  } else {
                    setStateBottomSheet(() {
                      isDescription = true;
                    });
                  }
                  print(value);
                },
                controller: _serviceDescriptionController,
                labelText: 'Opis usługi',
                hintText: 'Przykład: Szybkie, precyzyjne strzyżenie włosów.',
              ),
              const SizedBox(height: 12),

              // Cena usługi + Czas usługi
              SizedBox(
                height: 102,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.41,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Podaj cenę',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            enableSuggestions: false,
                            keyboardType: TextInputType.number,
                            showSuffix: true,
                            onChanged: (value) {
                              if (value.length < 2) {
                                setStateBottomSheet(() {
                                  isPrice = false;
                                });
                              } else {
                                setStateBottomSheet(() {
                                  isPrice = true;
                                });
                              }
                              print(value);
                            },
                            controller: _servicePriceController,
                            hintText: '€90',
                            labelText: 'Cena',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    // Długość w minutach usługi
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.41,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ile trwa?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            readOnly: true,
                            showSuffix: true,
                            onTap: () {
                              showDialog(
                                barrierColor:
                                    const Color.fromARGB(200, 255, 255, 255),
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return TimePickerPopup(
                                    controller: _serviceDurationController,
                                  );
                                },
                              ).then((value) => setState(() {
                                    if (_serviceDurationController
                                        .text.isNotEmpty) {
                                      setStateBottomSheet(() {
                                        isTime = true;
                                      });
                                    } else {
                                      setStateBottomSheet(() {
                                        isTime = false;
                                      });
                                    }
                                  }));
                            },
                            controller: _serviceDurationController,
                            hintText: 'Minuty',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 20, 20, 20)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none)),
                onPressed: () async {
                  var verifyController = verifyControllers();
                  if (verifyController) {
                    // Dodaj nową kategorię po naciśnięciu przycisku "Zatwierdź"

                    if (serviceToEdit == null) {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const LoadingPopup();
                        },
                      );
                      context.read<GetSalonBuilderProvider>().addService(
                          Services(
                              salon: context.read<GetSalonProvider>().salon?.id,
                              title: _serviceNameController.text,
                              description: _serviceDescriptionController.text,
                              price: _servicePriceController.text,
                              durationMinutes: int.tryParse(
                                  _serviceDurationController.text)));
                      try {
                        // Wykonanie żądania createCategories
                        var res = await _salonModelProvider.createServices(
                            context
                                .read<GetSalonBuilderProvider>()
                                .services
                                .firstWhere(
                                  (element) =>
                                      element.title ==
                                      _serviceNameController.text,
                                ));
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
                      final serviceInProvider = context
                          .read<GetSalonBuilderProvider>()
                          .services
                          .firstWhere(
                            (element) => element.title == serviceToEdit.title,
                          );

                      // Zaktualizuj nazwę kategorii
                      context.read<GetSalonBuilderProvider>().updateService(
                            serviceInProvider.copyWith(
                                title: _serviceNameController.text,
                                price: _servicePriceController.text,
                                durationMinutes:
                                    int.parse(_serviceDurationController.text),
                                description:
                                    _serviceDescriptionController.text),
                            serviceToEdit,
                          );
                      try {
                        // Wykonanie żądania createCategories
                        var res = await _salonModelProvider.updateService(
                            context
                                .read<GetSalonBuilderProvider>()
                                .services
                                .firstWhere(
                                  (element) =>
                                      element.title ==
                                      _serviceNameController.text,
                                ));
                        print(res);
                      } catch (e) {
                        // Obsługa błędu
                        print(e);
                      } finally {
                        // Ukrycie popupu ładowania po zakończeniu żądania
                      }
                    }
                    final getSalonProvider =
                        Provider.of<GetSalonProvider>(context, listen: false);
                    await getSalonProvider
                        .getServices(getSalonProvider.salon?.id ?? 0);

                    context
                        .read<GetSalonBuilderProvider>()
                        .setServices(getSalonProvider.services ?? []);
                    mainSetState();
                    Navigator.pop(context); // Zamknij popup ładowania
                    clearControllers();
                    Navigator.pop(context); // Zamknij bottom sheet
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        serviceToEdit == null
                            ? 'Dodaj usługę'
                            : 'Aktualizuj usługę',
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
// 5, 4.5, 5, 3.5,