class CreateSalonModel {
  final String? name;
  final String? addressCity;
  final String? addressStreet;
  final String? addressNumber;
  final String? postalCode;
  final String? about;
  final String? phoneNumber;
  final String? flutterCategory;
  final String? flutterGenderType;
  final List<int>? codes;
  final String? email;
  final int errorCode;

  CreateSalonModel(
      {this.name,
      this.addressCity,
      this.addressStreet,
      this.addressNumber,
      this.postalCode,
      this.about,
      this.phoneNumber,
      this.flutterCategory,
      this.flutterGenderType,
      this.codes,
      this.email,
      required this.errorCode});

  // Konwersja obiektu do mapy, która może być serializowana do JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address_city': addressCity,
      'address_street': addressStreet,
      'address_number': addressNumber,
      'address_postal_code': postalCode,
      'about': about,
      'phoneNumber': phoneNumber,
      'flutterCategory': flutterCategory,
      'flutterGenderType': flutterGenderType,
      'codes': codes,
      'email': email,
      'error_code': errorCode,
    };
  }

  // Tworzenie obiektu z mapy.
  factory CreateSalonModel.fromJson(Map<String, dynamic> json) {
    return CreateSalonModel(
        name: json['name'],
        addressCity: json['addressCity'],
        addressStreet: json['addressStreet'],
        addressNumber: json['addressNumber'],
        about: json['about'],
        phoneNumber: json['phoneNumber'],
        flutterCategory: json['flutterCategory'],
        flutterGenderType: json['flutterGenderType'],
        codes: json['codes'],
        email: json['email'],
        errorCode: json['error_code']);
  }
}
