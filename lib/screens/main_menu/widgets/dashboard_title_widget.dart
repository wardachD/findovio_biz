import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DashboardTitleWidget extends StatelessWidget {
  const DashboardTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, GetSalonProvider provider, _) {
        return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        height: 45,
                        width: 45,
                        imageUrl: provider.salon?.avatar ?? '',
                        fit: BoxFit.cover, // Dostosowanie obrazu do kontenera
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (provider.salon != null)
                      Expanded(
                        child: Text(provider.salon?.name ?? '',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    const SizedBox(width: 12),
                    IconButton(
                        onPressed: () async {
                          try {
                            Provider.of<GetSalonProvider>(context,
                                    listen: false)
                                .clear();
                            await FirebaseAuth.instance.signOut();
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
              const SizedBox(
                height: 12,
              )
              // const Divider(
              //   color: Color.fromARGB(255, 228, 228, 228),
              //   height: 24,
              // ),
            ],
          ),
        );
      },
    );
  }
}
