import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'package:test_buat_uts/main.dart';
import 'package:test_buat_uts/screens/sign_up.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _usernameCtl = TextEditingController();
  final _passwordCtl = TextEditingController();

  bool _remember = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkRemember();
  }

  // ================= REMEMBER ME =================
  Future<void> _checkRemember() async {
    final prefs = await SharedPreferences.getInstance();
    final remembered = prefs.getBool('remember') ?? false;

    if (remembered) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    } else {
      setState(() => _loading = false);
    }
  }

  // ================= LOGIN LOGIC =================
  Future<void> _onSignIn() async {
    final inputUsername = _usernameCtl.text.trim();
    final inputPassword = _passwordCtl.text;

    if (inputUsername.isEmpty || inputPassword.isEmpty) {
      _showSnack('Username dan password wajib diisi');
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();

      final encryptedUsername = prefs.getString('encryptedUsername');
      final encryptedPassword = prefs.getString('encryptedPassword');
      final keyBase64 = prefs.getString('enc_key');
      final ivBase64 = prefs.getString('enc_iv');

      // BELUM PERNAH SIGN UP
      if (encryptedUsername == null ||
          encryptedPassword == null ||
          keyBase64 == null ||
          ivBase64 == null) {
        _showSnack('Akun belum terdaftar, silakan daftar terlebih dahulu');
        return;
      }

      // DECRYPT
      final key = encrypt.Key.fromBase64(keyBase64);
      final iv = encrypt.IV.fromBase64(ivBase64);
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc),
      );

      final savedUsername = encrypter.decrypt64(encryptedUsername, iv: iv);
      final savedPassword = encrypter.decrypt64(encryptedPassword, iv: iv);

      // VALIDASI
      if (inputUsername == savedUsername && inputPassword == savedPassword) {
        await prefs.setBool('remember', _remember);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      } else {
        _showSnack('Username atau password salah');
      }
    } catch (e) {
      _showSnack('Terjadi kesalahan saat login');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
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

            // LOGO
            Image.asset(
              'images/logo-skinmart.png',
              width: 260,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 40),

            // CARD
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
                      const SizedBox(height: 35),
                      Text(
                        "Masuk",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          color: Color(0xFF6B966F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 30),

                      _inputLabel("Masukkan Username"),
                      _inputField(
                        controller: _usernameCtl,
                        hint: "Username",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 18),

                      _inputLabel("Masukkan Password"),
                      _inputField(
                        controller: _passwordCtl,
                        hint: "Password",
                        icon: Icons.lock_outline,
                        obscure: true,
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _remember,
                                  onChanged: (v) =>
                                      setState(() => _remember = v!),
                                ),
                                const Text("Ingat Saya"),
                              ],
                            ),
                            const Text(
                              "Lupa Password?",
                              style: TextStyle(color: Color(0xFF6B966F)),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // BUTTON LOGIN
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: ElevatedButton(
                          onPressed: _onSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B966F),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            child: const Text("Daftar"),
                          ),
                        ],
                      ),
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

  // ================= UI HELPER =================
  Widget _inputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
