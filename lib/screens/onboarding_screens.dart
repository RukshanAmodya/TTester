import 'package:flutter/material.dart';
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

  final List<Map<String, String>> _slides = [
    {
      "title": "Welcome to TTesters",
      "subtitle": "Indie developer community helping each other pass the Play Store 14-day closed testing rule.",
      "image": "🚀",
    },
    {
      "title": "Mutual App Testing",
      "subtitle": "Test apps from peers to earn coins, and spend coins to get 12 testers for your own apps.",
      "image": "🪙",
    },
    {
      "title": "Anti-Cheat Protection",
      "subtitle": "Automated background package checks ensure testers remain engaged, keeping your metrics clean.",
      "image": "🛡️",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  _pageController.jumpToPage(_slides.length);
                },
                child: const Text(
                  "Skip",
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: _slides.length + 1, // +1 for the Sign-In page
                itemBuilder: (context, index) {
                  if (index == _slides.length) {
                    return const LoginScreen();
                  }

                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                spreadRadius: 5,
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            slide["image"]!,
                            style: const TextStyle(fontSize: 80),
                          ),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          slide["title"]!,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide["subtitle"]!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_currentPage < _slides.length) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length + 1,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text("Next"),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.appBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Header with orange peach gradient
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.orangeGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Let's Get Testing",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(height: 8),
              const Text(
                "P2P Network for Google Play 14-Day closed testing requirements.",
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textLight, fontSize: 14),
              ),
              const SizedBox(height: 64),
              // Terms & Privacy Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (val) {
                      setState(() {
                        _agreeToTerms = val ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  const Expanded(
                    child: Text(
                      "I agree to the Terms of Service & Privacy Policy",
                      style: TextStyle(fontSize: 12, color: AppColors.textDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Google Login Button
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (!_agreeToTerms) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please agree to the Terms and Conditions first"),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                      return;
                    }
                    appState.loginWithGoogle();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                          height: 24,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.g_mobiledata_rounded,
                            size: 32,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "Sign In with Google",
                          style: TextStyle(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
