import 'package:flutter/material.dart';
import '../../home/model/list_of_product_model.dart';
import 'package:get/get.dart';
import '../view_model/product_datails_view_model.dart';
import '../../BuyProduct/view/checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  ProductDetailsScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  // Dummy review data

  ProductDetailsViewModel viewModel = Get.put(ProductDetailsViewModel());

  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;

  void _submitReview() {
    final newReview = _reviewController.text;
    if (newReview.isEmpty || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a review and rating.")),
      );
      return;
    }

    // Send review and rating to the backend
    // viewModel.addReview(newReview, _selectedRating);
    viewModel.addProductReview(productId: widget.product.id,rating: _selectedRating, review: newReview);

    // Clear the input fields after submission
    _reviewController.clear();
    setState(() {
      _selectedRating = 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    viewModel.fetchReviews(widget.product.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
      body: Stack(
        children: [SingleChildScrollView(
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
              if(viewModel.isLoading == false)

                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add Your Review", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.0),

                          // Rating input
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                icon: Icon(
                                  index < _selectedRating ? Icons.star : Icons.star_border,
                                  color: Colors.orange,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedRating = index + 1;
                                  });
                                },
                              );
                            }),
                          ),

                          // Review text input
                          TextField(
                            textInputAction: TextInputAction.go,
                            onSubmitted: (value) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: _reviewController,
                            decoration: InputDecoration(
                              labelText: "Write your review",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 8.0),

                          // Submit button
                          ElevatedButton(
                            onPressed: _submitReview,
                            child: Text("Submit Review"),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: viewModel.listOfReviews.length,
                      itemBuilder: (context, index) {
                        final review = viewModel.listOfReviews[viewModel.listOfReviews.length - (index + 1)];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(review.userEmail),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.0),
                                Row(
                                  children: List.generate(
                                    review.rating,
                                        (i) => Icon(Icons.star, color: Colors.orange, size: 16),
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(review.review),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 60)
                  ],
                ),


              // if(viewModel.isLoading == true)
              //   Center(
              //     child: CircularProgressIndicator(),
              //   ),
            ],
          ),
        ),
          Column(
            children: [
              Spacer(),
              Container(
                color: Colors.teal,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart),
                        label: Text("Add to Cart",style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.to(CheckoutScreen(listOfProductId: [widget.product.id]));
                        },
                        icon: Icon(Icons.attach_money),

                        label: Text("Buy Now",style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ],
          ),
      ]
      ),
    )
    );
  }
}
