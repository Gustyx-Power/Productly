import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String title;
  final VoidCallback onFinish;

  const PaymentSuccessScreen({
    super.key,
    required this.title,
    required this.onFinish,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> with TickerProviderStateMixin {
  final _audioPlayer = AudioPlayer();
  bool _isSuccess = false;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    // ⏳ Tampilkan loading, lalu ganti ke sukses
    Future.delayed(const Duration(seconds: 3), () async {
      setState(() => _isSuccess = true);
      await _audioPlayer.play(AssetSource('sounds/chaching.mp3'));
    });

    // ⏭ Keluar otomatis setelah 5 detik
    Future.delayed(const Duration(seconds: 8), () {
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Stack(
        children: [
          Positioned.fill(child: _AnimatedWaveBackground(_waveController)),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: _isSuccess
                  ? Column(
                key: const ValueKey("success"),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/success_payment.json',
                    width: 180,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Pembayaran Berhasil!",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : Column(
                key: const ValueKey("loading"),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    'assets/lottie/loading_wallet.json',
                    width: 120,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Memverifikasi Pembayaran...",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedWaveBackground extends StatelessWidget {
  final AnimationController controller;

  const _AnimatedWaveBackground(this.controller);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return ClipPath(
          clipper: _WaveClipper(controller.value),
          child: Container(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ),
        );
      },
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animation;

  _WaveClipper(this.animation);

  @override
  Path getClip(Size size) {
    final path = Path();
    const waveHeight = 90.0;
    const waveCount = 4;

    path.lineTo(0, size.height);
    for (int i = 0; i <= waveCount; i++) {
      final x = i * size.width / waveCount;
      final dx = x + size.width / (waveCount * 4);
      final dy = sin((animation + i) * pi) * waveHeight + size.height - waveHeight;
      path.quadraticBezierTo(x, dy, dx, size.height - waveHeight);
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => true;
}