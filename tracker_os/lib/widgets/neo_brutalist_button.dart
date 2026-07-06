import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

class NeoBrutalistButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final double offset;

  const NeoBrutalistButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.backgroundColor = AppTheme.primary,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.borderWidth = 3.0,
    this.offset = 6.0,
  });

  @override
  State<NeoBrutalistButton> createState() => _NeoBrutalistButtonState();
}

class _NeoBrutalistButtonState extends State<NeoBrutalistButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        SystemSound.play(SystemSoundType.click);
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        transform: Matrix4.translationValues(
          _isPressed ? widget.offset / 2 : 0,
          _isPressed ? widget.offset / 2 : 0,
          0,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Hard Shadow
            if (!_isPressed)
              Positioned(
                top: widget.offset,
                left: widget.offset,
                right: -widget.offset,
                bottom: -widget.offset,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            // Main Button
            Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                border: Border.all(
                  color: AppTheme.border,
                  width: widget.borderWidth,
                ),
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black),
                child: IconTheme(
                  data: const IconThemeData(color: Colors.black),
                  child: widget.child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
