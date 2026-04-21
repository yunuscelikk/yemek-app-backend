import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'config/constants.dart';
import 'config/theme.dart';
import 'core/services/location_service.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/presentation/pages/welcome_page.dart';
import 'features/business_owner/presentation/pages/business_owner_scaffold.dart';
import 'features/location/presentation/pages/location_permission_page.dart';
import 'features/main/presentation/pages/main_scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');

  // Initialize Mapbox SDK with access token (only if provided)
  if (AppConstants.mapboxAccessToken.isNotEmpty) {
    MapboxOptions.setAccessToken(AppConstants.mapboxAccessToken);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitirGitsin',
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
    final tokenStorage = createDefaultTokenStorage();
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      final role = await tokenStorage.getUserRole();
      final isBusinessOwner = role == 'business_owner';

      // Token exists — check location permission
      final locationService = LocationService();
      final hasPermission = await locationService.hasPermission();

      if (hasPermission) {
        if (isBusinessOwner) {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const BusinessOwnerScaffold(),
              ),
            );
          }
          return;
        }

        final position = await locationService.getCurrentPosition();
        if (position != null && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainScaffold(
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            ),
          );
          return;
        }
      }

      // No location permission yet
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                LocationPermissionPage(isBusinessOwner: isBusinessOwner),
          ),
        );
      }
    } else {
      // No token — show welcome page
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
              'BitirGitsin',
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
