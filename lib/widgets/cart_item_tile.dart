import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

class CartItemTile extends StatelessWidget {
  final Product item;
  final CartController cartController;

  const CartItemTile({super.key, required this.item, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF2D2B55))),
                Text(
                  '\$${item.price.toStringAsFixed(0)} × ${item.quantity}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF6C63FF),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => cartController.removeProduct(item.id),
            child: const Icon(Icons.remove_circle_outline,
                color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}