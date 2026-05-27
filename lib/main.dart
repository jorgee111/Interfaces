import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'providers/eco_state.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/creatures_screen.dart';
import 'screens/marketplace_screen.dart';
import 'screens/daily_mission_screen.dart';
import 'screens/patrol_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/trivia_screen.dart';
import 'widgets/bottom_nav.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => EcoState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);

    return MaterialApp(
      title: 'EcoScanner Adventures',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const AppShellGate(),
    );
  }
}

class AppShellGate extends StatelessWidget {
  const AppShellGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<EcoState>(context);

    // Show loading spinner while loading stored SharedPreferences state
    if (!state.isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Force user registration/onboarding gate
    if (!state.hasUser()) {
      return const OnboardingScreen();
    }

    return const MainAppShell();
  }
}

class MainAppShell extends StatefulWidget {
  const MainAppShell({super.key});

  @override
  State<MainAppShell> createState() => _MainAppShellState();
}

class _MainAppShellState extends State<MainAppShell> {
  int _currentIndex = 0;
  bool _isPlayingTrivia = false;

  void _onPageChange(int index) {
    setState(() {
      _currentIndex = index;
      _isPlayingTrivia = false;
    });
  }

  void _onScanComplete() {
    setState(() {
      _currentIndex = 0; // Return to Home dashboard after scan completes
    });
  }

  @override
  Widget build(BuildContext context) {
    // If playing Trivia, hide the standard bottom navigation bar for complete focus
    if (_isPlayingTrivia) {
      return TriviaScreen(
        onBackToHome: () {
          setState(() {
            _isPlayingTrivia = false;
          });
        },
      );
    }

    final List<Widget> screens = [
      HomeScreen(
        onNavigate: _onPageChange,
        onPlayTrivia: () {
          setState(() {
            _isPlayingTrivia = true;
          });
        },
      ),
      const MapScreen(),
      const CreaturesScreen(),
      ScannerScreen(
        onScanComplete: _onScanComplete,
      ),
      const MarketplaceScreen(),
      const PatrolScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onPageChange,
      ),
    );
  }
}
