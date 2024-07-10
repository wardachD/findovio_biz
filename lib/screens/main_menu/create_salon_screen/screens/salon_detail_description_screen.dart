import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:findovio_business/provider/geo_suggestions/geo_suggestions.dart';
import 'package:findovio_business/screens/intro/register/screens/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SalonDetailDescriptionScreen extends StatefulWidget {
  final TextEditingController salonCityController;
  final TextEditingController salonStreetController;
  final TextEditingController salonAddressNumberController;
  final TextEditingController salonPostcodeController;
  final Function(bool) callback;

  const SalonDetailDescriptionScreen({
    super.key,
    required this.salonCityController,
    required this.salonStreetController,
    required this.salonAddressNumberController,
    required this.salonPostcodeController,
    required this.callback,
  });

  @override
  State<SalonDetailDescriptionScreen> createState() =>
      _SalonDetailDescriptionScreenState();
}

class _SalonDetailDescriptionScreenState
    extends State<SalonDetailDescriptionScreen> {
  final List<bool> fieldsState = [false, false, false, false];

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  GlobalKey<AutoCompleteTextFieldState<String>> key =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  bool showSuggestions = false;
  final valueListenable = ValueNotifier<String?>(null);
  final TextEditingController textEditingController = TextEditingController();
  String? selectedCity;

  final GeoSuggestions _geoSuggestions = GeoSuggestions();

  @override
  void initState() {
    super.initState();
    widget.callback(false);
  }

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
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: const Text(
                  'Podaj dokładny adres',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 24,
                    letterSpacing: .5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Twój adres będzie widoczny na Twoim profilu oraz używany jest do wyszukiwania. Jest to wymagane.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TypeAheadField<String>(
                controller: widget.salonPostcodeController,
                onSelected: (value) async {
                  final coordinates =
                      await GeoSuggestions.getCityCoordinates(value);
                  setState(() {
                    widget.salonPostcodeController.text = value;
                  });
                },
                builder: (context, controller, focusNode) {
                  return TextFormField(
                    key: formKeys[3],
                    focusNode: focusNode,
                    controller: controller,
                    onTapOutside: (event) => {FocusScope.of(context).unfocus()},
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _PostalCodeInputFormatter(),
                    ],
                    onChanged: (value) async {
                      if (controller.text.length == 6) {
                        widget.salonCityController.text =
                            await GeoSuggestions.getCityFromPostCode(value) ??
                                '';
                        if (widget.salonCityController.text.isNotEmpty) {
                          setState(() {
                            fieldsState[1] = true;
                            if (!fieldsState.contains(false)) {
                              widget.callback(true);
                            }
                          });
                        } else {
                          setState(() {
                            widget.callback(false);
                            fieldsState[1] = false;
                          });
                        }
                      }

                      if (value.isNotEmpty) {
                        setState(() {
                          fieldsState[0] = true;
                          if (!fieldsState.contains(false)) {
                            widget.callback(true);
                          }
                        });
                      } else {
                        setState(() {
                          widget.callback(false);
                          fieldsState[0] = false;
                        });
                      }
                    },
                    textInputAction: TextInputAction.next,
                    maxLengthEnforcement: MaxLengthEnforcement.none,
                    decoration: InputDecoration(
                      counterStyle: const TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: "",
                      label: const Text('Kod pocztowy'),
                      hintText: 'Kod pocztowy',
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 82, 82),
                          width: 0.9,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 255, 82, 82),
                          width: 0.9,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(255, 44, 44, 44),
                          width: 0.9,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[400]!, width: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                suggestionsCallback: (pattern) async {
                  return;
                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    tileColor: Colors.white,
                    title: Text(suggestion),
                  );
                },
                emptyBuilder: (context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: const Text(
                      'Brak wyników',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                onTapOutside: (event) => {FocusScope.of(context).unfocus()},
                keyboardType: TextInputType.streetAddress,
                textCapitalization: TextCapitalization.words,
                key: formKeys[0],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      fieldsState[1] = true;
                      if (!fieldsState.contains(false)) {
                        widget.callback(true);
                      }
                    });
                  } else {
                    setState(() {
                      widget.callback(false);
                      fieldsState[1] = false;
                    });
                  }
                },
                controller: widget.salonCityController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Miasto',
                  hintText: 'Zacznij wpisywać',
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 82, 82),
                      width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 255, 82, 82),
                      width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 44, 44, 44),
                      width: 0.9,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[400]!, width: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // TypeAheadField<String>(
              //   controller: widget.salonCityController,
              //   onSelected: (value) async {
              //     final coordinates =
              //         await GeoSuggestions.getCityCoordinates(value);
              //     setState(() {
              //       widget.salonCityController.text = value;
              //       widget.salonPostcodeController.text = '';
              //       widget.salonStreetController.text = '';
              //     });
              //   },
              //   builder: (context, controller, focusNode) {
              //     return TextField(
              //       focusNode: focusNode,
              //       onTapOutside: (event) => {FocusScope.of(context).unfocus()},
              //       keyboardType: TextInputType.streetAddress,
              //       textCapitalization: TextCapitalization.words,
              //       key: formKeys[0],
              //       controller: controller,
              //       textInputAction: TextInputAction.next,
              //       decoration: InputDecoration(
              //         labelText: 'Miasto',
              //         hintText: 'Zacznij wpisywać',
              //         errorBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 255, 82, 82),
              //             width: 0.9,
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         focusedErrorBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 255, 82, 82),
              //             width: 0.9,
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Colors.grey[400]!, width: 0.9),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: const BorderSide(
              //             color: Color.fromARGB(255, 44, 44, 44),
              //             width: 0.9,
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         disabledBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Colors.grey[400]!, width: 0.3),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         border: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(color: Colors.grey[400]!, width: 0.3),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //       ),
              //     );
              //   },
              //   suggestionsCallback: (pattern) async {
              //     return await GeoSuggestions.getCitySuggestions(pattern);
              //   },
              //   itemBuilder: (context, suggestion) {
              //     return ListTile(
              //       tileColor: Colors.white,
              //       title: Text(suggestion),
              //     );
              //   },
              //   emptyBuilder: (context) {
              //     return Container(
              //       padding: EdgeInsets.symmetric(vertical: 10),
              //       alignment: Alignment.center,
              //       child: Text(
              //         'Brak wyników',
              //         style: TextStyle(fontSize: 18, color: Colors.black),
              //       ),
              //     );
              //   },
              // ),

              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.55,
                    child: TextField(
                      onTapOutside: (event) =>
                          {FocusScope.of(context).unfocus()},
                      keyboardType: TextInputType.streetAddress,
                      textCapitalization: TextCapitalization.words,
                      key: formKeys[1],
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            fieldsState[2] = true;
                            if (!fieldsState.contains(false)) {
                              widget.callback(true);
                            }
                          });
                        } else {
                          setState(() {
                            fieldsState[2] = false;
                            widget.callback(false);
                          });
                        }
                      },
                      controller: widget.salonStreetController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Ulica',
                        hintText: 'Ulica',
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 44, 44, 44),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   width: MediaQuery.sizeOf(context).width * 0.55,
                  //   child: TypeAheadField<String>(
                  //     controller: widget.salonStreetController,
                  //     onSelected: (value) => {
                  //       widget.salonStreetController.text = value.toString(),
                  //     },
                  //     builder: (context, controller, focusNode) {
                  //       return TextField(
                  //         focusNode: focusNode,
                  //         onTapOutside: (event) =>
                  //             {FocusScope.of(context).unfocus()},
                  //         keyboardType: TextInputType.streetAddress,
                  //         textCapitalization: TextCapitalization.words,
                  //         key: formKeys[1],
                  //         controller: controller,
                  //         textInputAction: TextInputAction.next,
                  //         decoration: InputDecoration(
                  //           labelText: 'Ulica',
                  //           hintText: 'Ulica',
                  //           errorBorder: OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 255, 82, 82),
                  //               width: 0.9,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           focusedErrorBorder: OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 255, 82, 82),
                  //               width: 0.9,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Colors.grey[400]!, width: 0.9),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 44, 44, 44),
                  //               width: 0.9,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           disabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Colors.grey[400]!, width: 0.3),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //           border: OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Colors.grey[400]!, width: 0.3),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     suggestionsCallback: (pattern) async {
                  //       return await GeoSuggestions.getStreetSuggestions(
                  //           pattern, widget.salonCityController.text);
                  //     },
                  //     itemBuilder: (context, suggestion) {
                  //       return ListTile(
                  //         tileColor: Colors.white,
                  //         title: Text(suggestion),
                  //       );
                  //     },
                  //     emptyBuilder: (context) {
                  //       return Container(
                  //         padding: EdgeInsets.symmetric(vertical: 10),
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           'Brak wyników',
                  //           style: TextStyle(fontSize: 18, color: Colors.black),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: TextField(
                      key: formKeys[2],
                      onChanged: (value) => {
                        if (value.isNotEmpty)
                          {
                            setState(() {
                              fieldsState[3] = true;
                              if (!fieldsState.contains(false)) {
                                widget.callback(true);
                              }
                            })
                          }
                        else
                          {
                            setState(() {
                              fieldsState[3] = false;
                              widget.callback(false);
                            })
                          },
                        if (!fieldsState.contains(false))
                          {widget.callback(true)}
                      },
                      onTapOutside: (event) =>
                          {FocusScope.of(context).unfocus()},
                      controller: widget.salonAddressNumberController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Numer',
                        hintText: '1',
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 255, 82, 82),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 44, 44, 44),
                            width: 0.9,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[400]!, width: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}

class _PostalCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Check if the text is empty, in which case return an empty TextEditingValue
    if (text.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Remove all non-digit characters from the text
    final cleanedText = text.replaceAll(RegExp(r'[^\d]'), '');

    // If cleaned text is empty, return an empty TextEditingValue
    if (cleanedText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Prepare the formatted text
    var formattedText = '';
    for (var i = 0; i < cleanedText.length; i++) {
      if (i == 2) {
        formattedText += '-';
      }
      formattedText += cleanedText[i];
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
