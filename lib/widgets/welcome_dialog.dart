import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final box = Hive.box('settings');
    await box.put('showWelcome', false);
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      final canLaunchExternal = await canLaunchUrl(uri);
      if (canLaunchExternal) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint("Tidak bisa membuka URL: $url");
      }
    } catch (e) {
      debugPrint("Error buka URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _scaleAnim,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Selamat Datang Di Productly! 🎉"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Terima Kasih Telah Menggunakan Aplikasi Ini Sebagai Bagian Dari Tugas Akhir Mata Kuliah Pemrograman Mobile 2.",
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              "Aplikasi Ini Dikembangkan Oleh\nGusti Aditya Muzaky\nUniversitas Pelita Bangsa",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              "🚀 Proyek Ini Juga Bagian Dari Pengembangan Open-Source Apps Saya Sebagai Founder Dari:\nXtra Manager Software (XMS) — Berjalan Di Sumber Terbuka!.",
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.github),
                  tooltip: 'GitHub',
                  onPressed: () => _launchURL("https://github.com/Gustyx-Power"),
                ),
                IconButton(
                  icon: const Icon(Icons.telegram),
                  tooltip: 'XMS Telegram',
                  onPressed: () => _launchURL("https://t.me/XtraManagerSoftware"),
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