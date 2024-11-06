import 'package:get/get.dart';
import 'package:shop_sphere/base_module/BuyProduct/model/user_address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';

class CheckoutController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final LogedInUser _logedInUser = LogedInUser();
  Rx<Address?> address = Rx<Address?>(null);

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
      if(listOfAddress.length >= 1)
      this.address.value = listOfAddress[0];

    } else {
      print('didnt find any data');
    }
  }
}
