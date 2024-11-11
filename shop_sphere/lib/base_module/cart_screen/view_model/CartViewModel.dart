import 'package:get/get.dart';
import '../model/cart_model.dart';

class CartController extends GetxController {
  var cartItems = <Cart>[
    Cart(
      id: 1,
      image: 'https://via.placeholder.com/60',
      title: 'Product 1',
      description: 'This is a description of product 1.',
      price: 29.99,
      isSelected: true.obs,
    ),
    Cart(
      id: 2,
      image: 'https://via.placeholder.com/60',
      title: 'Product 2',
      description: 'This is a description of product 2.',
      price: 49.99,
      isSelected: false.obs,
    ),
  ].obs;

  // Calculate total price of selected items only
  Rx<double> get totalPrice => cartItems.fold(0.0.obs, (sum, item) {
        return item.isSelected.value ? sum + item.price : sum;
      });

  void checkout() {
    // Perform checkout action
    Get.snackbar('Checkout', 'Proceeding to checkout');
  }

  getAllCartProduct() async {}
}
