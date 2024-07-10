import 'package:findovio_business/eula/privacy_screen.dart';
import 'package:findovio_business/provider/salon_provider/get_salon_provider.dart';
import 'package:findovio_business/screens/intro/intro_3pages_screen.dart';
import 'package:findovio_business/screens/main_menu/pulpit_screen/screens/add_details_screen.dart';
import 'package:findovio_business/screens/settings/categories_modify_screen.dart';
import 'package:findovio_business/screens/settings/contact_information_settings_screen.dart';
import 'package:findovio_business/screens/settings/cost_settings_screen.dart';
import 'package:findovio_business/screens/settings/delete_account_screen.dart';
import 'package:findovio_business/screens/settings/name_settings_screen.dart';
import 'package:findovio_business/screens/settings/password_settings_screen.dart';
import 'package:findovio_business/screens/settings/services_settings_screen.dart';
import 'package:findovio_business/screens/wallet/widgets/faq_bottom_sheet_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<GetSalonProvider>(context, listen: false);
    final user = userProvider;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 12,
            ),
            Container(
                padding: const EdgeInsets.only(left: 12),
                width: MediaQuery.sizeOf(context).width,
                child: const Text(
                  'Ustawienia',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  const UserCard(),
                  const SizedBox(height: 32.0),
                  SettingsSection(
                    title: 'Ustawienia salonu',
                    items: [
                      SettingsItem(
                          icon: MdiIcons.cash,
                          title: 'Modyfikuj cennik',
                          onTap: () async {
                            await user.getServices(user.salon!.id!);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const CostSettingsScreen(),
                              ),
                            );
                          }),
                      SettingsItem(
                          icon: MdiIcons.viewGallery,
                          title: 'Dodaj lub usuń zdjęcia',
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddDetailsScreen(
                                  isNavigatedFromSettings: true,
                                ),
                              ),
                            );
                          }),
                      SettingsItem(
                          icon: MdiIcons.phone,
                          title: 'Zmień szczegóły kontaktowe',
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ContactInformationSettingsScreen(),
                              ),
                            );
                          }),
                      SettingsItem(
                          icon: Icons.settings,
                          title: 'Dodaj/Usuń usługi',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ServicesSettingsScreen(),
                                ),
                              )),
                      SettingsItem(
                          icon: Icons.settings,
                          title: 'Dodaj/Usuń kategorie',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CategoriesModifyScreen(),
                                ),
                              )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SettingsSection(
                    title: 'Twoje konto',
                    items: [
                      SettingsItem(
                          icon: Icons.edit_document,
                          title: 'Zmień nazwę konta',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NameSettingsScreen(),
                                ),
                              )),
                      SettingsItem(
                          icon: Icons.accessibility,
                          title: 'Zmień hasło',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordSettingsScreen(),
                                ),
                              )),
                      SettingsItem(
                        icon: Icons.logout,
                        title: 'Wyloguj się',
                        onTap: () async {
                          try {
                            await FirebaseAuth.instance.signOut();

                            // Navigate to login screen or any other action
                            Get.offAll(const Intro3PagesScreen());
                            Provider.of<GetSalonProvider>(context,
                                    listen: false)
                                .clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Problem z wylogowaniem się.'),
                              ),
                            );
                          }
                        },
                      ),
                      SettingsItem(
                          icon: Icons.cancel_rounded,
                          title: 'Usuń konto',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const DeleteAccountScreen(),
                                ),
                              )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SettingsSection(
                    title: 'Inne',
                    items: [
                      SettingsItem(
                          icon: Icons.help,
                          title: 'Pomoc i wsparcie',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FaqBottomSheet(),
                                ),
                              )),
                      SettingsItem(
                          icon: MdiIcons.bookOpenOutline,
                          title: 'Regulamin',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyPage(
                                      policyType: 'regulamin'),
                                ),
                              )),
                      SettingsItem(
                          icon: MdiIcons.bookOpenOutline,
                          title: 'Polityka prywatności',
                          onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicyPage(
                                      policyType: 'polityka_prywatności'),
                                ),
                              )),
                      // SettingsItem(
                      //     icon: Icons.info,
                      //     title: 'O Findovio',
                      //     onTap: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => const FaqBottomSheet(),
                      //           ),
                      //         )),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(
                    height: 64,
                    color: Color.fromARGB(255, 233, 233, 233),
                  ),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            style: TextStyle(color: Colors.black54),
                            text:
                                'Wersja aplikacji 0.0.9+1 \n2024 - Findovio Business, Icons by ',
                          ),
                          TextSpan(
                            style: const TextStyle(
                                color: Colors.black54,
                                decoration: TextDecoration.underline),
                            text: 'Icons8',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final url =
                                    Uri(scheme: 'https', host: 'icons8.com');

                                launchUrl(url).onError(
                                  (error, stackTrace) {
                                    print("Url is not valid!");
                                    return false;
                                  },
                                );
                              },
                          ),
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
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Consumer<GetSalonProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.salon;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(color: Color.fromARGB(92, 236, 236, 236), blurRadius: 6)
            ],
            border: Border.all(
              color:
                  const Color.fromARGB(255, 223, 223, 223), // Lekko szara ramka
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            tileColor: Colors.white,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  user!.avatar!), // Użyj zdjęcia profilu użytkownika
            ),
            title: Text(
              '${auth.currentUser!.displayName}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(auth.currentUser!.email!),
            trailing: const Icon(Icons.verified_user),
          ),
        );
      },
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<SettingsItem> items;

  const SettingsSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        Column(
          children: List.generate(
            items.length,
            (index) {
              if (index == items.length - 1) {
                return items[index];
              }
              return Column(
                children: [
                  items[index],
                  const Divider(
                    color: Color.fromARGB(255, 223, 223, 223),
                    thickness: 0.5,
                    height: 1,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

  const SettingsItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0),
      leading: Icon(
        icon,
        color: title != "Usuń konto"
            ? const Color.fromARGB(255, 95, 95, 95)
            : const Color.fromARGB(255, 255, 120, 110),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            color: title != "Usuń konto"
                ? Colors.black87
                : const Color.fromARGB(255, 255, 120, 110)),
      ),
      trailing: Icon(Icons.arrow_forward_ios,
          color: title != "Usuń konto"
              ? const Color.fromARGB(255, 95, 95, 95)
              : const Color.fromARGB(255, 255, 120, 110)),
    );
  }
}
