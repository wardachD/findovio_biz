import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_builder_provider.dart';
import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/widgets/custom_button.dart';
import 'package:findovio_business/screens/main_menu/main_menu.dart';
import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_services_screen.dart';
import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_working_time.dart';
import 'package:findovio_business/screens/main_menu/widgets/card_button_widget_with_title_description.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';
import '../../widgets/loading_popup.dart';
import 'add_categories_screen.dart';
import 'add_details_screen.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'add_services_to_categories.dart';

class DashboardCreateScreen extends StatefulWidget {
  final GetSalonModel salonModel;

  const DashboardCreateScreen({super.key, required this.salonModel});

  @override
  State<DashboardCreateScreen> createState() => _DashboardCreateScreenState();
}

class _DashboardCreateScreenState extends State<DashboardCreateScreen>
    with SingleTickerProviderStateMixin {
  GetSalonProvider getSalonProvider = GetSalonProvider();
  GetSalonBuilderProvider getSalonBuilderProvider = GetSalonBuilderProvider();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getSalonProvider = Provider.of<GetSalonProvider>(context, listen: false);
    getSalonBuilderProvider =
        Provider.of<GetSalonBuilderProvider>(context, listen: false);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Komenda, która ma się wykonać po załadowaniu widgetu
      _executeAfterBuild();
    });
  }

  void _executeAfterBuild() async {
    await getSalonProvider.fetchSalon(false);
    getSalonBuilderProvider
        .setCategories(getSalonProvider.salon?.categories ?? []);
    getSalonBuilderProvider.setServices(getSalonProvider.services ?? []);
    await getSalonProvider.fetchSalonSchedules(getSalonProvider.salon!.id!);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Widget tytułowy
        const SizedBox(
          height: 18,
        ),
        SvgPicture.asset(
          alignment: Alignment.centerLeft,
          'assets/images/findovio_business_logo_full.svg', // Ścieżka do Twojego pliku SVG w folderze assets
          height: 38.0,
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                getSalonProvider.salon?.name ?? 'Stwórz salon',
                maxLines: 4,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                  label: const Text('Wyloguj'),
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      getSalonProvider.clear();
                      // Navigate to login screen or any other action
                      Get.offAll(const Intro3PagesScreen());
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Problem z wylogowaniem się. $e'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.logout_outlined)),
            ],
          ),
        ),

        Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        child: const Text(
                          'Stwórz salon z nami! Wykonaj 5 prostych kroków, by dodać salon, który odzwierciedli Twój unikalny gust. Zacznij teraz!',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.help),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Jak dodać salon?"),
                            content: const SingleChildScrollView(
                              child: Column(
                                children: [
                                  InstructionWidget(
                                    title: '1. Dodaj Usługi',
                                    description:
                                        'Przyciskiem na środku stworzysz nową usługę, gdzie wymagane informacje to: nazwa usługi, opis, cena oraz jak długo zajmuje jej wykonanie. Po wciśnięciu przycisku Dodaj Usługę, usługa będzie dodana.',
                                  ),
                                  SizedBox(height: 12.0),
                                  InstructionWidget(
                                    title: '2. Dodaj kategorie usług',
                                    description:
                                        'Pogrupuj wszystkie swoje usługi, aby klienci mogli łatwiej znaleźć to, czego potrzebują. Tutaj potrzebujesz tylko podać nazwę.',
                                  ),
                                  SizedBox(height: 12.0),
                                  InstructionWidget(
                                    title: '3. Przypisz usługi do kategorii',
                                    description:
                                        'Pogrupuj usługi, użytkownicy częściej rezerwują usługi w salonach z łatwym wyborem. Przyciskiem Dodaj dodasz usługę do danej kategorii, a ikoną z krzyżykiem usuniesz ją z listy kategorii.',
                                  ),
                                  SizedBox(height: 12.0),
                                  InstructionWidget(
                                    title: '4. Ustaw czas swojej pracy',
                                    description:
                                        'Przekaż użytkownikom w jakich godzinach pracujesz, zaznacz odpowiedni dzień, wybierz przedział godzin klikając na odpowiednie pola i przejdź dalej klikając Dalej.',
                                  ),
                                  SizedBox(height: 12.0),
                                  InstructionWidget(
                                    title: '5. Dodaj galerię',
                                    description:
                                        'Pokaż się użytkownikom, wymagany dla nowego profilu jest tylko Avatar wyświetlay na Twojej stronie głównej, oprócz tego możesz dodać do 8 zdjęć do galerii.',
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              CustomButton(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                text: 'Zamknij',
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            // Przycisk finałowy
            Consumer<GetSalonProvider>(builder: (context, getSalon, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.7,
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.transparent)),
                          backgroundColor: getSalon.isComplete
                              ? MaterialStateProperty.all<Color>(Colors.black)
                              : MaterialStateProperty.all<Color>(Colors.grey),
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
                          var res = await getSalonProvider.finalSaveSalon();
                          await FirebaseChatCore.instance.createUserInFirestore(
                            types.User(
                                firstName:
                                    getSalonProvider.salon?.name ?? 'Salon',
                                id: FirebaseAuth.instance.currentUser?.uid ??
                                    '',
                                imageUrl: getSalonProvider.salon?.avatar,
                                email: getSalonProvider.salon?.email,
                                role: types.Role.agent),
                          );
                          print(res);
                          Get.offAll(() => MinimalExample());
                        },
                        child: Text(
                          !getSalon.isComplete
                              ? 'Brakuje informacji'
                              : 'Zakończ i dodaj Salon',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.transparent)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: () {
                        _controller.forward(from: 0.0);
                        getSalon.getVerificationStatus(context);
                      },
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(
              height: 12,
            ),

            // Dodaj Usługi
            Consumer<GetSalonProvider>(
                builder: (context, getSalonModelProvider, _) {
              return CardButtonWidgetWithTitleDescription(
                isDisabled: false,
                deleteBorder: true,
                title: 'Dodaj Usługi',
                description:
                    'Opisz je, wyceń, ustaw czas jaki potrzebujesz na ich wykonanie. Zawsze możesz to edytować',
                buttonText: 'Dodaj usługi',
                fontColor: Colors.white,
                buttonColor: Colors.black,
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
                onPressed: () async {
                  await servicesOnPressed(context, getSalonBuilderProvider);
                },
              );
            }),
            const SizedBox(height: 12),

            // Dodaj Kategorie Usług
            Consumer<GetSalonBuilderProvider>(builder: (context, getSalon, _) {
              return Column(
                children: [
                  CardButtonWidgetWithTitleDescription(
                    //isReadyCardIndicator: getSalonProvider.isSalonCategoriesEmpty(),
                    isDisabled: getSalonBuilderProvider.services.isEmpty,
                    deleteBorder: true,
                    title: 'Dodaj kategorie usług',
                    description:
                        'Pogrupuj wszystkie swoje usługi żeby klienci łatwiej mogli odnaleść czego potrzebują',
                    buttonText: 'Dodaj kategorie',
                    fontColor: Colors.white,
                    buttonColor: Colors.black,
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
                    onPressed: () async {
                      await addServicesOnPressed(context);
                    },
                  ),
                  const SizedBox(height: 12),

                  // Przypisz usługi do kategorii
                  CardButtonWidgetWithTitleDescription(
                      //isReadyCardIndicator: getSalonBuilderProvider.getServicesWithNullCategoryCount() == 0,
                      isDisabled: getSalonBuilderProvider.categories.isEmpty,
                      deleteBorder: true,
                      title: 'Przypisz usługi do kategorii',
                      description:
                          'Pogrupuj usługi, użytkownicy częściej rezerwują usługi w salonach z łatwym wyborem',
                      buttonText: 'Przypisz usługi',
                      fontColor: Colors.white,
                      buttonColor: Colors.black,
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
                      onPressed: () async {
                        if (getSalonBuilderProvider.services.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Brak dodanych usług'),
                                content: const SizedBox(
                                  height:
                                      80.0, // Dostosuj wysokość do swoich potrzeb
                                  child: Text(
                                    'Usunąłeś usługę i nie masz czego przypisać. Najpierw wróć do dodawania usług.',
                                  ),
                                ),
                                actions: [
                                  CustomButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    text: 'Zamknij',
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          if (getSalonBuilderProvider.categories.isNotEmpty) {
                            await servicesAssignToCategoriesOnPressed(
                                context, getSalonBuilderProvider);
                          }
                        }
                      }),

                  const SizedBox(height: 12),

                  // Ustaw czas swojej pracy
                  CardButtonWidgetWithTitleDescription(
                    isDisabled: getSalonBuilderProvider.services.isEmpty &&
                        getSalonBuilderProvider
                                .getServicesWithNullCategoryCount() ==
                            0,
                    //isReadyCardIndicator: getSalonProvider.isSalonSchedulesEmpty(),
                    deleteBorder: true,
                    title: 'Ustaw czas swojej pracy',
                    description:
                        'Przekaż użytkownikom w jakich godzinach pracujesz, ustaw też slot',
                    buttonText: 'Dodaj godziny otwarcia',
                    fontColor: Colors.white,
                    buttonColor: Colors.black,
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
                    onPressed: () async {
                      await setTimeSalonOnPressed(getSalonBuilderProvider);
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),
            // Dodaj Informacje
            Consumer<GetSalonProvider>(builder: (context, salon, _) {
              return CardButtonWidgetWithTitleDescription(
                isDisabled: salon.isSchedulesEmpty,
                deleteBorder: true,
                title: 'Dodaj zdjęcia',
                description:
                    'Avatar i galeria, to bardzo ważne elementy Twojego salonu',
                buttonText: 'Dodaj informacje ogólne',
                fontColor: Colors.white,
                buttonColor: Colors.black,
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
                onPressed: () async {
                  await addDetailsOnPressed(context);
                },
              );
            }),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Future<void> addServicesOnPressed(BuildContext context) async {
    if (getSalonBuilderProvider.services.isNotEmpty) {
      showDialog(
        barrierColor: Colors.transparent,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const LoadingPopup();
        },
      );
      final getSalonProvider =
          Provider.of<GetSalonProvider>(context, listen: false);

      await getSalonProvider.fetchSalon(false);
      getSalonBuilderProvider
          .setCategories(getSalonProvider.salon?.categories ?? []);
      getSalonProvider.isSalonServicesEmpty();
      Get.back();
      Get.to(() => AddCategoriesScreen(
            key: widget.key,
          ));
    }
  }

  Future<void> setTimeSalonOnPressed(
      GetSalonBuilderProvider getSalonBuilderProvider) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingPopup();
      },
    );
    if (getSalonBuilderProvider.getServicesWithNullCategoryCount() == 0) {
      var res = await getSalonProvider
          .fetchSalonSchedules(getSalonProvider.salon!.id!);
      print(res);
      Get.back();
      Get.to(() => AddWorkingTimeScreen(
            key: widget.key,
          ));
    }
  }

  Future<void> addDetailsOnPressed(BuildContext context) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingPopup();
      },
    );
    int? salonId = getSalonProvider.salon?.id!;
    getSalonProvider.salonImagesFiles?.delete();
    getSalonProvider.salonImagesGalleryFiles.clear();
    getSalonProvider.salonImagesModel.clear();
    if (salonId != null) {
      var resAvatar = await getSalonProvider.fetchSalonImagesModel(
          salonId, PhotoType.avatar);
      var resGallery = await getSalonProvider.fetchSalonImagesModel(
          salonId, PhotoType.gallery);
    }

    Get.back();
    Get.to(() => AddDetailsScreen(
          isNavigatedFromSettings: false,
        ));
  }

  Future<void> servicesOnPressed(BuildContext context,
      GetSalonBuilderProvider getSalonBuilderProvider) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingPopup();
      },
    );
    final getSalonProvider =
        Provider.of<GetSalonProvider>(context, listen: false);
    await getSalonProvider.getServices(getSalonProvider.salon?.id ?? 0);
    getSalonBuilderProvider.setServices(getSalonProvider.services ?? []);
    Get.back();
    Get.to(() => AddServicesScreen(
          key: widget.key,
        ));
  }

  Future<void> servicesAssignToCategoriesOnPressed(BuildContext context,
      GetSalonBuilderProvider getSalonBuilderProvider) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingPopup();
      },
    );
    final getSalonProvider =
        Provider.of<GetSalonProvider>(context, listen: false);

    await getSalonProvider.fetchSalon(false);
    await getSalonProvider.getServices(getSalonProvider.salon?.id ?? 0);
    getSalonBuilderProvider
        .setCategories(getSalonProvider.salon?.categories ?? []);
    getSalonProvider.isSalonServicesEmpty();
    getSalonBuilderProvider.setServices(getSalonProvider.services ?? []);
    print(getSalonProvider.salon?.toJson());
    Get.back();
    Get.to(() => AddServicesToCategoriesScreen(
          key: widget.key,
        ));
  }
}

class InstructionWidget extends StatelessWidget {
  final String title;
  final String description;

  const InstructionWidget({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          description,
        ),
      ],
    );
  }
}
