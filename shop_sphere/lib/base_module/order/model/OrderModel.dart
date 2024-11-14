import 'dart:convert';
import 'package:get/get.dart';

List<OrderedProduct> orderedProductFromJson(String str) =>
    List<OrderedProduct>.from(json.decode(str).map((x) => OrderedProduct.fromJson(x)));

String orderedProductToJson(List<OrderedProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderedProductUIModel extends GetxController {

  RxInt id;
  Rx<DateTime> createdAt;
  RxString title;
  RxString description;
  RxString category;
  RxDouble price;
  RxDouble discountPercentage;
  RxDouble rating;
  RxInt stock;
  RxString warrantyInformation;
  RxString shippingInformation;
  RxString availabilityStatus;
  RxString image;
  RxInt unit;
  RxDouble totalPrice;
  RxString shippingStatus;
  RxString trackingNumber;
  Rx<DateTime> estimatedDeliveryDate;

  // Constructor with required initial values
  OrderedProductUIModel({
    required int id,
    required DateTime createdAt,
    required String title,
    required String description,
    required String category,
    required double price,
    required double discountPercentage,
    required double rating,
    required int stock,
    required String warrantyInformation,
    required String shippingInformation,
    required String availabilityStatus,
    required String image,
    required String shippingStatus,
    required String trackingNumber,
    required DateTime estimatedDeliveryDate,
    required int unit
  })  : id = id.obs,
        createdAt = createdAt.obs,
        title = title.obs,
        description = description.obs,
        category = category.obs,
        price = price.obs,
        discountPercentage = discountPercentage.obs,
        rating = rating.obs,
        stock = stock.obs,
        warrantyInformation = warrantyInformation.obs,
        shippingInformation = shippingInformation.obs,
        availabilityStatus = availabilityStatus.obs,
        image = image.obs,
        unit = unit.obs,
        totalPrice = price.obs,
        shippingStatus = shippingStatus.obs,
        trackingNumber = trackingNumber.obs,
        estimatedDeliveryDate = estimatedDeliveryDate.obs;
}

class OrderedProduct extends GetxController {
  int id;
  DateTime createdAt;
  String title;
  String description;
  String category;
  double price;
  double discountPercentage;
  double rating;
  int stock;
  String warrantyInformation;
  String shippingInformation;
  String availabilityStatus;
  String image;
  int unit;
  RxBool isSelected = RxBool(true);
  String shippingStatus;
  String trackingNumber;
  DateTime estimatedDeliveryDate;

  OrderedProduct({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.image,
    this.unit = 1,
    required this.shippingStatus,
    required this.trackingNumber,
    required this.estimatedDeliveryDate,
  });

  factory OrderedProduct.fromJson(Map<String, dynamic> json) => OrderedProduct(
    id: json["id"],
    createdAt: DateTime.parse(json["created_at"]),
    title: json["title"],
    description: json["description"],
    category: json["category"],
    price: json["price"]?.toDouble(),
    discountPercentage: json["discountPercentage"]?.toDouble(),
    rating: json["rating"]?.toDouble(),
    stock: json["stock"],
    warrantyInformation: json["warrantyInformation"],
    shippingInformation: json["shippingInformation"],
    availabilityStatus: json["availabilityStatus"],
    image: json["image"],
    shippingStatus: json["shippingStatus"],
    trackingNumber: json["trackingNumber"],
    estimatedDeliveryDate: DateTime.parse(json["estimatedDeliveryDate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt.toIso8601String(),
    "title": title,
    "description": description,
    "category": category,
    "price": price,
    "discountPercentage": discountPercentage,
    "rating": rating,
    "stock": stock,
    "warrantyInformation": warrantyInformation,
    "shippingInformation": shippingInformation,
    "availabilityStatus": availabilityStatus,
    "image": image,
    "shippingStatus": shippingStatus,
    "trackingNumber": trackingNumber,
    "estimatedDeliveryDate": estimatedDeliveryDate.toIso8601String(),
  };
}
