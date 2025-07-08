import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/cart_item.dart';
import 'models/product_model.dart';
import 'models/user_model.dart';
import 'theme/theme_config.dart';
import 'utils/constants.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔧 Init Hive dan direktori
  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  // ✅ Sebelum openBox, daftarkan adapter
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());


// ✅ Lalu open box-nya
  await Hive.openBox('products');
  await Hive.openBox<CartItem>('cart'); // buka sebagai CartItem
  await Hive.openBox('session');
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');

  // 🔒 Lock orientasi ke portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProductlyApp());
}

class ProductlyApp extends StatelessWidget {
  const ProductlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: lightTheme, // 🎨 Material 3 Light Theme
      home: const SplashScreen(), // 🚀 Mulai dari Splash Screen
    );
  }
}