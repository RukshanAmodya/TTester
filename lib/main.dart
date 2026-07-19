import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'theme.dart';
import 'screens/onboarding_screens.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const TTestersApp(),
    ),
  );
}

class TTestersApp extends StatelessWidget {
  const TTestersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TTesters P2P App testing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    
    if (appState.isLoggedIn) {
      return const MainNavigation();
    } else {
      if (appState.hasSeenOnboarding) {
        return const NumiLoginScreen();
      } else {
        return const OnboardingScreen();
      }
    }
  }
}
