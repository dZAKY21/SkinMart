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



  void signOut() {
    setState(() {
      isSignedIn = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Berhasil logout!')),
    );
    Navigator.pushReplacementNamed(context, '/signin');
  }

  // 🔹 Edit Profil (popup dialog)
  void _editProfile() {
    TextEditingController nameCtrl = TextEditingController(text: fullName);
    TextEditingController phoneCtrl = TextEditingController(text: phoneNumber);
    TextEditingController emailCtrl = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                fullName = nameCtrl.text;
                phoneNumber = phoneCtrl.text;
                email = emailCtrl.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profil berhasil diperbarui!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E5BFF),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.88;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E5BFF), Color(0xFF71A1FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Konten utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // Header
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
                        const SizedBox(width: 48),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Card Profil
                  Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
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
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Ganti foto profil belum diimplementasi.')),
                            ),
                            child: CircleAvatar(
                              radius: 48,
                              backgroundColor: const Color(0xFF1E5BFF).withOpacity(0.2),
                              child: const Icon(
                                Icons.account_circle,
                                size: 90,
                                color: Color(0xFF1E5BFF),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(email, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 18),

                          // Tombol Edit Profil
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _editProfile,
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

                          // Informasi Pribadi
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
                          _infoField(icon: Icons.person, label: 'Nama', value: fullName),
                          const SizedBox(height: 10),
                          _infoField(icon: Icons.phone, label: 'No. Telepon', value: phoneNumber),
                          const SizedBox(height: 10),
                          _infoField(icon: Icons.email, label: 'Email', value: email),

                          const SizedBox(height: 30),

                      

                          const SizedBox(height: 28),

                          // Logout
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

  // 🔹 Widget info dengan ikon, label & value
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
              style: const TextStyle(color: Colors.grey, fontSize: 14),
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
