import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final navBg = isDark ? const Color(0xFF131D30) : Colors.white;

    final List<Map<String, dynamic>> items = [
      {'icon': Icons.home_rounded, 'label': 'Inicio'},
      {'icon': Icons.map_rounded, 'label': 'Mapa'},
      {'icon': Icons.pets_rounded, 'label': 'Criaturas'},
      {'icon': Icons.qr_code_scanner_rounded, 'label': 'Escáner', 'special': true},
      {'icon': Icons.shopping_bag_rounded, 'label': 'Premios'},
      {'icon': Icons.group_rounded, 'label': 'Patrulla'},
      {'icon': Icons.person_rounded, 'label': 'Perfil'},
    ];

    return Container(
      height: AppTheme.navH,
      decoration: BoxDecoration(
        color: navBg.withOpacity(0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.rXl),
          topRight: Radius.circular(AppTheme.rXl),
        ),
        boxShadow: AppShadows.md,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = currentIndex == index;
          final isSpecial = item['special'] == true;

          if (isSpecial) {
            return GestureDetector(
              onTap: () => onTap(index),
              child: Transform.translate(
                offset: const Offset(0, -12),
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: AppShadows.primary,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            );
          }

          return InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(AppTheme.rMd),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: AppTheme.durFast,
                    curve: AppTheme.ease,
                    transform: isSelected ? Matrix4.translationValues(0, -2, 0) : Matrix4.identity(),
                    child: Icon(
                      item['icon'],
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? DarkColors.textMuted : LightColors.textMuted),
                      size: isSelected ? 26 : 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['label'],
                    style: AppTheme.tXs(
                      isSelected
                          ? AppColors.primary
                          : (isDark ? DarkColors.textMuted : LightColors.textMuted),
                      isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
