import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({super.key});

  @override
  State<WelcomeDialog> createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setDoNotShowAgain() async {
    final box = Hive.box('session');
    await box.put('showWelcome', false);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnim,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Selamat Datang di Productly! 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Terima kasih telah menggunakan aplikasi ini sebagai bagian dari tugas akhir mata kuliah *Pengembangan Aplikasi Mobile*.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              "Aplikasi ini dikembangkan oleh\nGusti Aditya Muzaky\nUniversitas Pelita Bangsa",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "🚀 Proyek ini juga bagian dari pengembangan open-source saya:\n**Xtra Manager Software (XMS)** — solusi terbuka untuk manajemen perangkat.",
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.code),
                  tooltip: 'GitHub',
                  onPressed: () => _launchURL("https://github.com/gustyx/XtraManager"),
                ),
                IconButton(
                  icon: const Icon(Icons.telegram),
                  tooltip: 'Telegram',
                  onPressed: () => _launchURL("https://t.me/xms_community"),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _setDoNotShowAgain();
              if (!mounted) return;
              Navigator.pop(context);
            },
            child: const Text("Jangan tampilkan lagi"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}