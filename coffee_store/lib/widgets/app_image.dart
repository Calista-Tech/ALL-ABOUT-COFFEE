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

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: AppColors.tan,
        child: const Icon(Icons.coffee, color: AppColors.brown),
      );

  @override
  Widget build(BuildContext context) {
    final Widget child;
    if (path.isEmpty) {
      // New product without an image yet
      child = _placeholder();
    } else if (path.startsWith('http')) {
      // Image uploaded to Supabase Storage (or any URL)
      child = Image.network(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (_, w, progress) => progress == null ? w : _placeholder(),
      );
    } else {
      // Bundled asset
      child = Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return ClipRRect(borderRadius: BorderRadius.circular(radius), child: child);
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