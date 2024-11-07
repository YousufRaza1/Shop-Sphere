import 'package:get/get.dart';
import 'package:shop_sphere/base_module/BuyProduct/model/user_address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';
import '../../home/model/list_of_product_model.dart';

class CheckoutController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final LogedInUser _logedInUser = LogedInUser();
  Rx<Address?> address = Rx<Address?>(null);
  List<int> listOfProductId = [];
  RxList<Product> fetchedProducts = RxList<Product>([]);

  getProductDetails() async {
    for (int i = 0; i < listOfProductId.length; i++) {
      final response = await _client
          .from('Product')
          .select()
          .eq('id', listOfProductId[i])
          .single(); // Fetch a single row for the specific id

      if (response != null) {
        // Parse the response to a Product object and add it to fetchedProducts list
        fetchedProducts.value.add(Product.fromJson(response));
        fetchedProducts.refresh();
      } else {
        print('Failed to load product with ID: ${listOfProductId[i]}');
      }
    }
    print(fetchedProducts.length);
  }


  updateAddressOfUser(
      String recipientsName,
      String phoneNumber,
      String district,
      String address
      ) async {
    final userUid = _logedInUser.uid;
    final response =
        await _client.from('Customer_Address').select().eq('user_uid', userUid);

    if (response != null) {
      print(response);
      final data = response as List<dynamic>;

      final listOfAddress = data
          .map((json) => Address.fromJson(json as Map<String, dynamic>))
          .toList();
      if (listOfAddress.length == 0) {
        print('no address value, insert');
        await _client.from('Customer_Address').insert({
          'recipients_name': recipientsName,
          'phone_number': phoneNumber,
          'district': district,
          'address': address,
          'user_uid': _logedInUser.uid
        });
      } else {
        print('already have value, update');
        await _client.from('Customer_Address').update({
          'recipients_name': recipientsName,
          'phone_number': phoneNumber,
          'district': district,
          'address': address
        }).eq('user_uid', _logedInUser.uid);
      }
      this.fetchAddressForUsers();
    } else {
      print('didnt find any data');
    }
  }

  fetchAddressForUsers() async {
    print('address of the user called');
    final userUid = _logedInUser.uid;
    final response =
        await _client.from('Customer_Address').select().eq('user_uid', userUid);

    if (response != null) {
      print(response);
      final data = response as List<dynamic>;

      final listOfAddress = data
          .map((json) => Address.fromJson(json as Map<String, dynamic>))
          .toList();
      if (listOfAddress.length >= 1) this.address.value = listOfAddress[0];
    } else {
      print('didnt find any data');
    }
  }
}
