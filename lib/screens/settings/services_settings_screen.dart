import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/settings/services_add_screen.dart';
import 'package:findovio_business/screens/settings/services_modify_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class ServicesSettingsScreen extends StatelessWidget {
  const ServicesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0),
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_ios),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: const Text(
                    'Dodaj/usuń lub modyfikuj usługi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color.fromARGB(255, 228, 228, 228),
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Consumer<GetSalonProvider>(
                builder: (context, salonProvider, child) {
                  final allCategoriesWithBothStatus =
                      salonProvider.salon?.categories ?? [];
                  final availableCategories = allCategoriesWithBothStatus
                      .where((category) => category.isAvailable == true)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ServicesAddScreen(key: key)),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Dodaj nową usługę',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ...availableCategories.map(
                          (category) => CategorySection(category: category)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  final Categories category;

  const CategorySection({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name!,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          children: List.generate(
            category.services!.length,
            (index) {
              final service = category.services![index];
              if (index == category.services!.length - 1 &&
                  service.isAvailable! == true) {
                return ServiceItem(service: service);
              }
              if (service.isAvailable! == true) {
                return Column(
                  children: [
                    ServiceItem(service: service),
                    const Divider(
                      color: Color.fromARGB(255, 223, 223, 223),
                      thickness: 0.5,
                      height: 1,
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  final Services service;

  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ServicesModifyScreen(
            service: service,
          ),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      title: Row(
        children: [
          Expanded(
            child: Text(
              service.title!,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
          Row(
            children: [
              const Text(
                'Edytuj',
                style: TextStyle(),
              ),
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicesModifyScreen(
                      service: service,
                    ),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
