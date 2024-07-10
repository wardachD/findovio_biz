class City {
  final String name;
  final String country;
  final String? postalCode;

  City({required this.name, required this.country, this.postalCode});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name:
          json['address']['municipality'] ?? json['address']['freeformAddress'],
      country: json['address']['country'],
      postalCode: json['address']['postalCode'],
    );
  }
}
