import 'package:get/get.dart';
import '../../Authentication/ViewModel/AuthViewModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/OrderModel.dart';
import '../../home/model/list_of_product_model.dart';


class OrderViewModel extends GetxController {
  final SupabaseClient _client = Supabase.instance.client;
  final LogedInUser _logedInUser = LogedInUser();
  RxList<Order> listOfOrders = RxList<Order>([]);
  RxBool isLoading = false.obs;

  RxList<OrderedProduct> listOfPastOrders = RxList<OrderedProduct>([]);
  RxList<OrderedProduct> listOfCurrentOrders = RxList<OrderedProduct>([]);



  void fetchOrders() async {
   // this.isLoading.value = true;
    listOfPastOrders = RxList<OrderedProduct>([]);
     listOfCurrentOrders = RxList<OrderedProduct>([]);
    listOfOrders.value = RxList<Order>([]);
    // Perform the query and wait for the response
    final response = await _client
        .from('Order')
        .select()
        .eq('user_uid', _logedInUser.uid);

    // Check for errors
    if (response == null) {
      print('Error fetching orders: ');
      this.isLoading.value = false;
      return;
    }

    // Decode the data into a list of Order objects if no errors
    final List<dynamic> data = response;
    listOfOrders.value = data.map((json) => Order.fromJson(json))
        .toList();
    listOfOrders.refresh();

    // Print each order's details
    for (var order in listOfOrders.value) {

      print('Product ID: ${order.productId}');

      final response = await _client
          .from('Product')
          .select()
          .eq('id', order.productId)
          .single();

      if (response != null) {
        // Parse the response to a Product object and add it to fetchedProducts list
        final product = Product.fromJson(response);
        if(order.shippingStatus == 'Delivered') {
          this.listOfPastOrders.value.add(OrderedProduct(
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
              image: product.image,
              unit: order.unit,
              shippingStatus: order.shippingStatus,
              trackingNumber: order.trackingNumber,
              estimatedDeliveryDate: order.estimatedDeliveryDate
          ));
          listOfPastOrders.refresh();
        } else {
          this.listOfCurrentOrders.value.add(OrderedProduct(
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
              image: product.image,
              unit: order.unit,
              shippingStatus: order.shippingStatus,
              trackingNumber: order.trackingNumber,
              estimatedDeliveryDate: order.estimatedDeliveryDate
          ));
          listOfCurrentOrders.refresh();
        }


      } else {
        isLoading.value = false;
        isLoading.refresh();

      }



    }
    isLoading.value = false;
    isLoading.refresh();

  }




}



class Order {
  final int id;
  final DateTime createdAt;
  final int productId;
  final String userUid;
  final String shippingStatus;
  final int unit;
  final String trackingNumber;
  final DateTime estimatedDeliveryDate;

  Order({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.userUid,
    required this.shippingStatus,
    required this.unit,
    required this.trackingNumber,
    required this.estimatedDeliveryDate,
  });

  // Factory method to create an Order instance from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      productId: json['product_id'],
      userUid: json['user_uid'],
      shippingStatus: json['shipping_status'],
      unit: json['unit'],
      trackingNumber: json['tracking_number'],
      estimatedDeliveryDate: DateTime.parse(json['estimated_delivery_date']),
    );
  }
}