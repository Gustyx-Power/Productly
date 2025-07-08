import 'package:hive/hive.dart';
import '../models/cart_item.dart';

class CartService {
  static Box<CartItem> get _cartBox => Hive.box<CartItem>('cart');

  // Tambah item ke keranjang
  static Future<void> addToCart(CartItem item) async {
    final existing = _cartBox.get(item.product.id);

    if (existing != null) {
      // Tambah kuantitas jika sudah ada
      existing.quantity += 1;
      await _cartBox.put(item.product.id, existing);
    } else {
      await _cartBox.put(item.product.id, item);
    }
  }

  // Ambil semua item
  static List<CartItem> getItems() {
    return _cartBox.values.toList();
  }

  // Hapus berdasarkan ID produk
  static Future<void> removeItem(int productId) async {
    await _cartBox.delete(productId);
  }

  // Update kuantitas
  static Future<void> updateQuantity(int productId, int newQty) async {
    final item = _cartBox.get(productId);
    if (item != null) {
      item.quantity = newQty < 1 ? 1 : newQty; // hindari qty < 1
      await _cartBox.put(productId, item);
    }
  }

  // Kosongkan keranjang
  static Future<void> clearCart() async {
    await _cartBox.clear();
  }

  // Total harga
  static int getTotalPrice() {
    return _cartBox.values.fold(0, (total, item) => total + (item.product.price * item.quantity));
  }

  // Total item
  static int getTotalQuantity() {
    return _cartBox.values.fold(0, (total, item) => total + item.quantity);
  }
}