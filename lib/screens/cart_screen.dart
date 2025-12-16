import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_buat_uts/main.dart';
import 'package:test_buat_uts/models/cart_item.dart';
import 'package:test_buat_uts/providers/cart_providers.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  static const Color greenMain = Color(0xFF71A857);

  Future<bool> _onWillPop() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Keranjang Saya'),
          backgroundColor: Colors.white,
          foregroundColor: greenMain,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => _onWillPop(),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ubah',
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromRGBO(245, 245, 247, 1),
        body: Consumer<CartProvider>(
          builder: (context, cart, _) {
            final grouped = cart.groupedByShop();

            return Column(
              children: [
                Expanded(
                  child: grouped.isEmpty
                      ? const Center(child: Text('Keranjang kosong'))
                      : ListView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          children: [
                            for (var entry in grouped.entries) ...[
                              ShopCardMarketplace(
                                shopName: entry.key,
                                items: entry.value,
                                isShopSelected: cart.isShopAllSelected(
                                  entry.key,
                                ),
                                onToggleShop: (v) =>
                                    cart.toggleSelectShop(entry.key, v),
                                onToggleItem: (it) =>
                                    cart.toggleItemSelected(it.product),
                                onQtyChanged: (it, q) =>
                                    cart.changeQty(it.product, q),
                                onRemove: (it) =>
                                    cart.removeFromCart(it.product),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ],
                        ),
                ),

                // ================= BOTTOM BAR =================
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: cart.isAllSelected(),
                        onChanged: (v) => cart.toggleSelectAll(v ?? false),
                        activeColor: greenMain,
                      ),
                      const Text('Semua'),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            cart.formatToRupiah(cart.totalSelectedPrice()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${cart.selectedCount()} item dipilih',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: cart.selectedCount() > 0
                            ? () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Checkout ${cart.selectedCount()} item (total ${cart.formatToRupiah(cart.totalSelectedPrice())})',
                                    ),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenMain,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text('Checkout (${cart.selectedCount()})'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// ================= SHOP CARD =================
class ShopCardMarketplace extends StatelessWidget {
  final String shopName;
  final List<CartItem> items;
  final bool isShopSelected;
  final void Function(bool) onToggleShop;
  final void Function(CartItem) onToggleItem;
  final void Function(CartItem, int) onQtyChanged;
  final void Function(CartItem) onRemove;

  const ShopCardMarketplace({
    super.key,
    required this.shopName,
    required this.items,
    required this.isShopSelected,
    required this.onToggleShop,
    required this.onToggleItem,
    required this.onQtyChanged,
    required this.onRemove,
  });

  static const Color greenMain = Color(0xFF71A857);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: isShopSelected,
                  onChanged: (v) => onToggleShop(v ?? false),
                  activeColor: greenMain,
                ),
                Expanded(
                  child: Text(
                    shopName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('Ubah')),
              ],
            ),
            const Divider(height: 6),
            for (var i = 0; i < items.length; i++) ...[
              _MarketCartRow(
                item: items[i],
                onToggle: () => onToggleItem(items[i]),
                onQtyChanged: (q) => onQtyChanged(items[i], q),
                onRemove: () => onRemove(items[i]),
              ),
              if (i != items.length - 1) const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}

/// ================= CART ROW =================
class _MarketCartRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onToggle;
  final void Function(int) onQtyChanged;
  final VoidCallback onRemove;

  const _MarketCartRow({
    required this.item,
    required this.onToggle,
    required this.onQtyChanged,
    required this.onRemove,
  });

  static const Color greenMain = Color(0xFF71A857);

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: item.selected,
            onChanged: (_) => onToggle(),
            activeColor: greenMain,
          ),

          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade100,
              image: DecorationImage(
                image: AssetImage(item.product.imageAsset),
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  cart.formatToRupiah(cart.parsePriceToInt(item.product.price)),
                  style: const TextStyle(
                    color: greenMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // ===== QTY HORIZONTAL =====
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () async {
                  if (item.qty > 1) {
                    onQtyChanged(item.qty - 1);
                  } else {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus produk?'),
                        content: const Text(
                          'Apakah Anda yakin ingin menghapus produk ini?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      onRemove();
                    }
                  }
                },
                child: _qtyButton(icon: Icons.remove, filled: false),
              ),
              const SizedBox(width: 10),
              Text(
                item.qty.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => onQtyChanged(item.qty + 1),
                child: _qtyButton(icon: Icons.add, filled: true),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, required bool filled}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: filled ? greenMain : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: Colors.grey.shade300),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 18, color: filled ? Colors.white : Colors.black),
    );
  }
}
