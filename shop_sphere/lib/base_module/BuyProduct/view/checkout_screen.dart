import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/checkout_view_model.dart';
import 'user_address_update.dart';
import 'package:lottie/lottie.dart';


class CheckoutScreen extends StatefulWidget {
  List<int> listOfProductId;
  CheckoutScreen({ required this.listOfProductId});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final viewModel = Get.put(CheckoutController());

  @override
  void initState() {
    // TODO: implement initState\
    viewModel.listOfProductId = widget.listOfProductId;
    viewModel.fetchAddressForUsers();
    viewModel.getProductDetails();
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
            child: _ProductListSection(listOfProductId: widget.listOfProductId),
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
        // Add location icon on the left
        leading: Icon(Icons.location_on, color: Colors.red, size: 30), // Customize icon color and size
        title: Text(
          viewModel.address?.value?.recipientsName ?? 'Set name',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${viewModel.address?.value?.address ?? 'Set your district, thana, and local address'}, ${viewModel.address?.value?.district ?? ''}',
            ),
            Text(
              '${viewModel.address?.value?.phoneNumber ?? 'Set your phone number'}',
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
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
  final CheckoutController viewModel = Get.find();
  List<int> listOfProductId;
  _ProductListSection({ required this.listOfProductId});
  @override
  _ProductListSectionState createState() => _ProductListSectionState();
}

class _ProductListSectionState extends State<_ProductListSection> {
  int quantity = 1; // Example quantity for a single product
  final CheckoutController viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
      itemCount: viewModel.productUI.length,
      itemBuilder: (context, index) {
        final product = viewModel.productUI[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image on the left
                Container(
                  width: 80, // Adjust width as needed
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: NetworkImage(product.image.value), // Replace with your image URL
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 16.0), // Space between image and details
                // Product details on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title.toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Unit Price: \$${product.price}', // Example unit price
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        product.description.value, // Example description
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
                                    if (product.unit.value > 1) {
                                      product.unit.value--;
                                      product.totalPrice.value = product.unit.value * product.price.value;
                                      viewModel.calculateGrandTotal();
                                    }

                                  });
                                },
                              ),
                              Text(product.unit.value.toString()),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    product.unit.value++;
                                    product.totalPrice.value = product.unit.value * product.price.value;
                                    viewModel.calculateGrandTotal();
                                  });
                                },
                              ),
                            ],
                          ),
                          Text(
                            'Total: \$${(product.totalPrice.value).toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
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
  final CheckoutController viewModel = Get.find();
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
              Obx(() => Text(
                '\$${viewModel.totalpriceOfAllProduct.value.toStringAsFixed(2)}', // Displays reactive grand total
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                viewModel.placeOrderClicked();
                Get.to(SuccessScreen());
              },
              child: Text('Place Order'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: Colors.blue
              ),
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

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset('assets/success.json');
  }
}
