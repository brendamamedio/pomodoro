import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_routes.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavIcon(
            icon: Icons.timer_rounded,
            label: "FOCO",
            active: currentIndex == 0,
            onTap: () => _safeNavigate(context, AppRoutes.focus),
          ),
          _NavIcon(
            icon: Icons.list_alt_rounded,
            label: "TAREFAS",
            active: currentIndex == 1,
            onTap: () => _safeNavigate(context, AppRoutes.tasks),
          ),
          _NavIcon(
            icon: Icons.bar_chart_rounded,
            label: "STATUS",
            active: currentIndex == 2,
            onTap: () => _safeNavigate(context, AppRoutes.statistics),
          ),
          _NavIcon(
            icon: Icons.settings_outlined,
            label: "AJUSTES",
            active: currentIndex == 3,
            onTap: () => _safeNavigate(context, AppRoutes.settings),
          ),
        ],
      ),
    );
  }

  void _safeNavigate(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushReplacementNamed(context, routeName);
    }
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: active ? AppColors.primaryPinkDark : AppColors.textGrey,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Poppins',
              color: active ? AppColors.primaryPinkDark : AppColors.textGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}