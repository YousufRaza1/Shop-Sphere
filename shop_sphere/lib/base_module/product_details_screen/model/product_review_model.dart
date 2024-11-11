import 'dart:convert';
class ProductReview {
  final int id;
  final DateTime createdAt;
  final int productId;
  final String userEmail;
  final int rating;
  final String review;

  ProductReview({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.userEmail,
    required this.rating,
    required this.review,
  });

  // Factory method to create a ProductReview instance from a JSON map
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      productId: json['product_id'] as int,
      userEmail: json['user_email'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String,
    );
  }

  // Optional: Method to convert ProductReview to JSON (for any future needs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'product_id': productId,
      'user_email': userEmail,
      'rating': rating,
      'review': review,
    };
  }
}


// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);



List<Cart> cartFromJson(String str) => List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  int id;
  DateTime createdAt;
  int productId;
  bool isSelected;
  String userUid;

  Cart({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.isSelected,
    required this.userUid,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
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
