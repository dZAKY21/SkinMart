import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:test_buat_uts/data/favorite_dart.dart';
import 'package:test_buat_uts/data/skincare_data.dart';
import 'package:test_buat_uts/models/skincare.dart';
import 'package:test_buat_uts/providers/cart_providers.dart';
import 'package:test_buat_uts/screens/cart_screen.dart';
import 'package:test_buat_uts/screens/search_screen.dart';
import 'package:test_buat_uts/screens/detail_screen.dart';

//  Konstanta warna tema aplikasi
const Color kBackground = Color(0xFFF8F8FB);
const Color kLavender = Color(0xFFC7B8EA);
const Color kSkyBlue = Color(0xFFA4D4FF);
const Color kGreen = Color(0xFF6B966F);

//  Daftar gambar banner untuk slider home
final List<String> bannerImages = ['images/anua_banner.png', 'images/g2g.jpeg'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk search (kalau nanti mau dipakai) dan banner slider
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();

  // Menyimpan index banner aktif & timer auto slide
  int _currentBanner = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoSlide(); // Mulai auto slide banner tiap 3 detik
  }

  // Mengatur perpindahan otomatis banner promo
  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_bannerController.hasClients) return;
      _currentBanner = (_currentBanner + 1) % bannerImages.length;
      _bannerController.animateToPage(
        _currentBanner,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    // Bersihkan resource ketika HomeScreen ditutup
    _timer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan utama Home: header, banner, dan grid produk
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ================= HEADER =================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Avatar profil sederhana
                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: kGreen,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),

                    // Field search dummy: ketika di-tap pindah ke SearchScreen
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SearchScreen(),
                            ),
                          );
                        },
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: kLavender),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.search, color: kGreen),
                              SizedBox(width: 10),
                              Text(
                                'Search...',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Ikon keranjang dengan badge jumlah item dari CartProvider
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        final count = cart.items.length;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: kLavender),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: kGreen,
                                ),
                                onPressed: () {
                                  // Navigasi ke halaman keranjang
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CartScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Badge merah di pojok kanan atas jika ada item
                            if (count > 0)
                              Positioned(
                                top: -4,
                                right: -4,
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
                                      count > 9 ? '9+' : '$count',
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

            // ================= BANNER =================
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Slider banner promo skincare
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _bannerController,
                      itemCount: bannerImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 8),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              bannerImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),

            // ================= TITLE =================
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Text(
                  'New Arrivals', // Judul section produk baru
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // ================= GRID PRODUK =================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                // Membuat kartu produk dari daftar skincareList
                delegate: SliverChildBuilderDelegate((context, index) {
                  final skincare = skincareList[index];

                  return GestureDetector(
                    // Klik kartu produk → buka DetailScreen dengan data skincare
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(skincare: skincare),
                        ),
                      );
                    },
                    child: ItemCard(skincare: skincare),
                  );
                }, childCount: skincareList.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ITEM CARD =================
// Kartu tampilan satu produk di grid Home
class ItemCard extends StatelessWidget {
  final Skincare skincare;

  const ItemCard({super.key, required this.skincare});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLavender.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: kLavender.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian gambar produk + tombol favorite
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(skincare.imageAsset, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoriteProvider>(
                    builder: (context, favProvider, _) {
                      final isFav = favProvider.isFavorite(skincare);
                      return GestureDetector(
                        // Klik icon hati → tambah / hapus dari daftar favorit
                        onTap: () {
                          favProvider.toggleFavorite(skincare);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Bagian nama dan harga produk
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    skincare.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    skincare.price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: kGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
