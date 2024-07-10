import 'package:findovio_business/models/get_salon_model.dart';
import 'package:findovio_business/screens/main_menu/widgets/alertdialog_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../provider/salon_provider/get_salon_provider.dart';

class ContactInformationSettingsScreen extends StatelessWidget {
  const ContactInformationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<GetSalonProvider>(
          builder: (context, salonProvider, child) {
            final salon = salonProvider.salon;

            if (salon == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 0),
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      child: const Text(
                        'Zmodyfikuj ceny usług',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                  height: 24,
                ),
                _buildListTile(
                    context, 'Nazwa salonu', salon.name ?? '', MdiIcons.store),
                _buildListTile(
                    context, 'Miasto', salon.addressCity ?? '', MdiIcons.city),
                _buildListTile(context, 'Kod pocztowy',
                    salon.addressPostalCode ?? '', MdiIcons.mailbox),
                _buildListTile(
                    context, 'Ulica', salon.addressStreet ?? '', MdiIcons.road),
                _buildListTile(context, 'Numer budynku',
                    salon.addressNumber ?? '', MdiIcons.numeric),
                _buildListTile(context, 'O salonie', salon.about ?? '',
                    MdiIcons.information),
                // Add more fields as necessary
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () => _showBottomSheet(context, title, value),
    );
  }

  void _showBottomSheet(BuildContext context, String title, String value) {
    final TextEditingController _controller =
        TextEditingController(text: value);

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
                        Text(
                          'Edytuj $title',
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
                    const Divider(height: 12),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: title,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      color: Colors.black87,
                      onPressed: () async {
                        // Show loading dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialogLoading(
                              icon: const Icon(Icons.download),
                              title: 'Aktualizacja danych',
                              message: 'Zmieniamy dane pola $title.',
                            );
                          },
                        );

                        final provider = Provider.of<GetSalonProvider>(context,
                            listen: false);
                        _updateSalonField(
                            provider.salon!, title, _controller.text);

                        final success = await provider.updateEditedFieldsSalon(
                          _mapFieldToApi(title, _controller.text),
                        );

                        // Close the loading dialog
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Pomyślnie zaktualizowano $title')),
                          );
                          print('[Updating field $title] success');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Błąd podczas aktualizacji $title')),
                          );
                          print('[Updating field $title] fail');
                        }
                        Navigator.of(context).pop();
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

  GetSalonModel _updateSalonField(
      GetSalonModel salon, String title, String value) {
    switch (title) {
      case 'Nazwa salonu':
        return salon.copyWith(name: value);
      case 'Miasto':
        return salon.copyWith(addressCity: value);
      case 'Kod pocztowy':
        return salon.copyWith(addressPostalCode: value);
      case 'Ulica':
        return salon.copyWith(addressStreet: value);
      case 'Numer budynku':
        return salon.copyWith(addressNumber: value);
      case 'O salonie':
        return salon.copyWith(about: value);
      default:
        return salon;
    }
  }

  Map<String, dynamic> _mapFieldToApi(String title, String value) {
    switch (title) {
      case 'Nazwa salonu':
        return {'name': value};
      case 'Miasto':
        return {'address_city': value};
      case 'Kod pocztowy':
        return {'address_postal_code': value};
      case 'Ulica':
        return {'address_street': value};
      case 'Numer budynku':
        return {'address_number': value};
      case 'O salonie':
        return {'about': value};
      default:
        return {};
    }
  }
}
