import 'package:flutter/material.dart';
import 'package:test_buat_uts/models/skincare.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Skincare> _favorites = [];

  List<Skincare> get favorites => _favorites;

  void toggleFavorite(Skincare item) {
    item.isFavorite = !item.isFavorite;

    if (item.isFavorite) {
      _favorites.add(item);
    } else {
      _favorites.remove(item);
    }

    notifyListeners();
  }

  bool isFavorite(Skincare item) => item.isFavorite;
}
