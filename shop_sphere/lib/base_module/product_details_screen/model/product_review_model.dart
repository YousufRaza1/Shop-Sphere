class ProductReview {
  final int id;
  final DateTime createdAt;
  final int productId;
  final String userEmail;
  final int rating;
  final String review;

  ProductReview({
    required this.id,
    required this.createdAt,
    required this.productId,
    required this.userEmail,
    required this.rating,
    required this.review,
  });

  // Factory method to create a ProductReview instance from a JSON map
  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      productId: json['product_id'] as int,
      userEmail: json['user_email'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String,
    );
  }

  // Optional: Method to convert ProductReview to JSON (for any future needs)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'product_id': productId,
      'user_email': userEmail,
      'rating': rating,
      'review': review,
    };
  }
}
