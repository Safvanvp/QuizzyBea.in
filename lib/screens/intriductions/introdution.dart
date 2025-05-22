import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/auth/login_page.dart';
import 'package:quizzybea_in/widgets/introductionscreens/intropage1.dart';
import 'package:quizzybea_in/widgets/introductionscreens/intropage2.dart';
import 'package:quizzybea_in/widgets/introductionscreens/intropage3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Introduction extends StatefulWidget {
  const Introduction({super.key});

  @override
  State<Introduction> createState() => _IntroductionState();
}

class _IntroductionState extends State<Introduction> {
  final PageController _pageController = PageController();
  bool _onLastPage = false;

  void goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.deepPurple;

    return Scaffold(
      body: Stack(
        children: [
          // PageView
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _onLastPage = index == 2);
            },
            children: const [
              Intropage1(),
              Intropage2(),
              Intropage3(),
            ],
          ),

          // Skip Button (top right)
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
              onTap: goToLoginPage,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 16,
                  color: themeColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Page Indicator
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: themeColor,
                  dotColor: Colors.grey.shade300,
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 12,
                  expansionFactor: 4,
                ),
              ),
            ),
          ),

          // Floating Next / Get Started Button
          Positioned(
            bottom: 30,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_onLastPage) {
                  goToLoginPage();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              icon: Icon(
                _onLastPage ? Icons.check : Icons.arrow_forward,
                color: Colors.white,
              ),
              label: Text(
                _onLastPage ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 6,
                shadowColor: themeColor.withOpacity(0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
