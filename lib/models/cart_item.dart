import 'package:test_buat_uts/models/skincare.dart';

class CartItem {
  final Skincare product;

  /// jumlah item
  int qty;

  /// apakah dipilih (checkbox)
  bool selected;

  CartItem({required this.product, this.qty = 1, this.selected = true});
}
