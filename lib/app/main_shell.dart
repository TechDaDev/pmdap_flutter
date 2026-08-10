import 'package:flutter/material.dart';
import 'package:pmdap_mobile/l10n/app_localizations.dart';
import 'package:pmdap_mobile/core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_rounded),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: AppColors.primaryNavy,
            ),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_rounded),
            selectedIcon: Icon(
              Icons.inventory_2_rounded,
              color: AppColors.primaryNavy,
            ),
            label: l10n.archive,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_rounded),
            selectedIcon: Icon(
              Icons.search_rounded,
              color: AppColors.primaryNavy,
            ),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_rounded),
            selectedIcon: Icon(
              Icons.person_rounded,
              color: AppColors.primaryNavy,
            ),
            label: l10n.profile,
          ),
        ],
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
