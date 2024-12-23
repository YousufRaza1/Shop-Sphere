import 'package:get/get.dart';
import 'package:shop_sphere/base_module/BuyProduct/model/user_address_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';
import '../../home/model/list_of_product_model.dart';
import 'package:intl/intl.dart';
import 'dart:math';


class CheckoutController extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final LogedInUser _logedInUser = LogedInUser();
  Rx<Address?> address = Rx<Address?>(null);
  List<int> listOfProductId = [];
  RxDouble totalpriceOfAllProduct = 0.0.obs;

  RxList<ProductUIModel> productUI = RxList<ProductUIModel>([]);

  @override
  void onInit() {
    super.onInit();
    ever(productUI,
        (_) => calculateGrandTotal()); // Recalculate when the list updates
    productUI.forEach((product) {
      ever(
          product.totalPrice,
          (_) =>
              calculateGrandTotal()); // Recalculate on each product's price change
    });
  }

  void calculateGrandTotal() {
    double total = 0.0;
    for (var product in productUI) {
      total += product.totalPrice.value;
    }
    totalpriceOfAllProduct.value = total + 5.0;
  }

  void placeOrderClicked() async {
    print('placeOrderClicked');

    for (var product in productUI) {
      print('product.id = ${product.id}.');

      removeSingleItem(product.id.value);
      addToOrderList(product.id.value,product.unit.value);
    }
  }

  void removeSingleItem(int productID) async {
    final response = await _client
        .from('Cart')
        .delete()
        .eq('product_id', productID)
        .eq('user_uid', _logedInUser.uid);

    // Check if the response contains an error
    if (response.error == null) {
      print('Product removed successfully');
    } else {
      print('Error removing product: ${response.error!.message}');
    }
  }

  void addToOrderList(int productID,int unit) async {
    DateTime now = DateTime.now();
    DateTime futureDate = now.add(Duration(days: 5));

    // Format as ISO 8601 string
    String formattedDate = DateFormat("yyyy-MM-ddTHH:mm:ssZ").format(futureDate);
    final response = await _client.from('Order').insert({
      'product_id': productID,
      'user_uid': _logedInUser.uid,
      'shipping_status': getRandomStatus(), //Packed, In Transit, Delivered
      'unit': unit,
      'estimated_delivery_date': formattedDate
    });
  }

  getProductDetails() async {
    for (int i = 0; i < listOfProductId.length; i++) {
      final response = await _client
          .from('Product')
          .select()
          .eq('id', listOfProductId[i])
          .single();

      if (response != null) {
        // Parse the response to a Product object and add it to fetchedProducts list
        final product = Product.fromJson(response);
        productUI.value.add(ProductUIModel(
            id: product.id,
            createdAt: product.createdAt,
            title: product.title,
            description: product.description,
            category: product.category,
            price: product.price,
            discountPercentage: product.discountPercentage,
            rating: product.rating,
            stock: product.stock,
            warrantyInformation: product.warrantyInformation,
            shippingInformation: product.shippingInformation,
            availabilityStatus: product.availabilityStatus,
            image: product.image));
        productUI.refresh();
      } else {
        print('Failed to load product with ID: ${listOfProductId[i]}');
      }
    }
  }

  updateAddressOfUser(String recipientsName, String phoneNumber,
      String district, String address) async {
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

  String getRandomStatus() {
    List<String> statuses = ["Packed", "In Transit", "Delivered", "Ordered"];

    // Generate a random index
    Random random = Random();
    int randomIndex = random.nextInt(statuses.length);

    // Get a random status
    String randomStatus = statuses[randomIndex];
    return randomStatus;
  }
}
