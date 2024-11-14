import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/order_view_model.dart';
import '../model/OrderModel.dart';
import 'order_details_screen.dart';
import 'package:lottie/lottie.dart';

class OrderScreen extends StatefulWidget {
  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderViewModel orderViewModel = Get.put(OrderViewModel());

  @override
  void initState() {
    super.initState();
    orderViewModel.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: orderViewModel.isLoading.value == true ? Center(child: Lottie.asset('assets/loading.json')): SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderSection(
              context,
              title: "Current Orders",
              ordersList: orderViewModel.listOfCurrentOrders,
              emptyMessage: "No current orders available.",
            ),
            const SizedBox(height: 20),
            _buildOrderSection(
              context,
              title: "Past Orders",
              ordersList: orderViewModel.listOfPastOrders,
              emptyMessage: "No past orders available.",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSection(
      BuildContext context, {
        required String title,
        required RxList<OrderedProduct> ordersList,
        required String emptyMessage,
      }) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          if (ordersList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(emptyMessage),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                final order = ordersList[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => OrderDetailsScreen(order: order));
                  },
                  child: _buildOrderCard(context, order),
                );
              },
            ),
        ],
      );
    });
  }

  Widget _buildOrderCard(BuildContext context, OrderedProduct order) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Price: \$${order.price}"),
            Text("Quantity: ${order.unit}"),
            Text("Status: ${order.shippingStatus}"),
          ],
        ),
      ),
    );
  }
}
