import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'circle_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final CartController cartController;

  const ProductCard({
    super.key,
    required this.product,
    required this.cartController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: cartController.cartStream,
      initialData: const [],
      builder: (context, snapshot) {
        final cartItems = snapshot.data ?? [];
        final cartItem = cartItems.where((p) => p.id == product.id);
        final quantity = cartItem.isNotEmpty ? cartItem.first.quantity : 0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: quantity > 0
                ? Border.all(color: const Color(0xFF6C63FF), width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(product.emoji,
                    style: const TextStyle(fontSize: 48)),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D2B55),
                  ),
                ),
                Text(
                  '\$${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Botones + / -
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleButton(
                      icon: Icons.remove,
                      color: quantity > 0
                          ? Colors.redAccent
                          : Colors.grey.shade300,
                      onTap: quantity > 0
                          ? () => cartController.removeProduct(product.id)
                          : null,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        '$quantity',
                        key: ValueKey(quantity),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: quantity > 0
                              ? const Color(0xFF6C63FF)
                              : Colors.grey,
                        ),
                      ),
                    ),
                    CircleButton(
                      icon: Icons.add,
                      color: const Color(0xFF6C63FF),
                      onTap: () => cartController.addProduct(product),
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