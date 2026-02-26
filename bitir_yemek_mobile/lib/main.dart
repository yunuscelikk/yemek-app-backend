import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'core/services/location_service.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/location/presentation/pages/location_permission_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bitir Yemek',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final tokenStorage = SharedPrefsTokenStorage();
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      // Token var, konum izni kontrol et
      final locationService = LocationService();
      final hasPermission = await locationService.hasPermission();

      if (hasPermission) {
        // Konum izni var, home page'e git
        final position = await locationService.getCurrentPosition();
        if (position != null && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            ),
          );
          return;
        }
      }

      // Konum izni yok, location permission page'e git
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LocationPermissionPage(),
          ),
        );
      }
    } else {
      // Token yok, welcome page'e git
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.eco, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            // App Name
            Text(
              'Bitir Yemek',
              style: AppTypography.h2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 48),
            // Loading Indicator
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
