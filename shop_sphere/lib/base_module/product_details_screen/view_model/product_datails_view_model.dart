import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductDetailsViewModel extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;

 fetchReviews(int productId) async {
    final response = await _client
        .from('Product_Review')
        .select()
        .eq('product_id', productId)

    print(response);


  }

}