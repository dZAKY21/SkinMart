import 'package:flutter/material.dart';
import 'package:test_buat_uts/data/favorite_dart.dart';
import 'package:test_buat_uts/providers/cart_providers.dart';
import 'package:test_buat_uts/screens/cart_screen.dart';
import 'package:test_buat_uts/screens/favorite_screen.dart';
import 'package:test_buat_uts/screens/home_screen.dart';
import 'package:test_buat_uts/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:test_buat_uts/screens/sign_in.dart';
import 'package:test_buat_uts/screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF9F9F9),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF6B966F)),
          titleTextStyle: TextStyle(
            color: Color(0xFF6B966F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFC7B8EA), // Lavender
          onPrimary: Colors.white,
          secondary: Color(0xFFA4D4FF), // Sky Blue
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF333333),
          error: Color(0xFFFF8A8A), // Soft Coral
          onError: Colors.white,
          background: Color(0xFFF9F9F9),
          onBackground: Color(0xFF333333),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF333333)),
          bodySmall: TextStyle(color: Color(0xFF555555)),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF6B966F), // Cora accent
          unselectedItemColor: Color.fromARGB(255, 195, 196, 196), // Sky blue
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
      ),
      home: const SplashScreen(
        nextScreen: SignInScreen(),
        logoPath: 'images/logo-skinmart.png',
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    const HomeScreen(),
    const CartScreen(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFA4D4FF), Color(0xFFC7B8EA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: const Color(0xFF6B966F),
          unselectedItemColor: Colors.black12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
