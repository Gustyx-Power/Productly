// cart_item.dart
import 'package:hive/hive.dart';
import 'product_model.dart';

part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  final Product product;

  @HiveField(1)
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get total => product.price * quantity;
}