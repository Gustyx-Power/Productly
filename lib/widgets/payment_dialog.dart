import 'package:flutter/material.dart';
import '../screens/payment_success_screen.dart';

Future<bool> showPaymentDialog(BuildContext context, int totalPrice) async {
  final Map<String, Map<String, dynamic>> methods = {
    'GoPay': {
      'balance': 50000,
      'color': Colors.green,
      'icon': 'assets/icons/gopay.png',
    },
    'ShopeePay': {
      'balance': 250000,
      'color': Colors.orange,
      'icon': 'assets/icons/spay.png',
    },
    'DANA': {
      'balance': 1000000,
      'color': Colors.blueAccent,
      'icon': 'assets/icons/dana.jpeg',
    },
    'Blu BCA Digital': {
      'balance': 1175809,
      'color': Colors.cyan,
      'icon': 'assets/icons/blu.png',
    },
    'SeaBank': {
      'balance': 3070605,
      'color': Colors.deepOrange,
      'icon': 'assets/icons/seabank.png',
    },
    'Bank Tabungan Negara': {
      'balance': 1000005,
      'color': Colors.amber,
      'icon': 'assets/icons/btn.png',
    },
  };

  String? selectedMethod;

  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Pilih Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: methods.entries.map((entry) {
                  final name = entry.key;
                  final data = entry.value;
                  final isSelected = selectedMethod == name;
                  final int balance = data['balance'];
                  final bool sufficient = balance >= totalPrice * 1000;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: data['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? data['color'] : Colors.transparent,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      leading: data['icon'] is String
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent, // or data['color'].withOpacity(0.2)
                              child: Padding(
                                padding: const EdgeInsets.all(4.0), // Adjust padding as needed
                                child: Image.asset(data['icon']),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: data['color'],
                              child: Icon(data['icon'], color: Colors.white),
                            ),
                      title: Text(name),
                      subtitle: Text(
                        "Saldo: Rp. $balance",
                        style: TextStyle(
                          color: sufficient ? Colors.green : Colors.red,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Icon(Icons.arrow_forward_ios, color: data['color']),
                      onTap: () {
                        if (!sufficient) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Saldo tidak cukup")),
                          );
                          return;
                        }
                        setState(() => selectedMethod = name);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              FilledButton.icon(
                onPressed: (selectedMethod != null &&
                    methods[selectedMethod]!['balance'] >= totalPrice * 1000)
                    ? () {
                  Navigator.pop(context, true); // tutup dialog
                  // Delay sedikit untuk memastikan dialog tertutup sebelum navigate
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentSuccessScreen(
                          title: "Pembayaran",
                          onFinish: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                        ),
                      ),
                    );
                  });
                }
                    : null,
                icon: const Icon(Icons.payment),
                label: const Text("Buat Pesanan"),
              ),
            ],
          );
        },
      );
    },
  ).then((value) => value ?? false);
}