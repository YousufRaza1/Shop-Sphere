import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_sphere/base_module/BuyProduct/view/checkout_screen.dart';
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
    cartController.selectedProductId();
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
              key: Key(cartItem.id.toString()),
              // Use unique keys
              direction: DismissDirection.endToStart,
              // Swipe from right to left
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (direction) {
                cartController.removeProduct(cartItem.id);
              },
              child: CartItemCard(cartItem: cartItem),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: SizedBox(
            width: double.infinity, // Full width
            height: 100,            // Desired height
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Get.to(CheckoutScreen(
                  listOfProductId: cartController.listOfselectedProductId,
                ));
                cartController.checkout();
              },
              child: Text('Checkout'),
            ),
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
                    Get.find<CartController>().selectedProductId();
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
