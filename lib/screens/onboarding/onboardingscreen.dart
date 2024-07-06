import 'package:anzen/screens/onboarding/setmasterpasswordscreen.dart';
import 'package:anzen/widgets/setpatternscreen.dart';
import 'package:anzen/widgets/setpincodescreen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int selectedIndex = 0;
  PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        //physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: const [
          SetMasterPasswordScreen(),
          Setpincodescreen(),
          Setpatternscreen(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.nextPage(
              duration: const Duration(seconds: 1),
              curve: Curves.fastEaseInToSlowEaseOut);
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
