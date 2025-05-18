import 'package:flutter/material.dart';
import 'package:quizzybea_in/screens/auth/login_page.dart';
import 'package:quizzybea_in/screens/home/home.dart';
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
  PageController _pagecontroller = PageController();
  bool onLastPage = false;
  bool onFirstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pagecontroller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                onFirstPage = (index == 0);
              });
            },
            children: [
              Intropage1(),
              Intropage2(),
              Intropage3(),
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  onFirstPage
                      ? GestureDetector(
                          onTap: () {
                            _pagecontroller.jumpToPage(2);
                          },
                          child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.center,
                              child: Text('Skip')),
                        )
                      : GestureDetector(
                          onTap: () {
                            _pagecontroller.previousPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInBack);
                          },
                          child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.center,
                              child: Text('Back')),
                        ),
                  SmoothPageIndicator(
                    controller: _pagecontroller,
                    count: 3,
                  ),
                  !onLastPage
                      ? GestureDetector(
                          onTap: () {
                            _pagecontroller.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.center,
                              child: Text('Next')),
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              alignment: Alignment.center,
                              child: Text('Done')),
                        )
                ],
              ))
        ],
      ),
    );
  }
}
