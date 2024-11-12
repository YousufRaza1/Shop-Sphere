import 'package:get/get.dart';
import 'dart:convert';
import '../model/cart_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';
import '../../home/model/list_of_product_model.dart';



class CartController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final LogedInUser _logedInUser = LogedInUser();
  RxList<Product> listOfProduct = RxList<Product>([]);

  void checkout() {
    // Perform checkout action
    Get.snackbar('Checkout', 'Proceeding to checkout');
  }

  getAllCartProduct() async {
    listOfProduct =  RxList<Product>([]);
    final responseValueForExistCheck = await _client
        .from('Cart')
        .select()
        .eq('user_uid', _logedInUser.uid);

    if (responseValueForExistCheck != null) {
      print('responseValueForExistCheck = ${responseValueForExistCheck}');
      List<CartModel> cartItems = cartModelFromJson(json.encode(responseValueForExistCheck));
      for(int index = 0; index < cartItems.length; index ++) {
         print(cartItems[index].productId);
         final response = await _client
             .from('Product')
             .select()
             .eq('id', cartItems[index].productId) // Ensure only one unique product is fetched based on a condition
             .single();
        print('singleProduct = ${response}');
         if (response != null) {
          final cartProduct = Product.fromJson(response);

           listOfProduct.add(cartProduct);
           listOfProduct.refresh();
           print('count = ${listOfProduct.length}');
         }
      }

    } else {
      print('no item is found');
    }
  }
}
