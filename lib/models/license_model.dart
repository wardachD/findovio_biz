// Model for License
class LicenseModel {
  String username;
  int kindOfLicense;
  bool isActive;
  int planType;
  DateTime? createdAt;

  LicenseModel({
    required this.username,
    required this.kindOfLicense,
    required this.isActive,
    required this.planType,
    this.createdAt,
  });

  // Factory constructor to create a License object from JSON
  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      username: json['username'],
      kindOfLicense: json['kind_of_license'],
      isActive: json['is_active'],
      planType: json['plan_type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert License object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'kind_of_license': kindOfLicense,
      'is_active': isActive,
      'plan_type': planType,
    };
  }
}

// Model for Payment
class PaymentModel {
  String username;
  DateTime date;
  int kindOfLicense;
  int kindOfPayment;

  PaymentModel({
    required this.username,
    required this.date,
    required this.kindOfLicense,
    required this.kindOfPayment,
  });

  // Factory constructor to create a Payment object from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      username: json['username'],
      date: DateTime.parse(json['date']),
      kindOfLicense: json['kind_of_license'],
      kindOfPayment: json['kind_of_payment'],
    );
  }

  // Method to convert Payment object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'date': date.toIso8601String(),
      'kind_of_license': kindOfLicense,
      'kind_of_payment': kindOfPayment,
    };
  }
}

// Model for License status
class LicenseStatusModel {
  int remainingDays;
  bool isActive;

  LicenseStatusModel({
    required this.remainingDays,
    required this.isActive,
  });

  // Factory constructor to create a License Status object from JSON
  factory LicenseStatusModel.fromJson(Map<String, dynamic> json) {
    return LicenseStatusModel(
      remainingDays: json['remaining_days'],
      isActive: json['is_active'],
    );
  }
}
