import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:quizzybea_in/core/app_routes.dart';
import 'package:quizzybea_in/theme/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _IntroData(
      lottiePath: 'Assets/lottie/page_1.json',
      title: 'Fun begins with learning!',
      subtitle:
          'Welcome to QuizzyBea – where play and education meet for little champions.',
    ),
    _IntroData(
      lottiePath: 'Assets/lottie/page2.1.json',
      title: "Boost your knowledge daily",
      subtitle:
          'Hundreds of curated questions to sharpen your mind, one quiz at a time.',
    ),
    _IntroData(
      lottiePath: 'Assets/lottie/page_3.json',
      title: 'Track your progress',
      subtitle:
          'See how far you have come – review your quiz history and beat your high scores.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      context.go(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: SafeArea(
        child: Column(
          children: [
            // Skip
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          page.lottiePath,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 32),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Dots
            SmoothPageIndicator(
              controller: _pageController,
              count: _pages.length,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotColor: AppColors.divider,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 10,
                expansionFactor: 4,
              ),
            ),
            const SizedBox(height: 40),
            // CTA button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ElevatedButton(
                onPressed: _next,
                child: Text(
                  _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Continue',
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _IntroData {
  final String lottiePath;
  final String title;
  final String subtitle;
  const _IntroData({
    required this.lottiePath,
    required this.title,
    required this.subtitle,
  });
}
