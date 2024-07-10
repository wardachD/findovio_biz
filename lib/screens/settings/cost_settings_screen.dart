import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/main_menu/widgets/alertdialog_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class CostSettingsScreen extends StatelessWidget {
  const CostSettingsScreen({super.key});

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
                    'Zmodyfikuj ceny usług',
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
                  final categories = salonProvider.salon?.categories ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...categories
                          .map(
                              (category) => CategorySection(category: category))
                          .toList(),
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

  void _showBottomSheet(BuildContext context, String service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(),
              // Add more content for the service details here
              Expanded(
                child: Center(
                  child: Text(
                    'Details for $service',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
      onTap: () => _showBottomSheet(context, service, service.price!),
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
              Text(
                '€ ${service.price}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              IconButton.outlined(
                onPressed: () =>
                    _showBottomSheet(context, service, service.price!),
                icon: const Icon(Icons.edit_note_outlined),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Services service, String price) {
    final TextEditingController _controller = TextEditingController(text: '');
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.5,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Zmień cenę dla usługi',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const Divider(
                      height: 12,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      service.title!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          'Stara cena: ${service.price!}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'Cena',
                        hintText: '123.99',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      color: Colors.black87,
                      onPressed: () async {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Prevent closing by tapping outside
                          builder: (BuildContext context) {
                            return const AlertDialogLoading(
                              icon: Icon(Icons.download),
                              title: 'Aktualizuję bazę danych',
                              message: 'Zmieniamy cenę twojej usługi.',
                            );
                          },
                        );

                        final newPrice =
                            double.tryParse(_controller.value.text);
                        if (newPrice != null) {
                          Services changeIsAvailableService =
                              service.copyWith(isAvailable: false);
                          Services updatedService =
                              service.copyWith(price: newPrice.toString());
                          final provider = Provider.of<GetSalonProvider>(
                              context,
                              listen: false);
                          final successDeleteOld = await provider
                              .updateService(changeIsAvailableService);
                          final successCreateNew =
                              await provider.createServices(updatedService);

                          // Close the loading dialog

                          if (successDeleteOld && successCreateNew) {
                            await provider.fetchSalon(false);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Cena zaktualizowana pomyślnie')),
                            );
                          } else {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Błąd przy aktualizacji ceny')),
                            );
                          }
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Niepoprawna cena')),
                          );
                        }
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text('Zapisz'),
                    ),
                    CupertinoButton(
                      color: const Color.fromARGB(255, 228, 228, 228),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cofnij',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
