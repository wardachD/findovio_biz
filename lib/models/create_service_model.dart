import 'package:findovio_business/models/create_category_model.dart';

class CreateServiceModel {
  final String? title;
  final double? price;
  final CreateCategoryModel? category; // Pole przechowujące kategorię

  CreateServiceModel({this.title, this.price, this.category});
}
