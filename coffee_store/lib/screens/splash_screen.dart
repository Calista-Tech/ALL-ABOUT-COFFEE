import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/app_image.dart';
import 'main_shell.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset('assets/images/beans_bg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox()),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(size: 210),
                const SizedBox(height: 10),
                const Text('ALL ABOUT COFFEE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 58,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF231F20))),
                const SizedBox(height: 120),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainShell()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 22),
                    decoration: BoxDecoration(
                        color: AppColors.coral,
                        borderRadius: BorderRadius.circular(26)),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('GET STARTED',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        SizedBox(width: 14),
                        Icon(Icons.arrow_right_alt,
                            color: Colors.white, size: 36),
                      ],
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
