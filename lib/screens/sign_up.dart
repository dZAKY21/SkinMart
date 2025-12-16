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
  final _nameCtl = TextEditingController();
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();
  final _confirmCtl = TextEditingController();

  bool _saving = false;

  // Fungsi util: generate encrypter, key, iv
  encrypt.Encrypter _makeEncrypter(encrypt.Key key) {
    return encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  }

  Future<void> _signUp() async {
    final name = _nameCtl.text.trim();
    final username = _usernameCtl.text.trim();
    final password = _passwordCtl.text;
    final confirm = _confirmCtl.text;

    if (name.isEmpty ||
        username.isEmpty ||
        password.isEmpty ||
        confirm.isEmpty) {
      _showSnack('Semua field harus diisi');
      return;
    }

    if (password != confirm) {
      _showSnack('Password dan konfirmasi tidak sama');
      return;
    }

    setState(() => _saving = true);

    try {
      // generate random key + iv (32 bytes key untuk AES-256, 16 bytes iv)
      final key = encrypt.Key.fromSecureRandom(32);
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypter = _makeEncrypter(key);

      // encrypt dan ambil .base64 sesuai petunjuk PDF
      final encryptedName = encrypter.encrypt(name, iv: iv).base64;
      final encryptedUsername = encrypter.encrypt(username, iv: iv).base64;
      final encryptedPassword = encrypter.encrypt(password, iv: iv).base64;

      final prefs = await SharedPreferences.getInstance();
      // simpan encrypted strings dan key/iv (key & iv base64)
      await prefs.setString('encryptedName', encryptedName);
      await prefs.setString('encryptedUsername', encryptedUsername);
      await prefs.setString('encryptedPassword', encryptedPassword);
      await prefs.setString('enc_key', key.base64);
      await prefs.setString('enc_iv', iv.base64);

      // jangan otomatis set isSignedIn di sign up; biarkan user login via sign in
      await prefs.setBool('isSignedIn', false);

      _showSnack('Pendaftaran berhasil. Silakan kembali ke halaman Masuk.');
      // kembali ke halaman sebelumnya (Sign In)
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      _showSnack('Gagal menyimpan data: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _usernameCtl.dispose();
    _passwordCtl.dispose();
    _confirmCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // tidak ada AppBar — desain full screen seperti sign in
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
            // header logo (ganti Image.asset bila Anda pakai logo)
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

            // Card putih full-height, tanpa padding (isi tetap pakai margin internal)
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

                      // Full Name
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

                      // Username
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

                      // Password
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

                      // Confirm Password
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

                      // Tombol Daftar
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
                      // link back to sign in
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
