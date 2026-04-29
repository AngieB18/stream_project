import 'package:flutter/material.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'cart_screen.dart';

class ProductListScreen extends StatefulWidget {
  final CartController cartController;

  const ProductListScreen({super.key, required this.cartController});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final List<Product> _products = [
    Product(id: '1', name: 'Manzana', price: 1500, emoji: '🍎'),
    Product(id: '2', name: 'Leche', price: 3200, emoji: '🥛'),
    Product(id: '3', name: 'Pan', price: 2500, emoji: '🍞'),
    Product(id: '4', name: 'Huevos', price: 8000, emoji: '🥚'),
    Product(id: '5', name: 'Arroz', price: 4500, emoji: '🍚'),
    Product(id: '6', name: 'Jugo', price: 3800, emoji: '🧃'),
    Product(id: '7', name: 'Café', price: 12000, emoji: '☕'),
    Product(id: '8', name: 'Yogur', price: 5500, emoji: '🫙'),
  ];

  @override
  void dispose() {
    widget.cartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '🛍️ StreamShop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          // 🔴 Contador del AppBar usando StreamBuilder
          StreamBuilder<int>(
            stream: widget.cartController.itemCountStream,
            initialData: 0,
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_rounded, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CartScreen(
                            cartController: widget.cartController,
                          ),
                        ),
                      );
                    },
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con total en tiempo real
          StreamBuilder<double>(
            stream: widget.cartController.totalPriceStream,
            initialData: 0.0,
            builder: (context, snapshot) {
              final total = snapshot.data ?? 0.0;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                decoration: const BoxDecoration(
                  color: Color(0xFF6C63FF),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Text(
                  total > 0
                      ? 'Total: \$${total.toStringAsFixed(0)}'
                      : 'Agrega productos al carrito',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text(
              'Productos disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2B55),
              ),
            ),
          ),
          // Grid de productos
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return _ProductCard(
                  product: product,
                  cartController: widget.cartController,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final CartController cartController;

  const _ProductCard({
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
                color: Colors.black.withOpacity(0.06),
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
                    _CircleButton(
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
                    _CircleButton(
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

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _CircleButton({
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}