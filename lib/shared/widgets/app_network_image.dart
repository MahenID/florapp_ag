import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedUrl = imageUrl.trim();

    Widget imageWidget;

    if (trimmedUrl.isEmpty) {
      imageWidget = _buildPlaceholder();
    } else if (trimmedUrl.startsWith('data:image') || _isBase64(trimmedUrl)) {
      try {
        final cleanBase64 = trimmedUrl.contains(',')
            ? trimmedUrl.split(',').last
            : trimmedUrl;
        final Uint8List bytes = base64Decode(cleanBase64);
        imageWidget = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        );
      } catch (_) {
        imageWidget = _buildPlaceholder();
      }
    } else if (trimmedUrl.startsWith('http://') ||
        trimmedUrl.startsWith('https://')) {
      imageWidget = Image.network(
        trimmedUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.green.withValues(alpha: 0.05),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.green,
                ),
              ),
            ),
          );
        },
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  bool _isBase64(String str) {
    if (str.length < 20) return false;
    final base64Regex = RegExp(r'^[A-Za-z0-9+/=]+$');
    return !str.contains(' ') && base64Regex.hasMatch(str.substring(0, 20));
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.green.withValues(alpha: 0.08),
      child: const Center(
        child: Icon(
          Icons.local_florist_outlined,
          color: Colors.green,
          size: 32,
        ),
      ),
    );
  }
}
