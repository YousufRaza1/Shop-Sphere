import 'package:get/get.dart';
class Cart extends GetxController{
  int id;
  String image;
  String title;
  String description;
  double price;
  RxBool isSelected;

  Cart({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.isSelected,
  });
}
