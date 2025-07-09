import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../services/cart_service.dart';
import '../widgets/payment_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> items = [];
  Set<int> selectedIds = {};
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  void loadCart() {
    final loaded = CartService.getItems();
    setState(() {
      items = loaded;
      if (selectAll) {
        selectedIds = loaded.map((e) => e.product.id).toSet();
      }
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

  void toggleSelect(int id) {
    setState(() {
      selectedIds.contains(id) ? selectedIds.remove(id) : selectedIds.add(id);
      selectAll = selectedIds.length == items.length;
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedIds = selectAll ? items.map((e) => e.product.id).toSet() : {};
    });
  }

  int getSelectedTotal() {
    return items
        .where((item) => selectedIds.contains(item.product.id))
        .fold(0, (sum, item) => sum + item.product.price * item.quantity);
  }

  Future<void> handleCheckout() async {
    final selectedItems = items.where((i) => selectedIds.contains(i.product.id)).toList();
    final totalPrice = getSelectedTotal();

    if (selectedItems.isEmpty) return;

    final success = await showPaymentDialog(context, totalPrice);

    if (success && mounted) {
      for (var item in selectedItems) {
        await CartService.removeItem(item.product.id);
      }
      loadCart();
      selectedIds.clear();

      Navigator.pushNamed(context, '/payment-success');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedTotal = getSelectedTotal();

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: items.isEmpty
          ? const Center(child: Text("Keranjang kosong"))
          : Column(
        children: [
          CheckboxListTile(
            title: const Text("Pilih Semua"),
            value: selectAll,
            onChanged: toggleSelectAll,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final item = items[i];
                final isSelected = selectedIds.contains(item.product.id);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => toggleSelect(item.product.id),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.product.image,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.title,
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${item.product.price}.000",
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  _qtyButton(Icons.remove, () => updateQty(item, item.quantity - 1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(item.quantity.toString()),
                                  ),
                                  _qtyButton(Icons.add, () => updateQty(item, item.quantity + 1)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeItem(item),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Total: Rp $selectedTotal.000",
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                FilledButton.icon(
                  onPressed: selectedIds.isEmpty ? null : handleCheckout,
                  icon: const Icon(Icons.payment),
                  label: const Text("Pesan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}