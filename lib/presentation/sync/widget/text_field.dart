import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class GlowTextField extends StatefulWidget {
  const GlowTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  State<GlowTextField> createState() => _GlowTextFieldState();
}

class _GlowTextFieldState extends State<GlowTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isFocused
              ? [
            BoxShadow(

              color: ColorManager.primary.withOpacity(0.45),
              blurRadius: 2,   // نعومة اللمعة
              spreadRadius: 1.5,  // بدون تمدد قاسي
              offset: Offset.zero, // مهم جداً
              blurStyle: BlurStyle.inner
            ),
          ]
              : [],

        ),
        child: TextFormField(
          focusNode: _focusNode,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          cursorColor: ColorManager.primary,
          
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(15),
            hintText: widget.label,
            filled: true,
            fillColor: ColorManager.white,
            prefixIcon: Icon(
              widget.icon,
              color:ColorManager.primary ,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorManager.primary.withOpacity(0.35),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: ColorManager.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
