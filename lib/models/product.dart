class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.quantity = 0,
  });

  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      emoji: emoji,
      quantity: quantity ?? this.quantity,
    );
  }
}