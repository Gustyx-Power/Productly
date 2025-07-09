import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final success = await AuthService.login(
      _emailCtrl.text.trim(),
      _passCtrl.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      setState(() {
        _error = "Email atau password salah";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selamat Datang 👋",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.brightness == Brightness.dark ? Colors.white : null,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Masuk ke akun kamu untuk lanjut",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.brightness == Brightness.dark ? Colors.white70 : null,
                  ),
                ),
                const SizedBox(height: 32),

                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: TextStyle(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark ? Colors.white : null,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) => val == null || !val.contains('@')
                      ? "Email tidak valid"
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passCtrl,
                  obscureText: true,
                  style: TextStyle(
                    color: theme.brightness == Brightness.dark ? Colors.white : null,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Kata Sandi",
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  val != null && val.length < 6 ? "Minimal 6 karakter" : null,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _login,
                    icon: const Icon(Icons.login),
                    label: _isLoading ?
                         SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.brightness == Brightness.dark ? Colors.black : Colors.white,
                              ),
                            ),
                          )
                        : const Text("Masuk"),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Belum punya akun? Daftar"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}