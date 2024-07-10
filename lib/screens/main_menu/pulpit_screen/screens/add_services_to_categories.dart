import 'package:findovio_business/models/get_salon_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../provider/salon_provider/get_salon_provider.dart';
import '../../../../provider/salon_provider/get_salon_builder_provider.dart';
import '../../widgets/loading_popup.dart';
import '../widgets/go_back_arrow.dart';

class AddServicesToCategoriesScreen extends StatefulWidget {
  const AddServicesToCategoriesScreen({super.key});

  @override
  State<AddServicesToCategoriesScreen> createState() =>
      _AddServicesToCategoriesScreenState();
}

class _AddServicesToCategoriesScreenState
    extends State<AddServicesToCategoriesScreen> {
  GetSalonProvider _salonModelProvider = GetSalonProvider();
  List<Services> selectedServices = [];
  bool collapseTitle = false;
  bool isDisabled = true;

  void mainSetState() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _salonModelProvider = Provider.of<GetSalonProvider>(context, listen: false);
  }

  int getTotalServicesCount(List<Services> services) {
    return services.length;
  }

  int getServicesWithNullCategoryCount(List<Services> services) {
    return services.where((service) => service.category == null).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const GoBackArrow(),
              // Nagłówek, który będzie zajmował 15% wysokości ekranu
              SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pogrupuj usługi do kategorii',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Wybierz po kolei każdą kategorię i przypisz do niej usługi. Użytkownicy chętniej wybierają usługi w salonach gdzie mają łatwy wibór.',
                      style: TextStyle(color: Color.fromARGB(255, 87, 87, 87)),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Żeby rozwinąć kategorię kliknij',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 87, 87, 87)),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Żeby dodać usługę do kategorii kliknij',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 87, 87, 87)),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(Icons.add),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Consumer<GetSalonBuilderProvider>(
                        builder: (context, servicesProvider, _) {
                      if (servicesProvider.getServicesWithNullCategoryCount() !=
                          0) {
                        return Text(
                            'Pozostało usług: ${servicesProvider.getServicesWithNullCategoryCount()}/${servicesProvider.getTotalServicesCount()}');
                      }
                      return (const SizedBox());
                    }),
                  ],
                ),
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
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.only(left: 12),
                              onExpansionChanged: (value) => {
                                setState(() {
                                  collapseTitle = value;
                                }),
                              },
                              collapsedBackgroundColor:
                                  const Color.fromARGB(255, 241, 241, 241),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              title: Text(
                                category.name ?? '',
                              ),
                              trailing: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.25,
                                child: Row(children: [
                                  IconButton.filled(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {
                                      showModalBottomSheet(
                                        showDragHandle: true,
                                        context: context,
                                        backgroundColor: Colors.white,
                                        isScrollControlled: true,
                                        builder: (context) {
                                          return Consumer<
                                              GetSalonBuilderProvider>(
                                            builder:
                                                (context, servicesProvider, _) {
                                              final services =
                                                  servicesProvider.services;
                                              if (services.isEmpty) {
                                                return Container(); // Nic nie wyświetlamy, gdy brak kategorii
                                              }
                                              // Zwróć budowane bottom sheet
                                              return _buildBottomSheet(
                                                  context, services, category);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const Icon(Icons.expand_more),
                                ]),
                              ),
                              children: [
                                _buildServicesList(context, category),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Consumer<GetSalonBuilderProvider>(
                builder: (context, servicesProvider, _) {
                  return OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: servicesProvider
                                    .getServicesWithNullCategoryCount() >
                                0
                            ? MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 185, 185, 185))
                            : MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                        side: MaterialStateProperty.all<BorderSide>(
                            BorderSide.none)),
                    onPressed: () async {
                      showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const LoadingPopup();
                        },
                      );
                      if (servicesProvider.getServicesWithNullCategoryCount() ==
                          0) {
                        _salonModelProvider.getVerificationStatus(context);
                        Get.back();
                      }
                      Get.back();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            servicesProvider
                                        .getServicesWithNullCategoryCount() >
                                    0
                                ? 'Zostało usług: ${servicesProvider.getServicesWithNullCategoryCount()}'
                                : ' Zapisz',
                            style: const TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  );
                },
              ),
              // OutlinedButton(
              //   style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all<Color>(
              //           const Color.fromARGB(255, 185, 185, 185)),
              //       side:
              //           MaterialStateProperty.all<BorderSide>(BorderSide.none)),
              //   onPressed: () async {
              //     Get.back();
              //   },
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Zapisz i przejdź dalej',
              //           style: TextStyle(
              //             color: Colors.white,
              //           )),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(
      BuildContext context, List<Services> services, Categories category) {
    int whenToShowNoServiceWithoutCategory = 0;
    services.forEach((element) {
      if (element.category == null) {
        whenToShowNoServiceWithoutCategory++;
      }
    });
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setStateBottomSheet) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nagłówek
                      const Text(
                        'Dodaj usługę do kategorii:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${category.name}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Zaznacz usługi które chcesz przypisać',
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
                if (whenToShowNoServiceWithoutCategory == 0)
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color.fromARGB(255, 238, 238, 238))),
                    child: const Column(
                      children: [
                        Text(
                            'Brak usług do przypisania, wszystkie mają już kategorie.')
                      ],
                    ),
                  ),

                // Lista usług
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    final service = services[index];
                    final isSelected = selectedServices.contains(service);
                    if (service.category == null) {
                      return ListTile(
                        title: Text(service.title ?? ''),
                        subtitle: Text(service.description ?? ''),
                        trailing: Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setStateBottomSheet(() {
                              if (value != null && value) {
                                selectedServices.add(service);
                              } else {
                                selectedServices.remove(service);
                              }
                            });
                          },
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Przycisk "Dalej"
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: selectedServices.isEmpty
                        ? MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 185, 185, 185))
                        : MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 20, 20, 20)),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                  ),
                  onPressed: () async {
                    showDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const LoadingPopup();
                      },
                    );
                    // Lista ID wybranych usług
                    List<int> selectedServicesID = [];

                    for (var selectedService in selectedServices) {
                      var updatedService =
                          selectedService.updateCategory(category.id!);
                      var index = selectedServices.indexWhere(
                          (service) => service.id == selectedService.id);
                      if (index != -1) {
                        selectedServicesID.add(selectedService.id!);
                        selectedServices[index] = updatedService;
                      }

                      print(selectedService.toJson());
                    }
                    // Zaktualizuj dane w dostawcy danych (providerze)
                    for (var selectedService in selectedServices) {
                      // Znajdź indeks usługi w liście services
                      int index = services.indexWhere(
                          (service) => service.id == selectedService.id);

                      if (index != -1) {
                        // Zaktualizuj dane w dostawcy danych
                        context
                            .read<GetSalonBuilderProvider>()
                            .updateService(selectedService, services[index]);
                      }
                    }
                    print(selectedServicesID.length);
                    // Wywołaj zapytanie updateService dla zmienionych usług
                    for (int id in selectedServicesID) {
                      // Pobierz usługę z odpowiedniego dostawcy danych (jeśli potrzebujesz)
                      // Jeśli używasz jednego dostawcy danych na wszystkie usługi, możesz pominąć ten krok
                      Services? serviceToUpdate = context
                          .read<GetSalonBuilderProvider>()
                          .getServiceById(id);
                      // Jeśli usługa została znaleziona, wywołaj zapytanie updateService
                      if (serviceToUpdate != null) {
                        var res = await _salonModelProvider
                            .updateService(serviceToUpdate);
                        print('${serviceToUpdate.id} = $res');
                      }
                    }

                    // Zamknij bottom sheet
                    final getSalonProvider =
                        Provider.of<GetSalonProvider>(context, listen: false);

                    await getSalonProvider.fetchSalon(false);

                    context.read<GetSalonBuilderProvider>().setCategories(
                        getSalonProvider.salon?.categories ?? []);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dalej',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildServicesList(BuildContext context, Categories category) {
    return Consumer<GetSalonProvider>(
      builder: (context, salonProvider, _) {
        final services = salonProvider.services;
        if (services!.isEmpty) {
          return Container(); // Zwróć pusty kontener, jeśli brak usług
        }
        // Filtruj usługi, aby wyświetlić tylko te dla danej kategorii
        final categoryServices = services
            .where((service) => service.category == category.id)
            .toList();
        // Buduj listę ListTile dla usług danej kategorii
        return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: categoryServices.length,
          itemBuilder: (context, index) {
            final service = categoryServices[index];
            return Container(
              padding: EdgeInsets.zero,
              color: const Color.fromARGB(255, 248, 248, 248),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: Column(
                  children: [
                    const Divider(
                      color: Colors.white,
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 241, 241, 241),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 26,
                          child: Text(
                            textAlign: TextAlign.center,
                            '${index + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 87, 87, 87)),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                //Tytuł i opis
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      service.title ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    FittedBox(
                                      // Maksymalna wysokość dla opisu (2 linie tekstu)
                                      child: SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                                0.5,
                                        child: Text(
                                          service.description ?? '',
                                          overflow: TextOverflow
                                              .ellipsis, // Przycinaj tekst, jeśli wychodzi poza obszar
                                          maxLines:
                                              5, // Maksymalnie 2 linie opisu
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Cena i przycisk
                                SizedBox(
                                  width: 114,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '€${service.price}', // Cena
                                            style: const TextStyle(// Kolor ceny
                                                ),
                                          ),
                                          Text(
                                            '${service.durationMinutes ?? ''} min', // Czas obsługi
                                            style: const TextStyle(
                                              color: Colors
                                                  .grey, // Kolor czasu obsługi
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                showDialog(
                                                  barrierColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const LoadingPopup();
                                                  },
                                                );
                                                // Lista ID wybranych usług
                                                var updatedService = service
                                                    .updateCategory(null);
                                                print(updatedService.toJson());

                                                int index = services.indexWhere(
                                                    (service) =>
                                                        service.id ==
                                                        updatedService.id);

                                                context
                                                    .read<
                                                        GetSalonBuilderProvider>()
                                                    .updateService(
                                                        updatedService,
                                                        services[index]);

                                                // Wywołaj zapytanie updateService dla zmienionych usług
                                                Services? serviceToUpdate = context
                                                    .read<
                                                        GetSalonBuilderProvider>()
                                                    .getServiceById(
                                                        updatedService.id!);
                                                // Jeśli usługa została znaleziona, wywołaj zapytanie updateService
                                                if (serviceToUpdate != null) {
                                                  var res =
                                                      await _salonModelProvider
                                                          .updateService(
                                                              serviceToUpdate);
                                                  print(
                                                      '${serviceToUpdate.id} = $res');
                                                }

                                                // Zamknij bottom sheet
                                                final getSalonProvider =
                                                    Provider.of<
                                                            GetSalonProvider>(
                                                        context,
                                                        listen: false);

                                                await getSalonProvider
                                                    .fetchSalon(false);

                                                context
                                                    .read<
                                                        GetSalonBuilderProvider>()
                                                    .setCategories(
                                                        getSalonProvider.salon
                                                                ?.categories ??
                                                            []);
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: const Icon(Icons.cancel)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
