// ignore_for_file: unused_field

import 'dart:async';
import 'package:findovio_business/models/create_salon_model.dart';
import 'package:findovio_business/provider/api_service.dart';
import 'package:findovio_business/provider/salon_provider/create_salon_provider.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/screens/salon_detail_number_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/screens/salon_detail_category_screen.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/screens/salon_detail_description_screen.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/screens/salon_detail_screen.dart';
import 'package:findovio_business/screens/main_menu/create_salon_screen/widgets/show_creating_salon_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_input/phone_input_package.dart';
import 'package:provider/provider.dart';
import '../../intro/error_screen.dart';

class CreateSalonScreen extends StatefulWidget {
  const CreateSalonScreen({super.key});

  @override
  State<CreateSalonScreen> createState() => _CreateSalonScreenState();
}

class _CreateSalonScreenState extends State<CreateSalonScreen>
    with TickerProviderStateMixin {
  int currentScreenIndex = 0;
  int currentStep = 0;
  bool isNextButtonActive = false;
  final CreateSalonProvider _salonProvider = CreateSalonProvider();

  late AnimationController _animationController;
  late Animation<double> _animation;

  late TextEditingController _salonNameController;
  late TextEditingController _salonAboutController;
  late TextEditingController _salonCityController;
  late TextEditingController _salonStreetController;
  late TextEditingController _salonAddressNumberController;
  late TextEditingController _salonPostcodeController;
  late TextEditingController _salonCategoryController;
  late TextEditingController _salonGenderController;
  late PhoneController _salonPhoneNumberController;

  late List<Widget> screens;

  late StreamController<bool> _isNextButtonActiveStreamControllerScreen1;
  late StreamController<bool> _isNextButtonActiveStreamControllerScreen2;
  late StreamController<bool> _isNextButtonActiveStreamControllerScreen3;
  late StreamController<bool> _isNextButtonActiveStreamControllerScreen4;

  @override
  void initState() {
    super.initState();
    _salonNameController = TextEditingController();
    _salonAboutController = TextEditingController();
    _salonPhoneNumberController = PhoneController(const PhoneNumber(
      isoCode: IsoCode.NL,
      nsn: '',
    ));
    _salonCityController = TextEditingController();
    _salonStreetController = TextEditingController();
    _salonAddressNumberController = TextEditingController();
    _salonPostcodeController = TextEditingController();
    _salonCategoryController = TextEditingController();
    _salonGenderController = TextEditingController();

    _isNextButtonActiveStreamControllerScreen1 =
        StreamController<bool>.broadcast();
    _isNextButtonActiveStreamControllerScreen2 =
        StreamController<bool>.broadcast();
    _isNextButtonActiveStreamControllerScreen3 =
        StreamController<bool>.broadcast();
    _isNextButtonActiveStreamControllerScreen4 =
        StreamController<bool>.broadcast();
//
//
//
//  Stwórz widoki dla poszczególnych kroków instrukcji
//  [callback: [newValue]] do włączania przyciski
//
//
    screens = [
      SalonDetailScreen(
        salonNameController: _salonNameController,
        salonAboutController: _salonAboutController,
        callback: (newValue) {
          _isNextButtonActiveStreamControllerScreen1.add(newValue);
        },
      ),
      SalonDetailNumberScreen(
        salonPhoneController: _salonPhoneNumberController,
        callback: (newValue) {
          _isNextButtonActiveStreamControllerScreen2.add(newValue);
        },
      ),
      SalonDetailDescriptionScreen(
        salonCityController: _salonCityController,
        salonStreetController: _salonStreetController,
        salonAddressNumberController: _salonAddressNumberController,
        salonPostcodeController: _salonPostcodeController,
        callback: (newValue) {
          _isNextButtonActiveStreamControllerScreen3.add(newValue);
        },
      ),
      SalonDetailCategoryScreen(
        salonCategoryController: _salonCategoryController,
        salonGenderController: _salonGenderController,
        callback: (newValue) {
          _isNextButtonActiveStreamControllerScreen4.add(newValue);
        },
        finalCallback: () {
          print('ciach');
        },
      ),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isNextButtonActiveStreamControllerScreen1.close();
    _isNextButtonActiveStreamControllerScreen2.close();
    _isNextButtonActiveStreamControllerScreen3.close();
    super.dispose();
  }

  void setIsNextButtonActive(bool newValue) {
    setState(() {
      isNextButtonActive = newValue;
    });
  }

  void navigateToNextScreen() {
    setState(() {
      currentScreenIndex = (currentScreenIndex + 1) % screens.length;
      _animationController.forward(from: 0);
    });
  }

  bool verifyAllRequiredFields() {
    return _salonNameController.text.isNotEmpty &&
        _salonCityController.text.isNotEmpty &&
        _salonStreetController.text.isNotEmpty &&
        _salonAddressNumberController.text.isNotEmpty &&
        _salonPostcodeController.text.isNotEmpty &&
        _salonCategoryController.text.isNotEmpty &&
        _salonGenderController.text.isNotEmpty;
  }

  void saveToModel() async {
    User? user = FirebaseAuth.instance.currentUser;
    bool res;
    await showCreatingSalonDialog(context, '🎉 Budzimy informatyka 🎉', [
      'Damian wstał i dodaje',
      'Nowy, najlepszy salon!',
    ]);

    if (verifyAllRequiredFields()) {
      CreateSalonModel salon = CreateSalonModel(
          name: _salonNameController.text,
          addressCity: _salonCityController.text,
          addressStreet: _salonStreetController.text,
          addressNumber: _salonAddressNumberController.text,
          postalCode: _salonPostcodeController.text,
          phoneNumber: _salonPhoneNumberController.value.toString(),
          about: _salonAboutController.text,
          flutterCategory: _salonCategoryController.text,
          flutterGenderType: _salonGenderController.text,
          codes: [0],
          email: user?.email,
          errorCode: 1);

      res = await createSalon(salon, context);
      if (res) {
        _salonProvider.setSalons(salon);

        showCreatingSalonDialog(context, '🎉 Zaczynamy nową historię!', [
          'Wszystko gotowe',
          '',
        ]);
        Get.offAll(() => const ErrorScreen(pageName: 'salon_not_finished'));
      } else {
        showCreatingSalonDialog(context, '🥺 Coś nam nie wyszło!', [
          'Spróbuj ponownie',
          'Lub skontaktuj się z Findovio Business.',
        ]);
      }
    }
  }

  void navigateBackScreen() {
    setState(() {
      if (currentScreenIndex > 0) {
        currentScreenIndex = (currentScreenIndex - 1) % screens.length;
      }
      _animationController.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: <Widget>[
            // Title Bar
            Container(
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromARGB(255, 223, 222, 222),
                    blurRadius: 12,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Stwórz salon',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                Provider.of<GetSalonProvider>(context,
                                        listen: false)
                                    .clear();
                                Get.offAll(const Intro3PagesScreen());
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Problem z wylogowaniem się. $e'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.logout_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Center(
                    child: AnimatedSmoothIndicator(
                      count: 4,
                      effect: const WormEffect(
                        activeDotColor: Color.fromARGB(255, 255, 202, 133),
                        dotColor: Color.fromARGB(255, 231, 231, 231),
                        dotWidth: 24,
                        dotHeight: 6,
                      ),
                      activeIndex: currentScreenIndex,
                    ),
                  ),
                ],
              ),
            ),
            // Spacer to push the body to the center
            const Spacer(),
            // Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: screens[currentScreenIndex],
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            ),
            // Spacer to push buttons to the bottom
            const Spacer(),
            // Buttons
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
              child: AnimatedContainer(
                key: UniqueKey(),
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    if (currentScreenIndex != 0)
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        onPressed: (currentScreenIndex != 0)
                            ? navigateBackScreen
                            : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chevron_left, color: Colors.black87),
                            SizedBox(width: 8),
                            Text('Cofnij',
                                style: TextStyle(color: Colors.black87)),
                            SizedBox(width: 16),
                          ],
                        ),
                      ),
                    if (currentScreenIndex == 0) streamButtonsScreen1(),
                    if (currentScreenIndex == 1) streamButtonsScreen2(),
                    if (currentScreenIndex == 2) streamButtonsScreen3(),
                    if (currentScreenIndex == 3) streamButtonsScreen4(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<bool> streamButtonsScreen1() {
    return StreamBuilder<bool>(
      stream: _isNextButtonActiveStreamControllerScreen1.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isNextButtonActive = snapshot.data ?? false;
        final isActive = isNextButtonActive &&
            _salonNameController.text.length >= 6 &&
            _salonAboutController.text.length >= 10;
        return CupertinoButton.filled(
          disabledColor: const Color.fromARGB(255, 233, 233, 233),
          onPressed: (isNextButtonActive &&
                  _salonNameController.text.length >= 6 &&
                  _salonAboutController.text.length >= 10)
              ? navigateToNextScreen
              : null,
          child: Text(
            'Dalej',
            style: TextStyle(color: isActive ? Colors.white : Colors.black54),
          ),
        );

        // CustomButton(
        //   text: 'Dalej',
        //   isNext: isNextButtonActive &&
        //       _salonNameController.text.length >= 6 &&
        //       _salonAboutController.text.length > 1,
        //   onTap: isNextButtonActive &&
        //           _salonNameController.text.length >= 6 &&
        //           _salonAboutController.text.length > 1
        //       ? navigateToNextScreen
        //       : null,
        // );
      },
    );
  }

  StreamBuilder<bool> streamButtonsScreen2() {
    return StreamBuilder<bool>(
      stream: _isNextButtonActiveStreamControllerScreen2.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isNextButtonActive = snapshot.data ?? false;
        final isActive =
            isNextButtonActive && _salonPhoneNumberController.value!.isValid();
        return CupertinoButton.filled(
          disabledColor: const Color.fromARGB(255, 233, 233, 233),
          onPressed: (isNextButtonActive &&
                  _salonPhoneNumberController.value!.isValid())
              ? navigateToNextScreen
              : null,
          child: Text(
            'Dalej',
            style: TextStyle(color: isActive ? Colors.white : Colors.black54),
          ),
        );
        // return CustomButton(
        //   text: 'Dalej',
        //   isNext: isNextButtonActive &&
        //       _salonPhoneNumberController.value!.isValid(),
        //   onTap:
        //       isNextButtonActive && _salonPhoneNumberController.value!.isValid()
        //           ? navigateToNextScreen
        //           : null,
        // );
      },
    );
  }

  StreamBuilder<bool> streamButtonsScreen3() {
    return StreamBuilder<bool>(
      stream: _isNextButtonActiveStreamControllerScreen3.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isNextButtonActive = snapshot.data ?? false;
        final isActive = isNextButtonActive &&
            _salonStreetController.text.isNotEmpty &&
            _salonCityController.text.isNotEmpty &&
            _salonAddressNumberController.text.isNotEmpty &&
            _salonPostcodeController.text.isNotEmpty;
        return CupertinoButton.filled(
          disabledColor: const Color.fromARGB(255, 233, 233, 233),
          onPressed: (isNextButtonActive &&
                  _salonStreetController.text.isNotEmpty &&
                  _salonCityController.text.isNotEmpty &&
                  _salonAddressNumberController.text.isNotEmpty &&
                  _salonPostcodeController.text.isNotEmpty)
              ? navigateToNextScreen
              : null,
          child: Text(
            'Dalej',
            style: TextStyle(color: isActive ? Colors.white : Colors.black54),
          ),
        );
        // return CustomButton(
        //   text: 'Dalej',
        //   isNext: isNextButtonActive &&
        //           _salonStreetController.text.isNotEmpty &&
        //           _salonCityController.text.isNotEmpty &&
        //           _salonAddressNumberController.text.isNotEmpty &&
        //           _salonPostcodeController.text.isNotEmpty
        //       ? true
        //       : false,
        //   onTap: isNextButtonActive &
        //           _salonStreetController.text.isNotEmpty &
        //           _salonCityController.text.isNotEmpty &
        //           _salonAddressNumberController.text.isNotEmpty &
        //           _salonPostcodeController.text.isNotEmpty
        //       ? navigateToNextScreen
        //       : null,
        // );
      },
    );
  }

  StreamBuilder<bool> streamButtonsScreen4() {
    return StreamBuilder<bool>(
      stream: _isNextButtonActiveStreamControllerScreen4.stream,
      initialData: false,
      builder: (context, snapshot) {
        final isNextButtonActive = snapshot.data ?? false;
        final isActive = isNextButtonActive &&
            _salonGenderController.text.isNotEmpty &&
            _salonCategoryController.text.isNotEmpty;
        return CupertinoButton.filled(
          disabledColor: const Color.fromARGB(255, 233, 233, 233),
          onPressed: (isNextButtonActive &&
                  _salonGenderController.text.isNotEmpty &&
                  _salonCategoryController.text.isNotEmpty)
              ? saveToModel
              : null,
          child: Text(
            'Zapisz',
            style: TextStyle(color: isActive ? Colors.white : Colors.black54),
          ),
        );
        // return CustomButton(
        //   text: 'Zapisz i dodaj usługi',
        //   isNext: isNextButtonActive &&
        //           _salonGenderController.text.isNotEmpty &&
        //           _salonCategoryController.text.isNotEmpty
        //       ? true
        //       : false,
        //   onTap: isNextButtonActive ? saveToModel : null,
        // );
      },
    );
  }
}
