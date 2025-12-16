import 'package:flutter/material.dart';
import 'package:test_buat_uts/data/skincare_data.dart';
import 'package:test_buat_uts/models/skincare.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Skincare> searchResults = []; // searchResults dipakai untuk menampung hasil pencarian yang akan ditampilkan di UI.


// Filters skincareList by query and updates search results 
  void searchSkincare(String query) {     // Mengupdate hasil pencarian skincare sesuai kata kunci yang diketik user.
    final results = skincareList.where((item) {
      return item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.brand.toLowerCase().contains(query.toLowerCase()) ||    //produk masuk hasil pencarian kalau nama, brand, atau kategori mengandung teks yang diketik user 
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
        title: TextField(     //Search input field
          onChanged: searchSkincare,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Cari skincare...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: searchResults.isEmpty       // Menampilkan pesan kosong atau daftar hasil pencarian skincare
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
