// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

List<Address> addressFromJson(String str) => List<Address>.from(json.decode(str).map((x) => Address.fromJson(x)));

String addressToJson(List<Address> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Address {
  int id;
  DateTime createdAt;
  String recipientsName;
  String phoneNumber;
  String district;
  String address;
  bool isDefultAddress;
  String userUid;

  Address({
    required this.id,
    required this.createdAt,
    required this.recipientsName,
    required this.phoneNumber,
    required this.district,
    required this.address,
    required this.isDefultAddress,
    required this.userUid,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    recipientsName: json["recipients_name"],
    phoneNumber: json["phone_number"],
    district: json["district"],
    address: json["address"],
    isDefultAddress: json["is_defult_address"],
    userUid: json["user_uid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "recipients_name": recipientsName,
    "phone_number": phoneNumber,
    "district": district,
    "address": address,
    "is_defult_address": isDefultAddress,
    "user_uid": userUid,
  };
}
