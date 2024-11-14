import 'package:flutter/material.dart';
import '../model/OrderModel.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderedProduct order;

  OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text("Description: ${order.description}"),
            SizedBox(height: 8),
            Text("Price: \$${order.price}"),
            Text("Discount: ${order.discountPercentage}%"),
            Text("Quantity: ${order.unit}"),
            SizedBox(height: 8),
            Text("Shipping Status: ${order.shippingStatus}"),
            Text("Tracking Number: ${order.trackingNumber}"),
            Text("Estimated Delivery: ${order.estimatedDeliveryDate}"),
            SizedBox(height: 16),
            _buildStatusIndicator(order.shippingStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String status) {
    int currentStatusIndex = _statusToIndex(status);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatusStep("Ordered", currentStatusIndex >= 0),
        _buildStatusStep("Packed", currentStatusIndex >= 1),
        _buildStatusStep("In Transit", currentStatusIndex >= 2),
        _buildStatusStep("Delivered", currentStatusIndex >= 3),
      ],
    );
  }

  int _statusToIndex(String status) {
    switch (status) {
      case "Ordered":
        return 0;
      case "Packed":
        return 1;
      case "In Transit":
        return 2;
      case "Delivered":
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildStatusStep(String label, bool isActive) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? Colors.green : Colors.grey,
          child: Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
      ],
    );
  }
}
