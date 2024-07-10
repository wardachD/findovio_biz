class GetSalonSchedule {
  final int? id;
  final int? dayOfWeek;
  final String? timeFrom;
  final String? timeTo;
  final int? timeSlotLength;
  final int? salonId;

  GetSalonSchedule(
      {this.id,
      required this.dayOfWeek,
      required this.timeFrom,
      required this.timeTo,
      this.timeSlotLength,
      required this.salonId});

  // Factory method to create SalonSchedule object from a map
  factory GetSalonSchedule.fromJson(Map<String, dynamic> json) {
    return GetSalonSchedule(
      id: json['id'] as int?,
      dayOfWeek: json['day_of_week'] as int?,
      timeFrom: json['open_time'] as String?,
      timeTo: json['close_time'] as String?,
      timeSlotLength: json['time_slot_length'] as int?,
      salonId: json['salon'] as int?,
    );
  }

  // Method to convert SalonSchedule object to a map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    if (dayOfWeek != null) data['day_of_week'] = dayOfWeek;
    if (timeFrom != null) data['open_time'] = timeFrom;
    if (timeTo != null) data['close_time'] = timeTo;
    if (timeSlotLength != null) data['time_slot_length'] = timeSlotLength;
    if (salonId != null) data['salon'] = salonId;
    return data;
  }
}
