import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeoBrutalistContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double offset;

  const NeoBrutalistContainer({
    super.key,
    required this.child,
    this.backgroundColor = AppTheme.surface,
    this.borderWidth = 3.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.offset = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Hard Shadow
          Positioned(
            top: offset,
            left: offset,
            right: -offset,
            bottom: -offset,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
            ),
          ),
          // Main Container
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(
                color: AppTheme.border,
                width: borderWidth,
              ),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
