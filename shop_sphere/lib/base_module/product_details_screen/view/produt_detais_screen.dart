import 'package:flutter/material.dart';
import '../../home/model/list_of_product_model.dart';
import 'package:get/get.dart';
import '../view_model/product_datails_view_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;
  final Product product;

  ProductDetailsScreen({Key? key, required this.productId, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Dummy review data
  ProductDetailsViewModel viewModel = Get.put(ProductDetailsViewModel());
  final List<Map<String, dynamic>> reviews = [
    {
      "email": "user1@example.com",
      "rating": 4,
      "comment": "Great product, really liked it!"
    },
    {
      "email": "user2@example.com",
      "rating": 5,
      "comment": "Amazing quality! Exceeded my expectations."
    },
    {
      "email": "user3@example.com",
      "rating": 3,
      "comment": "Good, but could be improved in some areas."
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    viewModel.fetchReviews(widget.product.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Image.network(
                widget.product.image,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),

            // Product Title
            Text(
              widget.product.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // Price and Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${widget.product.price}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                if (widget.product.discountPercentage != null)
                  Text(
                    "\$${widget.product.discountPercentage}",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.0),

            // Rating and Reviews
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star, color: Colors.orange, size: 20),
                Icon(Icons.star_border, color: Colors.orange, size: 20),
                SizedBox(width: 8.0),
                Text("${widget.product.stock}"),
              ],
            ),
            SizedBox(height: 16.0),

            // Product Description
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.product.description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),

            // Category
            Text(
              "Category: ${widget.product.category}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16.0),

            // Add to Cart and Buy Now buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart),
                  label: Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.attach_money),
                  label: Text("Buy Now"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // Reviews Section
            Divider(),
            Text(
              "Customer Reviews",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),

            // List of Reviews
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(review["email"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.0),
                        Row(
                          children: List.generate(
                            review["rating"],
                                (i) => Icon(Icons.star, color: Colors.orange, size: 16),
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(review["comment"]),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
