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
    isLoading.value = true;

    listOfPastOrders.clear();
    listOfCurrentOrders.clear();
    listOfOrders.clear();

    try {
      final response = await _client
          .from('Order')
          .select()
          .eq('user_uid', _logedInUser.uid);

      if (response == null) {
        print('Error fetching orders: ');
        isLoading.value = false;
        return;
      }

      final List<dynamic> data = response ?? [];
      listOfOrders.value = data.map((json) => Order.fromJson(json)).toList();

      for (var order in listOfOrders) {
        final productResponse = await _client
            .from('Product')
            .select()
            .eq('id', order.productId)
            .single();

        if (productResponse == null) {
          print('Error fetching product details:');
          continue;
        }

        final product = Product.fromJson(productResponse);
        final orderedProduct = OrderedProduct(
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
          estimatedDeliveryDate: order.estimatedDeliveryDate,
        );

        if (order.shippingStatus == 'Delivered') {
          listOfPastOrders.add(orderedProduct);
        } else {
          listOfCurrentOrders.add(orderedProduct);
        }
      }
    } catch (e) {
      print("An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
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