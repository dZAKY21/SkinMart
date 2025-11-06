import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSignedIn = true;

  // Data profil (dummy)
  String fullName = 'M. Salmans';
  String phoneNumber = '0899999999';
  String email = 'muham09@gmail.com';

  // Data favorit (dummy)
  final List<Map<String, dynamic>> favorites = [
    {'icon': Icons.favorite, 'title': 'Tempat Favorit'},
    {'icon': Icons.star, 'title': 'Produk Favorit'},
    {'icon': Icons.history, 'title': 'Riwayat Aktivitas'},
  ];

  void signOut() {
    setState(() {
      isSignedIn = false;
    });
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.88;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E5BFF), Color(0xFF71A1FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 🔹 Konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // 🔹 Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'PROFILE',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // agar teks tetap center
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🔹 Card Profil
                  Center(
                    child: Container(
                      width: cardWidth.clamp(320.0, 430.0),
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: const Color(0xFF1E5BFF).withOpacity(0.2),
                            child: const Icon(
                              Icons.account_circle,
                              size: 90,
                              color: Color(0xFF1E5BFF),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Nama lengkap
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            email,
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 18),

                          // Tombol Edit Profil
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.edit, color: Color(0xFF1E5BFF)),
                              label: const Text(
                                'Edit Profil',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1E5BFF),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF1E5BFF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 26),

                          // 🔹 Informasi Pribadi
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Informasi Pribadi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _infoField(
                              icon: Icons.person,
                              label: 'Nama',
                              value: fullName),
                          const SizedBox(height: 10),
                          _infoField(
                              icon: Icons.phone,
                              label: 'No. Telepon',
                              value: phoneNumber),
                          const SizedBox(height: 10),
                          _infoField(
                              icon: Icons.email,
                              label: 'Email',
                              value: email),

                          const SizedBox(height: 30),

                          // 🔹 Bagian Favorit
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Favorit Saya',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),

                          Column(
                            children: favorites.map((fav) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F6FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(fav['icon'],
                                        color: const Color(0xFF1E5BFF)),
                                    const SizedBox(width: 10),
                                    Text(
                                      fav['title'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(Icons.arrow_forward_ios,
                                        size: 16, color: Colors.grey),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 28),

                          // Tombol Logout
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: signOut,
                              icon: const Icon(Icons.logout, color: Colors.white),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E5BFF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Widget info dengan ikon, label & value
  Widget _infoField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1E5BFF), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
