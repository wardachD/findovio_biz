class TimeSlotModel {
  final int id;
  final int salon;
  final String date;
  final String timeFrom;
  final String timeTo;
  final bool isAvailable;

  TimeSlotModel(
      {required this.id,
      required this.salon,
      required this.date,
      required this.timeFrom,
      required this.timeTo,
      required this.isAvailable});

  // Factory method to create TimeSlotModel object from a map
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      salon: json['salon'],
      date: json['date'],
      timeFrom: json['time_from'],
      timeTo: json['time_to'],
      isAvailable: json['is_available'],
    );
  }

  // Method to convert TimeSlotModel object to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salon': salon,
      'date': date,
      'time_from': timeFrom,
      'time_to': timeTo,
      'is_available': isAvailable,
    };
  }
}
