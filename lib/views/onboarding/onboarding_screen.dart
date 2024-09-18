import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wine_delivery_app/views/auth/registration_page.dart';

import '../../utils/preferences.dart';
// For sign-up/login

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, String>> onboardingData = [
    {"image": "assets/onboarding1.png", "title": "Discover Your Favorite Wines", "description": "Browse a wide selection of wines curated for you."},
    {"image": "assets/onboarding2.png", "title": "Easy Purchase", "description": "Buy wines with a single tap and fast delivery."},
    {"image": "assets/onboarding3.png", "title": "Manage Your Orders", "description": "Track your orders and manage your purchases seamlessly."}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) => OnboardingContent(
                image: onboardingData[index]["image"]!,
                title: onboardingData[index]["title"]!,
                description: onboardingData[index]["description"]!,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => buildDot(index: index),
            ),
          ),
          const SizedBox(height: 20),
          currentPage == onboardingData.length - 1
              ? ElevatedButton(
                  onPressed: () async {
                    seenOnboarding = true;

                    // Navigate to Authentication Screen (Sign-up/Login)
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegistrationPage(),
                      ),
                    );
                  },
                  child: const Text("Get Started"),
                )
              : TextButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text("Next"),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      width: currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardingContent extends StatelessWidget {
  final String image, title, description;

  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/animations/vintiora.json', // Path to your Lottie animation
          height: 300,
          width: 200,
        ),
        /*Image.asset(
          image,
          height: 300,
          width: 300,
        ),*/
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Text(
            description,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
