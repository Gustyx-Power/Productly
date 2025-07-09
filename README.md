# 🛍️ Productly - Aplikasi E-Commerce Flutter

**Productly** adalah aplikasi mobile e-commerce berbasis Flutter yang modern, indah, dan responsif, dibangun dengan arsitektur bersih dan UI yang ekspresif. Aplikasi ini memungkinkan pengguna untuk menjelajahi produk, menambahkannya ke keranjang, dan mensimulasikan proses checkout dengan alur pembayaran yang realistis.

---

## 📱 Fitur

- 🔐 Autentikasi Firebase (Email & Google Sign-In)
- 🛒 Manajemen Keranjang menggunakan Penyimpanan Lokal Hive
- 🧾 Pengambilan Produk Dinamis dari REST API
- 💳 Alur Checkout dengan Gerbang Pembayaran Dummy (GoPay, DANA, Blu BCA, ShopeePay, dll.)
- 🎉 Layar Keberhasilan Pembayaran Animasi (dengan Confetti, Lottie, dan Suara)
- 📦 Alur Pengguna Tamu & Terdaftar
- 💡 Desain Material 3 (Mode Terang)

---

## 🧭 Alur Aplikasi

1. **Layar Splash** – memeriksa sesi dan mengarahkan ke beranda atau login.
2. **Autentikasi** – daftar atau login melalui Firebase.
3. **Penjelajahan Produk** – pengguna dapat menjelajahi berbagai produk dalam daftar yang dapat digulir.
4. **Detail Produk** – menampilkan gambar produk, harga, deskripsi, dan opsi tambah ke keranjang.
5. **Layar Keranjang** – mengelola item keranjang dengan penyesuaian jumlah dan fungsionalitas hapus.
6. **Checkout** – mensimulasikan pembayaran dengan metode yang dapat dipilih dan verifikasi saldo.
7. **Pembayaran Berhasil** – layar konfirmasi animasi dengan suara dan confetti.

---

## 📦 Teknologi yang Digunakan

- ✅ Flutter 3+
- ✅ Dart
- ✅ Hive (Penyimpanan Lokal)
- ✅ Firebase Auth
- ✅ Integrasi REST API (escuelajs.io)
- ✅ Paket Confetti, Lottie, audioplayers
- ✅ Desain Ekspresif Material 3

## 📂 Struktur Proyek

lib/
│
├── models/             # Data models (User, Product, CartItem)
├── services/           # Business logic and storage handlers
├── screens/            # UI Screens (Login, Home, Cart, Detail, etc.)
├── widgets/            # Reusable UI components
├── theme/              # Light theme configuration (Material 3)
├── utils/              # Constants and helpers
└── main.dart           # App entry point


---

## ❤️ Author
Gusti Aditya Muzaky