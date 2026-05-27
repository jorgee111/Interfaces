import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/app_animations.dart';
import '../providers/eco_state.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppTheme.durNorm,
        curve: AppTheme.ease,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, introduce tu nombre de aventurero.',
            style: AppTheme.tSm(Colors.white, FontWeight.w700),
          ),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }

    final state = Provider.of<EcoState>(context, listen: false);
    state.setUserName(name);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textC = isDark ? DarkColors.textDark : LightColors.textDark;
    final textM = isDark ? DarkColors.textMid : LightColors.textMid;
    final bg = isDark ? DarkColors.bgApp : LightColors.bgApp;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            // Top Logo Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp4, vertical: AppTheme.sp2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text('🌱', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 6),
                      Text(
                        'EcoScanner',
                        style: AppTheme.tMd(AppColors.primary, FontWeight.w900),
                      ),
                    ],
                  ),
                  if (_currentPage < 2)
                    TextButton(
                      onPressed: () => _pageController.animateToPage(2, duration: AppTheme.durNorm, curve: AppTheme.ease),
                      child: Text(
                        'Saltar',
                        style: AppTheme.tSm(AppColors.primary, FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),

            // Page Contents
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildWelcomeSlide(textC, textM),
                  _buildFeaturesSlide(textC, textM),
                  _buildRegisterSlide(textC, textM, isDark),
                ],
              ),
            ),

            // Dot Indicators & Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp5, vertical: AppTheme.sp5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(3, (index) {
                      final active = _currentPage == index;
                      return AnimatedContainer(
                        duration: AppTheme.durFast,
                        margin: const EdgeInsets.only(right: 6),
                        width: active ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.chapterLocked.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Button
                  ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shadowColor: AppColors.primaryGlow,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.rMd),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppTheme.sp6, vertical: AppTheme.sp3),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Comenzar' : 'Siguiente',
                      style: AppTheme.tSm(Colors.white, FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSlide(Color textC, Color textM) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingCreature(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Text(
                '🦊',
                style: TextStyle(fontSize: 84),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            '¡Bienvenido a Faunia!',
            style: AppTheme.tXxl(textC, FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'El misterio ecológico ha comenzado. Explora el parque, recicla y descubre criaturas fantásticas que te acompañarán en tu aventura.',
            style: AppTheme.tBase(textM, FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSlide(Color textC, Color textM) {
    final List<Map<String, String>> items = [
      {'icon': '📸', 'title': 'Escanea y Recicla', 'desc': 'Usa tu cámara para escanear contenedores en el parque y gana Eco-Puntos.'},
      {'icon': '🦖', 'title': 'Evoluciona Criaturas', 'desc': 'Alimenta a tus compañeros mágicos con tus acciones sostenibles.'},
      {'icon': '🍿', 'title': 'Gana Premios Reales', 'desc': 'Canjea tus Eco-Puntos por palomitas, bebidas o entradas gratis.'},
    ];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '¿Cómo se juega?',
            style: AppTheme.tXxl(textC, FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          ...items.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppTheme.sp4),
              padding: const EdgeInsets.all(AppTheme.sp4),
              decoration: BoxDecoration(
                color: textC.withOpacity(0.03),
                borderRadius: BorderRadius.circular(AppTheme.rLg),
                border: Border.all(color: textC.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  Text(e['icon']!, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e['title']!,
                          style: AppTheme.tBase(textC, FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          e['desc']!,
                          style: AppTheme.tSm(textM, FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRegisterSlide(Color textC, Color textM, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.sp5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('🎒', style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Text(
            '¿Cuál es tu nombre de Aventurero?',
            style: AppTheme.tXl(textC, FontWeight.w900),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Tu nombre se guardará localmente en este dispositivo y te identificará en los rankings ecológicos del parque.',
            style: AppTheme.tSm(textM, FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Name Input field
          TextField(
            controller: _nameController,
            style: AppTheme.tBase(textC, FontWeight.w800),
            decoration: InputDecoration(
              hintText: 'Ej: EcoGuardián',
              hintStyle: AppTheme.tBase(textM.withOpacity(0.6), FontWeight.w600),
              prefixIcon: Icon(Icons.badge_rounded, color: AppColors.primary.withOpacity(0.8)),
              filled: true,
              fillColor: isDark ? const Color(0xFF1E293B) : Colors.black.withOpacity(0.04),
              contentPadding: const EdgeInsets.all(AppTheme.sp4),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.rMd),
                borderSide: BorderSide(color: textC.withOpacity(0.08)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.rMd),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
