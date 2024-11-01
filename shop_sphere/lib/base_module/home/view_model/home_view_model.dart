
import '../model/list_of_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:get/get.dart';



import 'package:supabase_flutter/supabase_flutter.dart';

class HomeViewController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<List<Product>> listOfProduct = Rx<List<Product>>([]);


  void fetchProducts() async {
    final response = await Supabase.instance.client
        .from('Product')
        .select();

   print('response json = ${response}');

    if (response == null) {
      throw Exception('Failed to load products');
    }

    // Casting response to List to map to Product
    final data = response as List<dynamic>;
      listOfProduct.value =  data.map((json) => Product.fromJson(json)).toList();
    print('data = ${listOfProduct.value}');
  }

}

