import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_buat_uts/data/favorite_dart.dart';
import 'package:test_buat_uts/providers/cart_providers.dart';
import 'package:test_buat_uts/screens/cart_screen.dart';
import 'package:test_buat_uts/screens/home_screen.dart';

// 🎨 WARNA
const Color kGreen = Color(0xFF6B966F);
const Color kBackground = Color(0xFFF8F8FB);

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteProvider>().favorites;

    return WillPopScope(
      //  BACK ANDROID → HOME
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: kBackground,
        body: SafeArea(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    //  BACK → HOME
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: kGreen),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      },
                    ),

                    const Expanded(
                      child: Text(
                        'Favorite Saya',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: kGreen,
                        ),
                      ),
                    ),

                    // ================= CART ICON + BADGE =================
                    Consumer<CartProvider>(
                      builder: (context, cart, _) {
                        final count = cart.items.length;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: kGreen,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const CartScreen(),
                                  ),
                                );
                              },
                            ),
                            if (count > 0)
                              Positioned(
                                top: 6,
                                right: 6,
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

              // ================= CONTENT =================
              Expanded(
                child: favorites.isEmpty
                    ? const Center(
                        child: Text(
                          'Belum ada item favorit',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: favorites.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 14,
                              crossAxisSpacing: 14,
                              childAspectRatio: 0.72,
                            ),
                        itemBuilder: (context, index) {
                          final item = favorites[index];
                          return _FavoriteCard(item: item);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= CARD FAVORITE =================
class _FavoriteCard extends StatelessWidget {
  final dynamic item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          //  IMAGE
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    item.imageAsset,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // FAVORITE ICON
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      context.read<FavoriteProvider>().toggleFavorite(item);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 📄 INFO
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 12),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    item.price,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kGreen,
                      fontWeight: FontWeight.bold,
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
