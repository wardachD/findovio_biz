class GetSalonModel {
  final int? id;
  final String? name;
  final String? addressCity;
  final String? addressPostalCode;
  final String? addressStreet;
  final String? addressNumber;
  final String? location;
  final String? about;
  final String? avatar;
  final String? phoneNumber;
  final String? email;
  final num? distanceFromQuery;
  final int? errorCode;
  final String? flutterCategory;
  final String? flutterGender;
  final List<Categories>? categories;
  final double? review;
  final List<int>? salonProperties;
  final List<String>? salonGallery;

  const GetSalonModel({
    this.id,
    this.name,
    this.addressCity,
    this.addressPostalCode,
    this.addressStreet,
    this.addressNumber,
    this.location,
    this.about,
    this.avatar,
    this.phoneNumber,
    this.email,
    this.distanceFromQuery,
    this.errorCode,
    this.flutterCategory,
    this.flutterGender,
    this.categories,
    this.review,
    this.salonProperties,
    this.salonGallery,
  });

  factory GetSalonModel.fromJson(Map<String, dynamic> json) {
    return GetSalonModel(
      id: json['id'] as int,
      name: json['name'] as String,
      addressCity: json['address_city'] as String,
      addressPostalCode: json['address_postal_code'] as String,
      addressStreet: json['address_street'] as String,
      addressNumber: json['address_number'] as String,
      location: json['location'] as String,
      about: json['about'] as String,
      avatar: json['avatar'] as String,
      phoneNumber: json['phone_number'] as String,
      email: json['email'] as String,
      distanceFromQuery: json['distance_from_query'] as num,
      errorCode: json['error_code'] as int,
      flutterCategory: json['flutter_category'] as String,
      flutterGender: json['flutter_gender_type'] as String,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((categoryJson) => Categories.fromJson(categoryJson))
          .toList(),
      review: json['review'] as double,
      salonProperties: (json['codes'] as List<dynamic>?)
              ?.map((code) => code as int)
              .toList() ??
          <int>[],
      salonGallery: (json['gallery'] as List<dynamic>?)
              ?.map((gallery) => gallery as String)
              .toList() ??
          <String>[],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address_city'] = addressCity;
    data['address_postal_code'] = addressPostalCode;
    data['address_street'] = addressStreet;
    data['address_number'] = addressNumber;
    data['location'] = location;
    data['about'] = about;
    data['avatar'] = avatar;
    data['phone_number'] = phoneNumber;
    data['email'] = email;
    data['distance_from_query'] = distanceFromQuery;
    data['error_code'] = errorCode;
    data['flutter_category'] = flutterCategory;
    data['flutter_gender_type'] = flutterGender;
    data['categories'] = categories?.map((v) => v.toJson()).toList();
    data['review'] = review;
    data['codes'] = salonProperties;
    data['gallery'] = salonGallery;
    return data;
  }

  GetSalonModel copyWith({
    int? id,
    String? name,
    String? addressCity,
    String? addressPostalCode,
    String? addressStreet,
    String? addressNumber,
    String? location,
    String? about,
    String? avatar,
    String? phoneNumber,
    String? email,
    num? distanceFromQuery,
    int? errorCode,
    String? flutterCategory,
    String? flutterGender,
    List<Categories>? categories,
    double? review,
    List<int>? salonProperties,
    List<String>? salonGallery,
  }) {
    return GetSalonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      addressCity: addressCity ?? this.addressCity,
      addressPostalCode: addressPostalCode ?? this.addressPostalCode,
      addressStreet: addressStreet ?? this.addressStreet,
      addressNumber: addressNumber ?? this.addressNumber,
      location: location ?? this.location,
      about: about ?? this.about,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      distanceFromQuery: distanceFromQuery ?? this.distanceFromQuery,
      errorCode: errorCode ?? this.errorCode,
      flutterCategory: flutterCategory ?? this.flutterCategory,
      flutterGender: flutterGender ?? this.flutterGender,
      categories: categories ?? this.categories,
      review: review ?? this.review,
      salonProperties: salonProperties ?? this.salonProperties,
      salonGallery: salonGallery ?? this.salonGallery,
    );
  }
}

class Categories {
  final int? id;
  final int? salon;
  final String? name;
  final List<Services>? services;
  final bool? isAvailable;

  Categories({this.id, this.salon, this.name, this.services, this.isAvailable});

  Categories copyWith({
    int? id,
    int? salon,
    String? name,
    List<Services>? services,
    bool? isAvailable,
  }) {
    return Categories(
        id: id ?? this.id,
        salon: salon ?? this.salon,
        name: name ?? this.name,
        services: services ?? this.services,
        isAvailable: isAvailable ?? this.isAvailable);
  }

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'] as int?,
      salon: json['salon'] as int?,
      name: json['name'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => Services.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAvailable: json['is_available'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (salon != null) data['salon'] = salon;
    if (name != null) data['name'] = name;
    if (services != null && services!.isNotEmpty) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    if (isAvailable != null) data['is_available'] = isAvailable;
    return data;
  }
}

class Services {
  final int? id;
  final int? salon;
  final int? category;
  final String? title;
  final String? description;
  final String? price;
  final int? durationMinutes;
  final bool? isAvailable;

  Services(
      {this.id,
      this.salon,
      this.category,
      this.title,
      this.description,
      this.price,
      this.durationMinutes,
      this.isAvailable});

  Services copyWith({
    int? id,
    int? salon,
    int? category,
    String? title,
    String? description,
    String? price,
    int? durationMinutes,
    bool? isAvailable,
  }) {
    return Services(
      id: id ?? this.id,
      salon: salon ?? this.salon,
      category: category ?? this.category,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  Services updateCategory(int? newCategory) {
    return Services(
      id: id,
      salon: salon,
      category: newCategory,
      title: title,
      description: description,
      price: price,
      durationMinutes: durationMinutes,
      isAvailable: isAvailable,
    );
  }

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['id'] as int?,
      salon: json['salon'] as int?,
      category: json['category'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: json['price'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      isAvailable: json['is_available'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (salon != null) data['salon'] = salon;
    if (category != null) data['category'] = category;
    if (category == null) {
      data['category'] = null;
    } else {
      data['category'] = category;
    }
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (price != null) data['price'] = price;
    if (durationMinutes != null) data['duration_minutes'] = durationMinutes;
    if (isAvailable != null) data['is_available'] = isAvailable;
    return data;
  }
}
