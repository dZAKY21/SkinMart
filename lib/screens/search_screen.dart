import 'package:flutter/material.dart';
import 'package:test_buat_uts/models/skincare.dart';
// As 'Skincare' is imported, I'll assume 'skincareList' is the name of the static list in your model file.
// If your list is named differently, update 'skincareList' below.
import 'package:test_buat_uts/data/skincare_data.dart'; // <--- Assuming your data is here

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // TODO: 1. Deklarasikan variabel yang dibutuhkan
  // Tambahkan list lengkap dari semua candi
  List<Skincare> final_allSkincares =
      skincareList; // <--- Assuming 'candiList' holds all data
  List<Skincare> _filteredCandis = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Lifecycle method: Dipanggil saat State object pertama kali dibuat
  @override
  void initState() {
    super.initState();
    // Awalnya, tampilkan semua data saat pertama kali dimuat
    _filteredCandis = final_allSkincares;
  }

  // Metode untuk melakukan pencarian
  void _filterCandis(String query) {
    // Panggil setState untuk memperbarui UI
    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        // Jika query kosong, tampilkan semua data
        _filteredCandis = final_allSkincares;
      } else {
        // Jika ada query, lakukan filter (case-insensitive)
        _filteredCandis = final_allSkincares.where((candi) {
          final candiName = candi.name.toLowerCase();
          final input = query.toLowerCase();
          return candiName.contains(input);
        }).toList();
      }
    });
  }

  // Lifecycle method: Dipanggil saat State object dihapus
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // TODO: 2. Buat appbar dengan judul Pencarian Candi
      appBar: AppBar(title: const Text('Pencarian Candi')),
      // TODO: 3. Buat body berupa Column
      body: Column(
        children: [
          // TODO: 4. Buat TextField pencarian sebagai anak dari Column
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.deepPurple[50],
              ),
              child: TextField(
                // <-- Hapus 'const' karena akan ada perubahan pada controller/callback
                controller: _searchController, // <-- Sambungkan controller
                autofocus: false,
                onChanged:
                    _filterCandis, // <-- Panggil fungsi filter saat teks berubah
                decoration: const InputDecoration(
                  hintText: 'Cari candi ...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          // TODO: 5. Buat ListView hasil pencarina sebagai anak dari Column
          Expanded(
            child: _filteredCandis.isEmpty && _searchQuery.isNotEmpty
                ? const Center(
                    child: Text(
                      'Candi tidak ditemukan.',
                    ), // Tampilkan pesan jika hasil kosong
                  )
                : ListView.builder(
                    itemCount: _filteredCandis.length,
                    itemBuilder: (context, index) {
                      final candi = _filteredCandis[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  candi.imageAsset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    candi.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Text(Skincare.location),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
