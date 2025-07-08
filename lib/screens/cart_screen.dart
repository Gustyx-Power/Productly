import 'package:flutter/material.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> items = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    setState(() {
      items = CartService.getItems();
    });
  }

  void updateQty(CartItem item, int qty) async {
    if (qty < 1) return;
    await CartService.updateQuantity(item.product.id, qty);
    loadCart();
  }

  void removeItem(CartItem item) async {
    await CartService.removeItem(item.product.id);
    loadCart();
  }

  void checkout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Metode Pembayaran"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(leading: Icon(Icons.qr_code), title: Text("GoPay")),
            ListTile(leading: Icon(Icons.qr_code), title: Text("ShopeePay")),
            ListTile(leading: Icon(Icons.qr_code), title: Text("DANA")),
            ListTile(leading: Icon(Icons.account_balance), title: Text("Blu BCA")),
            ListTile(leading: Icon(Icons.account_balance), title: Text("SeaBank")),
            ListTile(leading: Icon(Icons.account_balance_wallet), title: Text("Bank Lain")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              CartService.clearCart();
              loadCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pembayaran berhasil!")),
              );
            },
            child: const Text("Buat Pesanan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = CartService.getTotalPrice();

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: items.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                return ListTile(
                  leading: Image.network(
                    item.product.image,
                    width: 48,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image),
                  ),
                  title: Text(item.product.title),
                  subtitle: Text("Rp ${item.product.price}000"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => updateQty(item, item.quantity - 1),
                      ),
                      Text(item.quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => updateQty(item, item.quantity + 1),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: checkout,
              icon: const Icon(Icons.payment),
              label: Text("Bayar (Rp $total" "000)"),
            ),
          ),
        ],
      ),
    );
  }
}