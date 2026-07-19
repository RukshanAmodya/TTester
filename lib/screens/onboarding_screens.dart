import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slideContents = [
    {
      "title": "Track Smarter.\nPlan Calmer.",
      "subtitle": "Mutual peer-to-peer Play Store testing network. Share tests and unlock your production releases easily.",
    },
    {
      "title": "Your Full Testing\nProgress, At A Glance",
      "subtitle": "Track your recruited testers daily compliance and watch your testing clock tick down.",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background image with smooth crossfade switcher
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Container(
                key: ValueKey<int>(_currentPage),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_currentPage == 0
                        ? 'assets/images/Onboardscreen1.jpg'
                        : 'assets/images/onboardscreen2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // 2. Soft vignette overlay at the bottom to ensure high white text contrast
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          // 3. Foreground PageView for text sliding only
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 4),
                // Text sliding layer
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: _slideContents.length,
                    itemBuilder: (context, index) {
                      final slide = _slideContents[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slide["title"]!,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.libreBaskerville(
                                textStyle: const TextStyle(
                                  fontSize: 28,
                                  height: 1.25,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              slide["subtitle"]!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slideContents.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                // Bottom Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0F172A),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _slideContents.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NumiLoginScreen()),
                          );
                        }
                      },
                      child: Text(
                        _currentPage == 0 ? "Next" : "Continue",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NumiLoginScreen extends StatefulWidget {
  const NumiLoginScreen({super.key});

  @override
  State<NumiLoginScreen> createState() => _NumiLoginScreenState();
}

class _NumiLoginScreenState extends State<NumiLoginScreen> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginscreen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Underlined nūmi logo
              Column(
                children: [
                  const Text(
                    "nūmi",
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  Container(
                    width: 70,
                    height: 2,
                    color: Colors.white70,
                  ),
                ],
              ),
              const Spacer(flex: 3),
              // Custom tagline styled with Libre Baskerville italic
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  "Test smarter.\nRelease faster.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.libreBaskerville(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Sign-up/Sign-in button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0F172A),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          if (!_agreedToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please agree to the Terms & Privacy Policy first"),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                            return;
                          }
                          appState.loginWithGoogle();
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Social Sign-in Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(
                          icon: Icons.g_mobiledata_rounded,
                          onTap: () {
                            if (!_agreedToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please agree to the Terms & Privacy Policy first"),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              return;
                            }
                            appState.loginWithGoogle();
                          },
                        ),
                        const SizedBox(width: 20),
                        _buildSocialIcon(
                          icon: Icons.apple,
                          onTap: () {
                            if (!_agreedToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please agree to the Terms & Privacy Policy first"),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              return;
                            }
                            appState.loginWithGoogle();
                          },
                        ),
                        const SizedBox(width: 20),
                        _buildSocialIcon(
                          icon: Icons.mail_outline_rounded,
                          onTap: () {
                            if (!_agreedToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please agree to the Terms & Privacy Policy first"),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              return;
                            }
                            appState.loginWithGoogle();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              // Rules & checkboxes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white70,
                          ),
                          child: Checkbox(
                            value: _agreedToTerms,
                            onChanged: (val) {
                              setState(() {
                                _agreedToTerms = val ?? false;
                              });
                            },
                            activeColor: Colors.white,
                            checkColor: const Color(0xFF0F172A),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            "I agree to the Terms of Service & Privacy Policy",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "By using Numi you agree to Numi's\nPrivacy Policy & Terms of Service",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
