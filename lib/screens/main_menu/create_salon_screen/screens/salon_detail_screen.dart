import 'dart:async';
import 'package:findovio_business/api/create_salon.dart';
import 'package:findovio_business/models/create_salon_model.dart';
import 'package:findovio_business/provider/salon_provider/create_salon_provider.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SalonDetailScreen extends StatefulWidget {
  final TextEditingController salonNameController;
  final TextEditingController salonAboutController;
  final Function(bool) callback;

  const SalonDetailScreen({
    required this.salonNameController,
    required this.salonAboutController,
    required this.callback,
  });

  @override
  State<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends State<SalonDetailScreen> {
  final FocusNode _textFieldNameFocusNode = FocusNode();
  final FocusNode _textFieldAboutFocusNode = FocusNode();
  bool backdropFilter = false;
  late StreamController<bool> _nameExistsStreamController;
  Timer? _debounce;
  bool isInitial = true;
  bool isNameFieldCorrect = false;
  bool showSuffixName = false;
  bool showSuffixAbout = false;

  final CreateSalonProvider salonProvider = CreateSalonProvider();

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  @override
  void initState() {
    super.initState();
    _nameExistsStreamController = StreamController<bool>.broadcast();
    _nameExistsStreamController.add(false);
    widget.salonNameController.addListener(_checkNameExists);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameExistsStreamController.close();
    widget.callback(false);
    super.dispose();
  }

  void _checkNameExists() async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (_textFieldNameFocusNode.hasFocus) {
      backdropFilter = true;
    } else {
      if (mounted) {
        setState(() {
          backdropFilter = false;
        });
      }
    }
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (formKeys[0].currentState != null) {
        formKeys[0].currentState!.validate();
      }
      if (formKeys[3].currentState != null &&
          widget.salonAboutController.text.length > 1) {
        formKeys[3].currentState!.validate();
      }
      final name = widget.salonNameController.text;
      final exists = await ApiService.checkNameExists(name);
      if (!_nameExistsStreamController.isClosed) {
        _nameExistsStreamController.add(exists);
      }
      widget.callback(!exists);

      salonProvider.setSalonsWithoutNotify(
        CreateSalonModel(
          name: widget.salonNameController.text.trim(),
          about: widget.salonAboutController.text.trim(),
          errorCode: 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.4),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// 'Stwórz konto'
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Stwórz profil salonu podając nazwę i opis',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: .5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Daj się poznać Twoim przyszłym klientom, dzięki słowom kluczowym łatwiej Cię znaleźć.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  StreamBuilder<bool>(
                    stream: _nameExistsStreamController.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      final salonProvider = Provider.of<CreateSalonProvider>(
                          context,
                          listen: false);
                      salonProvider.setSalonsWithoutNotify(CreateSalonModel(
                          name: widget.salonNameController.text, errorCode: 1));
                      return Column(
                        children: [
                          CustomTextField(
                            focusNode: _textFieldNameFocusNode,
                            showSuffix: showSuffixName,
                            focusedBorder: snapshot.data == false &&
                                    widget.salonNameController.text.length >= 6
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 225, 175),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            border: snapshot.data == false &&
                                    widget.salonNameController.text.length >= 6
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 225, 175),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (widget.salonNameController.text.length < 6) {
                                return "Minimum 6 znaków - Twoja nazwa jest za krótka.";
                              }
                              if (widget.salonNameController.text.length > 30) {
                                return "Maximum 30 znaków - Twoja nazwa jest za długa.";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (widget.salonNameController.text.isEmpty) {
                                setState(() {
                                  showSuffixName = false;
                                });
                              } else {
                                setState(() {
                                  showSuffixName = true;
                                });
                              }
                              _checkNameExists();
                            },
                            keyTextField: formKeys[0],
                            controller: widget.salonNameController,
                            textInputAction: TextInputAction.next,
                            hintText: 'Nazwa salonu',
                          ),
                          const SizedBox(height: 12.0),
                          CustomTextField(
                            focusNode: _textFieldAboutFocusNode,
                            showSuffix: showSuffixAbout,
                            focusedBorder: widget
                                        .salonAboutController.text.length >=
                                    10
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 225, 175),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            border: widget.salonAboutController.text.length >=
                                    10
                                ? OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Color.fromARGB(255, 175, 225, 175),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  )
                                : null,
                            textCapitalization: TextCapitalization.words,
                            validator: (value) {
                              if (widget.salonAboutController.text.length <
                                  10) {
                                return "Minimum 10 znaków - Twój opis jest za krótki.";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              if (widget.salonAboutController.text.isEmpty) {
                                setState(() {
                                  showSuffixAbout = false;
                                });
                              } else {
                                setState(() {
                                  showSuffixAbout = true;
                                });
                              }
                              _checkNameExists();
                            },
                            keyTextField: formKeys[3],
                            maxLength: 100,
                            controller: widget.salonAboutController,
                            textInputAction: TextInputAction.next,
                            hintText: 'Opis salonu',
                          ),
                        ],
                      );
                    },
                  ),

                  // TextField(
                  //   maxLines: null,
                  //   maxLength: 100,
                  //   maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  //   focusNode: _textFieldAboutFocusNode,
                  //   controller: widget.salonAboutController,
                  //   textInputAction: TextInputAction.next,
                  //   decoration: InputDecoration(
                  //     labelText: 'Opis',
                  //     floatingLabelStyle: const TextStyle(
                  //         color: Color.fromARGB(255, 31, 31, 31)),
                  //     labelStyle: const TextStyle(
                  //         fontWeight: FontWeight.w200,
                  //         fontSize: 13,
                  //         color: Color.fromARGB(255, 31, 31, 31)),
                  //     hintStyle: const TextStyle(
                  //         fontWeight: FontWeight.w200,
                  //         color: Color.fromARGB(255, 143, 143, 143)),
                  //     hintText: 'Możesz użyć do 100 znaków....',
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //         color: Color.fromARGB(255, 255, 82, 82),
                  //         width: 0.9,
                  //       ),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     focusedErrorBorder: OutlineInputBorder(
                  //       borderSide: const BorderSide(
                  //         color: Color.fromARGB(255, 255, 82, 82),
                  //         width: 0.9,
                  //       ),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     enabledBorder: widget.salonAboutController.text.length > 1
                  //         ? OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 175, 225, 175),
                  //               width: 3,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           )
                  //         : OutlineInputBorder(
                  //             borderSide: BorderSide(
                  //                 color: Colors.grey[400]!, width: 0.9),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //     focusedBorder: widget.salonAboutController.text.length > 1
                  //         ? OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 175, 225, 175),
                  //               width: 3,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           )
                  //         : OutlineInputBorder(
                  //             borderSide: const BorderSide(
                  //               color: Color.fromARGB(255, 44, 44, 44),
                  //               width: 0.9,
                  //             ),
                  //             borderRadius: BorderRadius.circular(12),
                  //           ),
                  //     disabledBorder: OutlineInputBorder(
                  //       borderSide:
                  //           BorderSide(color: Colors.grey[400]!, width: 0.3),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderSide:
                  //           BorderSide(color: Colors.grey[400]!, width: 0.3),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
