import 'product.dart';

class CartItem {
  final String key;
  final String username;
  final int productId;
  final String title;
  final double price;
  final double rating;
  final int ratingCount;
  final String image;
  int quantity;
  final int stock;
  final String category;

  CartItem({
    required this.key,
    required this.username,
    required this.productId,
    required this.title,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.image,
    required this.quantity,
    required this.stock,
    required this.category,
  });

  double get totalPrice => price * quantity;

  Product toProduct() {
    return Product(
      id: productId,
      title: title,
      description: '',
      category: category,
      price: price,
      discountPercentage: 0,
      rating: rating,
      ratingCount: ratingCount,
      stock: stock,
      brand: category,
      tags: const [],
      images: image.isEmpty ? const [] : [image],
      thumbnail: image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'username': username,
      'productId': productId,
      'title': title,
      'price': price,
      'rating': rating,
      'ratingCount': ratingCount,
      'image': image,
      'quantity': quantity,
      'stock': stock,
      'category': category,
    };
  }

  factory CartItem.fromMap(String key, Map<dynamic, dynamic> map) {
    return CartItem(
      key: key,
      username: map['username']?.toString() ?? '',
      productId: (map['productId'] as num?)?.toInt() ?? 0,
      title: map['title']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
      image: map['image']?.toString() ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      category: map['category']?.toString() ?? '',
    );
  }
}
