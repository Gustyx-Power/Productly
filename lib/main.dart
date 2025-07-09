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
import 'screens/payment_success_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDir.path);

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(ProductAdapter());

  await Hive.openBox('products');
  await Hive.openBox<CartItem>('cart');
  await Hive.openBox('session');
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');

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
      theme: lightTheme,
      home: const SplashScreen(),

      routes: {
        '/payment-success': (context) => PaymentSuccessScreen(
          title: 'Pembayaran',
          onFinish: () {
            Navigator.popUntil(context, (route) => route.isFirst); // balik ke Home
          },
        ),
      },
    );
  }
}