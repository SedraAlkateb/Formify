import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';

class GlowTextField extends StatefulWidget {
  const GlowTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(widget.label),

        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              validator: widget.validator,
              cursorColor: ColorManager.primary,
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                //  hintText: "  ${widget.hint}   ",
                hint: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(width: 8),
                    Text(
                      widget.hint,
                      style: TextStyle(color: ColorManager.textHint),
                    ),
                  ],
                ),
                filled: true,
                fillColor: ColorManager.white,
                prefixIcon: Icon(widget.icon, color: ColorManager.primary),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: ColorManager.primary.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: ColorManager.primary, width: 2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: ColorManager.primary, // لون المؤشر

      decoration: InputDecoration(
        hintText: label,
        filled: true,
        fillColor: ColorManager.white,

        prefixIcon: Icon(icon, color: Colors.grey.shade600),
      ),
    ),
  );
}
