import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/checkout_view_model.dart';
import 'user_address_update.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final viewModel = Get.put(CheckoutController());

  @override
  void initState() {
    // TODO: implement initState
    viewModel.fetchAddressForUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Column(
        children: [
          // 1. User Address Section
          _AddressSection(),

          Divider(),

          // 2. Product List Section with Quantity Management
          Expanded(
            child: _ProductListSection(),
          ),

          Divider(),

          // 3. Delivery Option
          _DeliveryOption(),

          // 4. Bottom Section with Grand Total and Place Order Button
          _BottomSummarySection(),
        ],
      ),
    );
  }
}

class _AddressSection extends StatelessWidget {
  final CheckoutController viewModel = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Text(viewModel.address?.value?.recipientsName ?? 'Set name',style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${viewModel.address?.value?.address ?? 'Set you district and thana and local address'}, ${viewModel.address?.value?.district ?? ''}'),
            Text('${viewModel.address?.value?.phoneNumber ?? 'Set your phone number'}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            // Navigate to Edit Address Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressInputScreen()),
            );
          },
        ),
      ),
    ));
  }
}

class _ProductListSection extends StatefulWidget {
  @override
  _ProductListSectionState createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<_ProductListSection> {
  int quantity = 1; // Example quantity for a single product
  final CheckoutController viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1, // Assume we have 3 products for demonstration
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product ${index + 1}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Unit Price: \$20.00', // Example unit price
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Description: High-quality product', // Example description
                  style: TextStyle(color: Colors.grey[700]),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (quantity > 1) quantity--;
                            });
                          },
                        ),
                        Text(quantity.toString()),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      'Total: \$${(20 * quantity).toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DeliveryOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Standard Delivery'),
      subtitle: Text('Arrives in 3-5 days'),
      trailing: Text('\$5.00'), // Example delivery fee
    );
  }
}

class _BottomSummarySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grand Total',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$65.00', // Example total
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Place Order Action
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Order Placed'),
                  content: Text('Thank you for your purchase!'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Place Order'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class EditAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Address')),
      body: Center(child: Text('Edit Address Screen')),
    );
  }
}