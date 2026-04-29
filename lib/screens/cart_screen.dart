import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';

class CartScreen extends StatelessWidget {
  final CartController cartController;

  const CartScreen({super.key, required this.cartController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: const Text(
          '🛒 Mi Carrito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton.icon(
            onPressed: cartController.clearCart,
            icon: const Icon(Icons.delete_sweep, color: Colors.white70),
            label: const Text('Vaciar',
                style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: cartController.cartStream,
        initialData: cartController.cartItems,
        builder: (context, snapshot) {
          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🛒', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 12),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _CartItemTile(
                      item: item,
                      cartController: cartController,
                    );
                  },
                ),
              ),
              // Panel de total
              StreamBuilder<double>(
                stream: cartController.totalPriceStream,
                initialData: cartController.totalPrice,
                builder: (context, snapshot) {
                  final total = snapshot.data ?? 0.0;
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, -4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total a pagar:',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                '\$${total.toStringAsFixed(0)}',
                                key: ValueKey(total),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C63FF),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('✅ ¡Compra realizada!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              cartController.clearCart();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Pagar ahora',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final Product item;
  final CartController cartController;

  const _CartItemTile({required this.item, required this.cartController});

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
            color: Colors.black.withOpacity(0.05),
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