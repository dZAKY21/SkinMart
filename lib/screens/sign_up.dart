// lib/screens/sign_up_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controller untuk input form
  final _nameCtl = TextEditingController();
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  // Menandai apakah proses simpan / daftar sedang berjalan
  bool _saving = false;

  // Fungsi util: membuat objek Encrypter AES-CBC dari key
  encrypt.Encrypter _makeEncrypter(encrypt.Key key) {
    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  // Proses ketika tombol "Daftar" ditekan
  Future<void> _signUp() async {
    final name = _nameCtl.text.trim();
    final username = _usernameCtl.text.trim();
    final password = _passwordCtl.text;
    final confirm = _confirmCtl.text;

    // Validasi: semua field wajib diisi
    if (name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showSnack('Semua field harus diisi');
      return;
    }

    // Validasi: password dan konfirmasi harus sama
    if (password != confirm) {
      _showSnack('Password dan konfirmasi tidak sama');
      return;
    }

    setState(() => _saving = true);

    try {
      // Generate key dan iv acak (AES-256 → key 32 byte, iv 16 byte)
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = _makeEncrypter(key);

      // Enkripsi data nama, username, password → simpan sebagai base64
      final encryptedName = encrypter.encrypt(name, iv: iv).base64;
      final encryptedUsername = encrypter.encrypt(username, iv: iv).base64;
      final encryptedPassword = encrypter.encrypt(password, iv: iv).base64;

      final prefs = await SharedPreferences.getInstance();
      // Simpan data terenkripsi dan key/iv (dalam bentuk base64)
      await prefs.setString('encryptedName', encryptedName);
      await prefs.setString('encryptedUsername', encryptedUsername);
      await prefs.setString('encryptedPassword', encryptedPassword);
      await prefs.setString('enc_key', key.base64);
      await prefs.setString('enc_iv', iv.base64);

      // Flag isSignedIn tetap false, user harus login dari halaman Sign In
      await prefs.setBool('isSignedIn', false);

      _showSnack('Pendaftaran berhasil. Silakan kembali ke halaman Masuk.');
      // Kembali ke halaman sebelumnya (Sign In)
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showSnack('Gagal menyimpan data: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  // Menampilkan SnackBar pesan singkat
  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dibuang
    _nameCtl.dispose();
    _usernameCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Desain fullscreen dengan background gradasi seperti Sign In
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDFEEDD), Color(0xFFB0D7B1), Color(0xFF8BBF90)],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            // Logo aplikasi di bagian atas
            Column(
              children: [
                Image.asset(
                  'images/logo-skinmart.png',
                  width: 329,
                  height: 263,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Card putih berisi form pendaftaran
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Text(
                        "Daftar",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Color(0xFF6B966F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Input Nama Lengkap
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Nama Lengkap",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _nameCtl,
                          decoration: InputDecoration(
                            hintText: "Nama Lengkap",
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Input Username
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Username",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _usernameCtl,
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Input Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Password",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _passwordCtl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Input Konfirmasi Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Konfirmasi Password",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          controller: _confirmCtl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Konfirmasi Password",
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tombol Daftar: menampilkan loading saat _saving = true
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: _saving ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B966F),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Daftar',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Link kembali ke halaman Masuk
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Sudah punya akun? '),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Masuk'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
