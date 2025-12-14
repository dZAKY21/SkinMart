import 'package:flutter/material.dart';
import 'package:test_buat_uts/models/skincare.dart';

class FavoriteProvider with ChangeNotifier {
  final List<Skincare> _favorites = [];

  List<Skincare> get favorites => _favorites;

  bool isFavorite(Skincare item) {
    return _favorites.any((fav) => fav.name == item.name);
  }

  void toggleFavorite(Skincare item) {
    if (isFavorite(item)) {
      _favorites.removeWhere((fav) => fav.name == item.name);
    } else {
      _favorites.add(item);
    }
    notifyListeners();
  }
}
