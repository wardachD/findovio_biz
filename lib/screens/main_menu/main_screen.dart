import "package:findovio_business/provider/salon_provider/create_salon_provider.dart";
import "package:findovio_business/screens/intro/error_screen.dart";
import "package:findovio_business/screens/main_menu/main_screen_placeholder/main_screen_placeholder_screen.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../provider/salon_provider/get_salon_provider.dart";
import "dashboard_screen.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.useRouter = false});

  final bool useRouter;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final CreateSalonProvider _createSalonProvider;
  late final GetSalonProvider _getSalonProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    isLoading = true;
    _createSalonProvider =
        Provider.of<CreateSalonProvider>(context, listen: false);
    _getSalonProvider = Provider.of<GetSalonProvider>(context, listen: false);

    _getSalon();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   if (_getSalonProvider.salon != null) {
    //     final snackBar2 = SnackBar(
    //       elevation: 0,
    //       duration: Duration(days: 5), // Adjust the duration as needed
    //       backgroundColor: Colors.transparent,
    //       content: Stack(
    //         children: [
    //           Row(
    //             children: [
    //               Expanded(
    //                 child: ClipRect(
    //                   child: BackdropFilter(
    //                     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //                     child: Container(
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(12),
    //                         border: Border.all(
    //                             color: const Color.fromARGB(17, 0, 0, 0)),
    //                         color: const Color.fromARGB(255, 241, 241, 241)
    //                             .withOpacity(0.2),
    //                       ),
    //                       padding: EdgeInsets.fromLTRB(12, 20, 12, 20),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text(
    //                             'Wersja demo, Pozostało ${_getSalonProvider.license.remainingDays} dni.\nWykup dostęp tutaj.',
    //                             style: TextStyle(color: Colors.black87),
    //                           ),
    //                           SizedBox(
    //                               height:
    //                                   40), // Placeholder for space before buttons
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Positioned(
    //             bottom: 0,
    //             left: 0,
    //             right: 0,
    //             child: Padding(
    //               padding: EdgeInsets.all(12.0),
    //               child: Row(
    //                 // Align buttons to the left
    //                 children: [
    //                   CupertinoButton(
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 24, vertical: 0),
    //                     onPressed: () {
    //                       snackbarKey.currentState?.hideCurrentSnackBar();
    //                     },
    //                     color: Colors.white,
    //                     child: Text(
    //                       'Przypomnij',
    //                       style: TextStyle(
    //                           color: Colors.black87,
    //                           fontSize: 14), // Adjust font size as needed
    //                     ),
    //                   ),
    //                   SizedBox(width: 16), // Add spacing between buttons
    //                   CupertinoButton(
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    //                     onPressed: () async {
    //                       final url = Uri(
    //                           scheme: 'https',
    //                           host: 'findovio.nl',
    //                           path: "#pricing");

    //                       launchUrl(url).onError(
    //                         (error, stackTrace) {
    //                           print("Url is not valid!");
    //                           return false;
    //                         },
    //                       );
    //                     },
    //                     color: Colors.black,
    //                     child: Text(
    //                       'Kup -60%!',
    //                       style: TextStyle(
    //                           fontSize: 14), // Adjust font size as needed
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           Positioned(
    //             bottom: 0,
    //             right: 0,
    //             child: Image.asset(
    //               'assets/images/make_payment.png',
    //               width: 50, // Adjust the width as needed
    //               height: 50, // Adjust the height as needed
    //             ),
    //           ),
    //         ],
    //       ),
    //     );
    //     snackbarKey.currentState?.showSnackBar(snackBar2);
    //   }
    // });
  }

  Future<void> _getSalon() async {
    try {
      setState(() {
        isLoading = true;
        print(isLoading);
      });
      await _getSalonProvider.fetchSalon(true);
      setState(() {
        isLoading = false;
        print(isLoading);
      });
    } catch (e) {
      print('[FAIL] Main_screen: fetching salon data $e');
      // Obsługa błędu
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Consumer<GetSalonProvider>(
              builder: (context, salonModelProvider, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: isLoading
                      ? const MainScreenPlaceholderScreen(
                          key: ValueKey('loading'),
                        )
                      : salonModelProvider.salon == null
                          ? const ErrorScreen(
                              pageName: 'salon_not_created',
                              key: ValueKey('salon_not_created'))
                          : salonModelProvider.salon?.errorCode == 1
                              ? RefreshIndicator(
                                  onRefresh: () {
                                    if (_createSalonProvider
                                            .salons.name?.isEmpty ??
                                        true) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      return _getSalon();
                                    }
                                    return Future.value();
                                  },
                                  child: const ErrorScreen(
                                    pageName: 'salon_not_finished',
                                    key: ValueKey('salon_not_finished'),
                                  ))
                              : const DashboardScreen(
                                  key: ValueKey('dashboard'),
                                ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
