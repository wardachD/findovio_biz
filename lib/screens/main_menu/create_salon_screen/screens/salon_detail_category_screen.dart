import 'package:flutter/material.dart';

class FlutterCategory {
  final String value;
  final String label;

  const FlutterCategory(this.value, this.label);
}

class FlutterGender {
  final String value;
  final String label;

  const FlutterGender(this.value, this.label);
}

class SalonDetailCategoryScreen extends StatefulWidget {
  final TextEditingController salonCategoryController;
  final TextEditingController salonGenderController;
  final Function(bool) callback;
  final Function() finalCallback;

  const SalonDetailCategoryScreen(
      {super.key,
      required this.salonCategoryController,
      required this.salonGenderController,
      required this.callback,
      required this.finalCallback});
  @override
  State<SalonDetailCategoryScreen> createState() =>
      _SalonDetailCategoryScreenState();
}

class _SalonDetailCategoryScreenState extends State<SalonDetailCategoryScreen> {
  List<FlutterCategory> selectedCategories = [];
  List<FlutterGender> selectedGenders = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 'Stwórz konto'
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: const Text(
                  'Jakie i dla kogo świadczysz swoje usługi?',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: const Text(
                  'Wybierz główną kategorię usług jakie świadczysz - Twój salon jest dzięki temu łatwiejszy do znalezienia. Dostępna jest tylko 1 główna kategoria.',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 241, 241, 241),
                    ),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            '  Kategoria',
                            textScaler: TextScaler.linear(1.2),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            children: [
                              for (var category in flutterCategoryChoices)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategories.clear();
                                      widget.salonCategoryController.clear();
                                      selectedCategories.add(category);
                                      widget.salonCategoryController.text =
                                          selectedCategories[0]
                                              .value
                                              .toString();
                                      if (selectedCategories.isNotEmpty &&
                                          selectedGenders.isNotEmpty) {
                                        widget.callback(true);
                                      } else {
                                        widget.callback(false);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        color: selectedCategories
                                                .contains(category)
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                0, 65, 65, 65))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(category.value,
                                            style: TextStyle(
                                                color: selectedCategories
                                                        .contains(category)
                                                    ? Colors.white
                                                    : Colors.black)),
                                        if (selectedCategories
                                            .contains(category))
                                          const SizedBox(width: 8.0),
                                        if (selectedCategories
                                            .contains(category))
                                          const Icon(Icons.cancel,
                                              color: Colors.white, size: 18.0),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromARGB(255, 241, 241, 241),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            '  Płeć',
                            textScaler: TextScaler.linear(1.2),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8.0,
                            children: [
                              for (var gender in flutterGenderChoices)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedGenders.clear();
                                      widget.salonGenderController.clear();
                                      selectedGenders.add(gender);
                                      widget.salonGenderController.text =
                                          selectedGenders[0].value.toString();
                                      if (selectedCategories.isNotEmpty &&
                                          selectedGenders.isNotEmpty) {
                                        widget.callback(true);
                                      } else {
                                        widget.callback(false);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0, vertical: 8.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 8.0),
                                    decoration: BoxDecoration(
                                        color: selectedGenders.contains(gender)
                                            ? Colors.black
                                            : Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                0, 65, 65, 65))),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(gender.value,
                                            style: TextStyle(
                                                color: selectedGenders
                                                        .contains(gender)
                                                    ? Colors.white
                                                    : Colors.black)),
                                        if (selectedGenders.contains(gender))
                                          const SizedBox(width: 8.0),
                                        if (selectedGenders.contains(gender))
                                          const Icon(Icons.cancel,
                                              color: Colors.white, size: 18.0),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),

              const SizedBox(height: 12.0),
            ],
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}

final flutterCategoryChoices = <FlutterCategory>[
  const FlutterCategory('Fryzjer', 'Hairdresser'),
  const FlutterCategory('Paznokcie', 'Nails'),
  const FlutterCategory('Masaż', 'Massage'),
  const FlutterCategory('Barber', 'Barber'),
  const FlutterCategory('Makijaż', 'Makeup'),
  const FlutterCategory('Pielęgnacja dłoni', 'Pedicure'),
  const FlutterCategory('Pielęgnacja stóp', 'Manicure'),
];

final flutterGenderChoices = <FlutterGender>[
  const FlutterGender('Mężczyzna', 'Man'),
  const FlutterGender('Kobieta', 'Woman'),
  const FlutterGender('Wszyscy', 'Both'),
];
