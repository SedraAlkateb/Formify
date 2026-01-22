import 'package:flutter/material.dart';

class InteractiveAddressCard extends StatefulWidget {
  const InteractiveAddressCard({super.key, required this.child});
  final Widget child;

  @override
  State<InteractiveAddressCard> createState() => _InteractiveAddressCardState();
}

class _InteractiveAddressCardState extends State<InteractiveAddressCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed == v) return; // يمنع setState المتكرر
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
