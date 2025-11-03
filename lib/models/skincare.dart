class Skincare {
  String name;
  String brand;
  String origin;
  String price;
  String description;
  String releaseYear;
  String category;
  String imageAsset;
  List<String> imageUrls;
  bool isFavorite;

  Skincare({
    required this.name,
    required this.brand,
    required this.price,
    required this.origin,
    required this.description,
    required this.releaseYear,
    required this.category,
    required this.imageAsset,
    required this.imageUrls,
    this.isFavorite = false,
  });
}
