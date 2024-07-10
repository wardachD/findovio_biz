import 'package:findovio_business/models/time_slot_model.dart';
import 'package:findovio_business/models/firebase_user_model.dart';

import 'get_salon_model.dart';

class AppointmentModel {
  int? id;
  int? salon;
  String? salonName;
  String? customer;
  FirebaseUser? customerObject;
  String? dateOfBooking;
  List<Services>? services;
  String? totalAmount;
  String? comment;
  String? status;
  String? createdAt;
  List<TimeSlotModel>? timeslots;
  double? get totalCost => countTotalServicesPrice();

  AppointmentModel(
      {this.id,
      this.salon,
      this.salonName,
      this.customer,
      this.customerObject,
      this.dateOfBooking,
      this.services,
      this.totalAmount,
      this.comment,
      this.status,
      this.createdAt,
      this.timeslots});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salon = json['salon'];
    salonName = json['salon_name'];
    customer = json['customer'];
    if (json['customer_object'] != null) {
      customerObject = FirebaseUser.fromJson(json['customer_object']);
    }
    dateOfBooking = json['date_of_booking'];
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    totalAmount = json['total_amount'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    if (json['timeslots'] != null) {
      timeslots = <TimeSlotModel>[];
      json['timeslots'].forEach((v) {
        timeslots!.add(TimeSlotModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['salon'] = salon;
    data['salon_name'] = salonName;
    data['customer'] = customer;
    data['customer_object'] = customerObject;
    data['date_of_booking'] = dateOfBooking;
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['total_amount'] = totalAmount;
    data['comment'] = comment;
    data['status'] = status;
    data['created_at'] = createdAt;
    if (timeslots != null) {
      data['timeslots'] = timeslots!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  double countTotalServicesPrice() {
    var totalAmount = 0.0;
    for (var element in services!) {
      String nullablePrice = element.price ?? '';
      totalAmount += double.parse(nullablePrice);
    }
    return totalAmount;
  }
}
