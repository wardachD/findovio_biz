import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/get_salon_model.dart';
import '../../provider/salon_provider/get_salon_provider.dart';
import '../main_menu/widgets/alertdialog_loading.dart';

class CategoriesModifyScreen extends StatefulWidget {
  const CategoriesModifyScreen({super.key});

  @override
  State<CategoriesModifyScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoriesModifyScreen> {
  late TextEditingController _categoryNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _categoryNameController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    super.dispose();
  }

  void _addCategory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<GetSalonProvider>(context, listen: false);
    final categoryName = _categoryNameController.text;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialogLoading(
          icon: Icon(Icons.download),
          title: 'Aktualizuję bazę danych',
          message: 'Dodaję nową kategorię.',
        );
      },
    );

    Categories newCategory = Categories(
      name: categoryName,
      salon: provider.salon!.id!,
    );

    final successCreateNew = await provider.createCategories([newCategory]);

    Navigator.of(context, rootNavigator: true).pop();

    if (successCreateNew) {
      await provider.fetchSalon(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategoria została dodana pomyślnie')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd przy dodawaniu kategorii')),
      );
    }
  }

  void _deleteCategory(int categoryId) async {
    final provider = Provider.of<GetSalonProvider>(context, listen: false);
    final category =
        provider.salon!.categories!.firstWhere((cat) => cat.id == categoryId);

    if (category.services != null && category.services!.isNotEmpty) {
      final availableServices = category.services!
          .where((service) => service.isAvailable == true)
          .toList();
      if (availableServices.isNotEmpty) {
        String servicesList =
            availableServices.map((service) => service.title).join(', ');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Najpierw usuń dostępne usługi: $servicesList')),
        );
        return;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialogLoading(
          icon: Icon(Icons.update),
          title: 'Aktualizuję bazę danych',
          message: 'Aktualizuję kategorię.',
        );
      },
    );

    final successUpdate = await provider.changeIsAvailableCategory(category);

    Navigator.of(context, rootNavigator: true).pop();

    if (successUpdate) {
      await provider.fetchSalon(false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Kategoria została zaktualizowana pomyślnie')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Błąd przy aktualizacji kategorii')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories =
        Provider.of<GetSalonProvider>(context).salon?.categories ?? [];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Zarządzaj kategoriami',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                  height: 24,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Pamiętaj żeby użyć łatwej i zrozumiałej nazwy, zwiększy to ilość Twoich rezerwacji.',
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _categoryNameController,
                        decoration: const InputDecoration(
                          labelText: 'Nazwa kategorii',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nazwa kategorii nie może być pusta';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 20, 20, 20)),
                            side: MaterialStateProperty.all<BorderSide>(
                                BorderSide.none)),
                        onPressed: _addCategory,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Zapisz',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(255, 228, 228, 228),
                  height: 24,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tutaj możesz usunąć kategorie. Pamiętaj, że najpierw musisz usunąć wszystkie usługi przypisane do niej.',
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    if (category.isAvailable == false) {
                      return const SizedBox();
                    }
                    return ListTile(
                      title: Text(category.name!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCategory(category.id!),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
