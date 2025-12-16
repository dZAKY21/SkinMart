import 'package:flutter/material.dart';
import 'package:test_buat_uts/models/cart_item.dart';
import 'package:test_buat_uts/models/skincare.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  /// READ ONLY
  List<CartItem> get items => List.unmodifiable(_items);

  // =====================================================
  // 🔑 KEY UTAMA PRODUK (WAJIB UNIK)
  // =====================================================
  String _keyFor(Skincare p) {
    // pakai kombinasi brand + name (aman)
    return '${p.brand}__${p.name}'.toLowerCase();
  }

  // =====================================================
  // ➕ ADD TO CART
  // =====================================================
  void addToCart(Skincare product, {int qty = 1}) {
    final key = _keyFor(product);

    final index = _items.indexWhere((e) => _keyFor(e.product) == key);

    if (index != -1) {
      // produk sudah ada → tambah qty
      _items[index].qty += qty;
    } else {
      // produk baru
      _items.add(CartItem(product: product, qty: qty, selected: true));
    }

    notifyListeners();
  }

  // =====================================================
  // ❌ REMOVE ITEM
  // =====================================================
  void removeFromCart(Skincare product) {
    final key = _keyFor(product);
    _items.removeWhere((e) => _keyFor(e.product) == key);
    notifyListeners();
  }

  // =====================================================
  // 🔢 CHANGE QTY
  // =====================================================
  void changeQty(Skincare product, int newQty) {
    final key = _keyFor(product);

    final index = _items.indexWhere((e) => _keyFor(e.product) == key);

    if (index != -1) {
      _items[index].qty = newQty.clamp(1, 999);
      notifyListeners();
    }
  }

  // =====================================================
  // ☑ SELECT ITEM
  // =====================================================
  void toggleItemSelected(Skincare product) {
    final key = _keyFor(product);

    final index = _items.indexWhere((e) => _keyFor(e.product) == key);

    if (index != -1) {
      _items[index].selected = !_items[index].selected;
      notifyListeners();
    }
  }

  // =====================================================
  // ☑ SELECT ALL
  // =====================================================
  void toggleSelectAll(bool value) {
    for (final item in _items) {
      item.selected = value;
    }
    notifyListeners();
  }

  // =====================================================
  // 🏪 GROUP BY SHOP / BRAND
  // =====================================================
  Map<String, List<CartItem>> groupedByShop() {
    final Map<String, List<CartItem>> map = {};
    for (final item in _items) {
      map.putIfAbsent(item.product.brand, () => []);
      map[item.product.brand]!.add(item);
    }
    return map;
  }

  void toggleSelectShop(String shopName, bool value) {
    for (final item in _items) {
      if (item.product.brand == shopName) {
        item.selected = value;
      }
    }
    notifyListeners();
  }

  bool isShopAllSelected(String shopName) {
    final shopItems = _items.where((e) => e.product.brand == shopName).toList();

    if (shopItems.isEmpty) return false;
    return shopItems.every((e) => e.selected);
  }

  bool isAllSelected() {
    if (_items.isEmpty) return false;
    return _items.every((e) => e.selected);
  }

  // =====================================================
  // 💰 PRICE
  // =====================================================
  int parsePriceToInt(String price) {
    final digits = price.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  String formatToRupiah(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    int count = 0;

    for (int i = s.length - 1; i >= 0; i--) {
      buffer.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        buffer.write('.');
        count = 0;
      }
    }

    return 'Rp${buffer.toString().split('').reversed.join()}';
  }

  int totalSelectedPrice() {
    int total = 0;
    for (final item in _items) {
      if (item.selected) {
        total += parsePriceToInt(item.product.price) * item.qty;
      }
    }
    return total;
  }

  int selectedCount() {
    int count = 0;
    for (final item in _items) {
      if (item.selected) count += item.qty;
    }
    return count;
  }

  // =====================================================
  // 🧹 CLEAR CART (FIXED)
  // =====================================================
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // =====================================================
  // 🔍 GET ITEM (NO NULL ERROR)
  // =====================================================
  CartItem? getCartItem(Skincare product) {
    final key = _keyFor(product);

    for (final item in _items) {
      if (_keyFor(item.product) == key) {
        return item;
      }
    }
    return null;
  }
}
