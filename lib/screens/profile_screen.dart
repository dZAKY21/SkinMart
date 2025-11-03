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

  void signIn() {
    Navigator.pushNamed(context, '/signin');
  }

  void signOut() {
    setState(() {
      isSignedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.84;

    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Background image
          SizedBox.expand(
            child: Image.asset('images/latar belakang.png', fit: BoxFit.cover),
          ),

          // 🔹 Overlay lembut agar teks tetap jelas
          Container(color: Colors.white.withOpacity(0.03)),

          SafeArea(
            child: Column(
              children: [
                // 🔹 Bagian atas: tombol kembali dan judul PROFILE
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 50),

                      const Expanded(
                        child: Center(
                          child: Text(
                            'PROFILE',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // agar teks tetap center
                    ],
                  ),
                ),

                // 🔹 Tambah jarak vertikal supaya teks dan card lebih ke bawah
                const SizedBox(height: 100),

                // 🔹 Card Profil
                Center(
                  child: Container(
                    width: cardWidth.clamp(300.0, 420.0),
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 26),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar placeholder
                        const CircleAvatar(
                          radius: 46,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.account_circle,
                            size: 86,
                            color: Colors.black54,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Judul kecil "Informasi Pribadi"
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'informasi Pribadi',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Field Name
                        _infoField(label: 'name', value: 'M. Salmans'),
                        const SizedBox(height: 12),

                        // Field no-telp
                        _infoField(label: 'no-telp', value: '0899999999'),
                        const SizedBox(height: 12),

                        // Field email
                        _infoField(label: 'email', value: 'muham09@gmail.com'),

                        const SizedBox(height: 28),

                        // Tombol Logout (tetap full width)
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
                              backgroundColor: Color(0xFF1E5BFF),
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

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Widget untuk field info dengan label & underline
  Widget _infoField({required String label, required String value}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toLowerCase(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Flexible(
              flex: 0,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 100, maxWidth: 180),
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Divider(thickness: 1, height: 1, color: Color(0xFFBDBDBD)),
      ],
    );
  }
}
