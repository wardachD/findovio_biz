import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/routes/app_pages.dart';
import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PulpitUser extends StatefulWidget {
  final bool isSalonListEmpty;

  const PulpitUser({super.key, required this.isSalonListEmpty});

  @override
  State<PulpitUser> createState() => _PulpitUserState();
}

class _PulpitUserState extends State<PulpitUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenOne();
  }
}

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 223, 222, 222),
                    blurRadius: 12,
                    offset: Offset(0, 12),
                  )
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
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
                                // Navigate to login screen or any other action
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
                            icon: const Icon(Icons.logout_outlined)),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: const Text(
                            'Brak Salonu do Zarządzania',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          'Nie masz dodanego jeszcze swojego salonu. Kliknij przycisk Utwórz żeby go dodać i móc rozwijać swój biznes.',
                          textAlign: TextAlign.left,
                        ),
                        CupertinoButton(
                          onPressed: () {
                            Get.toNamed(Routes.CREATE_SALON_DETAIL);
                          },
                          color: Colors.black87,
                          child: const Text(
                            'Utwórz salon',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14), // Adjust font size as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
