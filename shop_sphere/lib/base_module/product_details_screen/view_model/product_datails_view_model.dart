import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product_review_model.dart';
import 'package:get/get.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';

class ProductDetailsViewModel extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  RxList<ProductReview> listOfReviews = RxList<ProductReview>([]);
  final AuthService authService = Get.find<AuthService>();
  RxBool isLoading = false.obs;
  LogedInUser user = LogedInUser();

  void fetchReviews(int productId) async {
    isLoading.value = true;
    final response = await _client
        .from('Product_Review')
        .select()
        .eq('product_id', productId);

    // Checking if data exists and casting it to the expected type
    final data = response as List<dynamic>;
    listOfReviews.value =  data.map((json) =>
        ProductReview.fromJson(json as Map<String, dynamic>)).toList();
    print(listOfReviews);
    isLoading.value = false;
  }

  Future<void> addProductReview({
    required int productId,
    required int rating,
    required String review,
  }) async {

    final userEmail =  user.usrEmail;

    final response = await _client.from('Product_Review').insert({
      'product_id': productId,
      'rating': rating,
      'review': review,
      'user_email': userEmail,
    });

    listOfReviews.add(ProductReview(id: 1, createdAt: DateTime.now(), productId: productId, userEmail: userEmail!, rating: rating, review: review));
    // fetchReviews(productId);

    if (response.error != null) {
      throw Exception('Failed to add review: ${response.error!.message}');
    } else {
      print('Review added successfully');
    }
  }
}
