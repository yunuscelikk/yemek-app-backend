import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../pages/home_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNavBar({super.key, required this.currentIndex, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.explore_outlined, 'Keşfet', 0, context),
              _buildNavItem(Icons.search, 'Ara', 1, context),
              _buildNavItem(Icons.inventory_2_outlined, 'Sipariş', 2, context),
              _buildNavItem(Icons.favorite_outline, 'Favoriler', 3, context),
              _buildNavItem(Icons.person_outline, 'Profil', 4, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    int index,
    BuildContext context,
  ) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(index);
        } else {
          _handleNavigation(index, context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textHint,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textHint,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(int index, BuildContext context) {
    // TODO: Get current location from a service
    const latitude = 41.0369;
    const longitude = 28.9857;

    switch (index) {
      case 0:
        // Keşfet - Home
        if (currentIndex != 0) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) =>
                  const HomePage(latitude: latitude, longitude: longitude),
            ),
          );
        }
        break;
      case 1:
        // Ara - Search
        if (currentIndex != 1) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  const SearchPage(latitude: latitude, longitude: longitude),
            ),
          );
        }
        break;
      case 2:
        // Sipariş - Orders
        // TODO: Navigate to orders page
        break;
      case 3:
        // Favoriler - Favorites
        // TODO: Navigate to favorites page
        break;
      case 4:
        // Profil - Profile
        // TODO: Navigate to profile page
        break;
    }
  }
}
