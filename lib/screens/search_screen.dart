import 'package:flutter/material.dart';
import 'package:test_buat_uts/data/skincare_data.dart';
import 'package:test_buat_uts/models/skincare.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Skincare> searchResults = [];

  void searchSkincare(String query) {
    final results = skincareList.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.brand.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: TextField(
          onChanged: searchSkincare,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari skincare...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchResults.isEmpty
          ? const Center(child: Text("Belum ada hasil pencarian"))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final item = searchResults[index];
                return ListTile(
                  leading: Image.asset(item.imageAsset, width: 50, height: 50),
                  title: Text(item.name),
                  subtitle: Text(item.price),
                );
              },
            ),
    );
  }
}
