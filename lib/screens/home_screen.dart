import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';
import '../widgets/welcome_dialog.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<String> categories = [];
  String selectedCategory = "All";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWelcomeDialog();
    });
  }

  Future<void> _checkWelcomeDialog() async {
    final box = await Hive.openBox('settings');
    final showWelcome = box.get('showWelcome', defaultValue: true);
    if (showWelcome && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const WelcomeDialog(),
      );
    }
  }

  Future<void> loadProducts() async {
    try {
      final apiProducts = await ApiService.fetchProducts();
      final customProducts = await ApiService.fetchCustomProducts();

      final combined = [
        ...apiProducts.map((p) => p.copyWith(source: "fakestore")),
        ...customProducts.map((p) => p.copyWith(source: "custom")),
      ];

      setState(() {
        allProducts = combined;
        filteredProducts = combined;
        categories = ["All", ...{for (var p in combined) p.category}];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Gagal memuat produk: $e");
    }
  }

  Future<void> refreshProducts() async {
    setState(() => isLoading = true);
    await loadProducts();
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = category == "All"
          ? allProducts
          : allProducts.where((p) => p.category == category).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          kAppName,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
          const SizedBox(width: 8),

          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: theme.colorScheme.secondaryContainer,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories
                  .map((c) =>
                  DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (val) {
                if (val != null) filterByCategory(val);
              },
              decoration: const InputDecoration(
                labelText: "Filter Kategori",
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshProducts,
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return Stack(
                    children: [
                      ProductCard(product: product),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.source == "custom"
                                ? Colors.amber
                                : Colors.blueGrey,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.source == "custom"
                                ? "Custom API"
                                : "Fakestore",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}