import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view_model/CartViewModel.dart';
import '../../home/model/list_of_product_model.dart';
import '../../product_details_screen/view/produt_detais_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.put(CartController());

  @override
  void initState() {
    super.initState();
    cartController.getAllCartProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Obx(
            () => ListView.builder(
          itemCount: cartController.listOfProduct.length,
          itemBuilder: (context, index) {
            final cartItem = cartController.listOfProduct[index];
            return Dismissible(
              key: Key(cartItem.id.toString()), // Use unique keys
              direction: DismissDirection.endToStart, // Swipe from right to left
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                // cartController.removeProduct(cartItem); // Remove item from controller
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${cartItem.title} removed from cart')),
                );
              },
              child: CartItemCard(cartItem: cartItem),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${100}', // Display total price dynamically
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: 10 > 0 ? cartController.checkout : null,
                child: Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final Product cartItem;

  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Checkbox(
              value: cartItem.isSelected.value,
              onChanged: (value) {
                cartItem.isSelected.value = value!;
                // Get.find<CartController>().calculateTotal();
              },
            )),
            Image.network(
              cartItem.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Get.to(ProductDetailsScreen(product: cartItem));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      cartItem.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '\$${cartItem.price.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
