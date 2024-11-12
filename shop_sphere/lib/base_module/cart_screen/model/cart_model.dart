// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

List<CartModel> cartModelFromJson(String str) => List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

String cartModelToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartModel {
  int id;
  DateTime createdAt;
  int productId;
  bool isSelected;
  String userUid;

  CartModel({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.isSelected,
    required this.userUid,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    productId: json["product_id"],
    isSelected: json["is_selected"],
    userUid: json["user_uid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "product_id": productId,
    "is_selected": isSelected,
    "user_uid": userUid,
  };
}

