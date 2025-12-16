import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_buat_uts/data/favorite_dart.dart';
import 'package:test_buat_uts/models/skincare.dart';
import 'package:test_buat_uts/providers/cart_providers.dart';
import 'package:test_buat_uts/screens/cart_screen.dart';
import 'package:test_buat_uts/screens/home_screen.dart';

class DetailScreen extends StatefulWidget {
  // Data produk skincare yang akan ditampilkan di detail
  final Skincare skincare;

  const DetailScreen({super.key, required this.skincare});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Menyimpan jumlah (qty) yang akan ditambahkan ke keranjang
  int qty = 1;

  // Tombol plus dan minus untuk mengubah qty
  void _inc() => setState(() => qty++);
  void _dec() {
    if (qty > 1) setState(() => qty--);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

    // Halaman detail produk lengkap dengan bottom bar dan konten
    return Scaffold(
      backgroundColor: Colors.white,

      // ================= BOTTOM FIXED BAR =================
      // Bar bawah: kontrol qty dan tombol "Add To Cart"
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              // Kontrol jumlah produk (– qty +)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _qtyBtn(Icons.remove, _dec),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '$qty',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    _qtyBtn(Icons.add, _inc, green: true),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Tombol untuk menambahkan produk ke keranjang
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Memanggil CartProvider untuk menambah produk ke keranjang
                      context.read<CartProvider>().addToCart(
                        widget.skincare,
                        qty: qty,
                      );

                      // Menampilkan notifikasi SnackBar setelah berhasil ditambahkan
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Added $qty item(s) to cart'),
                          backgroundColor: const Color(0xFF6D8F5F),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D8F5F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Add To Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= BODY =================
      body: Stack(
        children: [
          // Background gradasi hijau lembut di bagian atas
          Container(
            height: h * 0.55,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Color(0xFFE8F4E8), Color(0xFFC8E6C8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ================= HEADER ICONS =================
          // Bar atas: tombol back dan ikon keranjang dengan badge
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol kembali ke halaman sebelumnya
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF6D8F5F),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  // Ikon keranjang yang menampilkan jumlah item (badge)
                  Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final itemCount = cart.items.length;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: kGreen,
                              ),
                              onPressed: () {
                                // Navigasi ke halaman CartScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CartScreen(),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Badge merah jika ada item di keranjang
                          if (itemCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                child: Center(
                                  child: Text(
                                    itemCount > 9 ? '9+' : '$itemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Gambar produk dengan animasi Hero dari halaman sebelumnya
          Positioned(
            top: h * 0.1,
            left: 0,
            right: 0,
            child: Hero(
              tag: widget.skincare.name,
              child: Image.asset(
                widget.skincare.imageAsset,
                height: h * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Kartu detail di bagian bawah (nama, favorit, deskripsi)
          Positioned(
            top: h * 0.38,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk dan ikon favorite
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.skincare.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D2D2D),
                            ),
                          ),
                        ),
                        Consumer<FavoriteProvider>(
                          builder: (context, fav, _) {
                            final isFav = fav.isFavorite(widget.skincare);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey[400],
                                size: 28,
                              ),
                              // Klik icon hati → tambah / hapus dari daftar favorit
                              onPressed: () =>
                                  fav.toggleFavorite(widget.skincare),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Deskripsi produk
                    Text(
                      widget.skincare.description,
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.7,
                        color: Colors.grey[700],
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tombol kecil untuk kontrol qty (plus/minus)
  Widget _qtyBtn(IconData icon, VoidCallback onTap, {bool green = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: green ? const Color(0xFF8FBC8F) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: green ? Colors.white : Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }
}
