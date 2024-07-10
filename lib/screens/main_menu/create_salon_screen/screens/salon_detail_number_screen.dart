import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:url_launcher/url_launcher.dart';

class SalonDetailNumberScreen extends StatefulWidget {
  final PhoneController salonPhoneController;
  final Function(bool) callback;

  const SalonDetailNumberScreen({
    super.key,
    required this.salonPhoneController,
    required this.callback,
  });
  @override
  State<SalonDetailNumberScreen> createState() =>
      _SalonDetailNumberScreenState();
}

class _SalonDetailNumberScreenState extends State<SalonDetailNumberScreen> {
  bool _isPolicyAccepted = false;

  void _onPolicyAcceptedChanged(bool? newValue) {
    setState(() {
      _isPolicyAccepted = newValue ?? false;
    });
    widget.callback(_isPolicyAccepted);
  }

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
  ];

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
                  'Podaj numer telefonu',
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
                  'Twój numer będzie widoczny na Twoim profilu. Klienci będą mogli mieć zawsze z Tobą kontakt. Jest to wymagane.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 80,
                child: PhoneInput(
                    controller: widget.salonPhoneController,
                    onChanged: (value) {
                      final bool isPhoneValid =
                          widget.salonPhoneController.value?.isValid() ?? false;
                      if (isPhoneValid && _isPolicyAccepted) {
                        widget.callback(true);
                      }
                    },
                    validator: PhoneValidator.compose(
                        [PhoneValidator.required(), PhoneValidator.valid()]),
                    flagShape: BoxShape.circle,
                    decoration: const InputDecoration(
                      labelText: 'Numer telefonu',
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                    ),
                    countrySelectorNavigator: CountrySelectorNavigator.dropdown(
                        borderRadius: BorderRadius.circular(12),
                        addFavoriteSeparator: true,
                        backgroundColor:
                            const Color.fromARGB(255, 247, 247, 247),
                        listHeight: 230,
                        flagSize: 22,
                        layerLink: LayerLink(),
                        countries: [
                          IsoCode.NL, // Netherlands
                          IsoCode.BE, // Belgium
                          IsoCode.PL
                        ])),
              ),

              Row(
                children: [
                  Checkbox(
                    value: _isPolicyAccepted,
                    onChanged: _onPolicyAcceptedChanged,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.7,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Potwierdzam zapoznanie się z ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'polityką prywatności',
                            style: const TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrl(Uri.parse(
                                        'https://findovio.nl/privacy'))
                                    .onError(
                                  (error, stackTrace) {
                                    print("Url is not valid!");
                                    return false;
                                  },
                                );
                              },
                          ),
                          const TextSpan(
                            text: '.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
