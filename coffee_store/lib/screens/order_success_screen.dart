
import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class OrderSuccessScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const OrderSuccessScreen({
    super.key,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;

    // Responsive sizes for different mobile devices.
    final circleSize = (shortestSide * 0.42).clamp(120.0, 190.0);
    final iconSize = circleSize * 0.55;
    final titleSize = (shortestSide * 0.055).clamp(17.0, 24.0);
    final messageSize = (shortestSide * 0.050).clamp(16.0, 21.0);
    final buttonWidth = (screenSize.width * 0.52).clamp(150.0, 220.0);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success heading
                  Text(
                    'ORDER SUCCESSFUL!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Smaller success icon
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFB2BA),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEFB2BA)
                              .withValues(alpha: 0.30),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: iconSize,
                      color: const Color(0xFF301C22),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Thank-you message
                  Text(
                    'THANK YOU FOR YOUR PURCHASE!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: messageSize,
                      fontWeight: FontWeight.w900,
                      height: 1.4,
                      letterSpacing: 0.3,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Your coffee order has been placed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF78635B),
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Smaller responsive Continue button
                  SizedBox(
                    width: buttonWidth,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        onContinue();

                        Navigator.of(context).popUntil(
                          (route) => route.isFirst,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E1B1D),
                        foregroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: const Color(0xFFEFB2BA),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'CONTINUE',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
