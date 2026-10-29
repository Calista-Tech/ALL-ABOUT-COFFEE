import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;

  const AppImage(this.path,
      {super.key, this.width, this.height, this.fit = BoxFit.cover, this.radius = 0});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppColors.tan,
          child: const Icon(Icons.coffee, color: AppColors.brown),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 70});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.local_cafe, size: size, color: AppColors.brown),
    );
  }
}
