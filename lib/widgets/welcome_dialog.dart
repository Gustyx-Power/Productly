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

  // Fungsi untuk membuka URL di browser eksternal
  void _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak bisa membuka URL: $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;

    return ScaleTransition(
      scale: _scaleAnim,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Selamat Datang Di Productly! 🎉",
          style: TextStyle(color: textColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Terima Kasih Telah Menggunakan Aplikasi Ini Sebagai Bagian Dari Tugas Akhir Mata Kuliah Pemrograman Mobile 2.",
              style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            ),
            const SizedBox(height: 8),
            Text(
              "Aplikasi Ini Dikembangkan Oleh\nGusti Aditya Muzaky\nUniversitas Pelita Bangsa",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "🚀 Proyek Ini Juga Bagian Dari Pengembangan Open-Source Apps Saya Sebagai Founder Dari:\nXtra Manager Software (XMS) — Berjalan Di Sumber Terbuka!.",
              style: theme.textTheme.bodySmall?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(FontAwesomeIcons.github),
                  color: textColor, // Warna ikon
                  tooltip: 'GitHub',
                  onPressed: () => _launchURL("https://github.com/Gustyx-Power"),
                ),
                IconButton(
                  icon: const Icon(Icons.telegram),
                  color: textColor, // Warna ikon
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
            child: Text(
              "Jangan tampilkan lagi",
              style: TextStyle(color: textColor),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(color: theme.brightness == Brightness.light ? Colors.black : Colors.white), // Sesuaikan warna teks tombol OK
            ),
          ),
        ],
      ),
    );
  }
}