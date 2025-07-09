import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../services/auth_service.dart';
import '../widgets/payment_dialog.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> with TickerProviderStateMixin {
  int quantity = 1;

  void _handleCart() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      _showLoginDialog();
      return;
    }

    await CartService.addToCart(
      CartItem(product: widget.product, quantity: quantity),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Berhasil ditambahkan ke keranjang!")),
    );
  }

  void _handleBuyNow() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    if (!isLoggedIn) {
      _showLoginDialog();
      return;
    }

    final total = widget.product.price * quantity;
    final success = await showPaymentDialog(context, total);

    if (success && mounted) {
      Navigator.pushNamed(context, '/payment-success');
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Butuh Login"),
        content: const Text("Silakan login untuk menggunakan fitur ini."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              p.image,
              fit: BoxFit.cover,
              height: 240,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.title,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp ${p.price}.000",
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(p.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: const Icon(Icons.remove_circle),
              ),
              Text(quantity.toString(), style: theme.textTheme.titleLarge),
              IconButton(
                onPressed: () {
                  setState(() => quantity++);
                },
                icon: const Icon(Icons.add_circle),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _handleCart,
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Keranjang"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _handleBuyNow,
                  icon: const Icon(Icons.payment),
                  label: const Text("Beli Sekarang"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}