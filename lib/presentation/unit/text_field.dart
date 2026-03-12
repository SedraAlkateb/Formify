import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

class GlowTextField extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,style: Theme.of(context).textTheme.titleMedium),

        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              cursorColor: ColorManager.primary,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                //  hintText: "  ${widget.hint}   ",
                hint: Text(
                  hint,
                  style: TextStyle(color: ColorManager.textHint),
                ),
                filled: true,
                fillColor: ColorManager.white,
                prefixIcon: Icon(icon, color: ColorManager.primary),

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

class LoginTextField extends StatelessWidget {
   LoginTextField({
    super.key,

    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.keyboardType,
    this.validator,
    this.isObscure,
  });

  final TextEditingController controller;
  final String label;
  final String hint;

  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  bool? isObscure = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: ColorManager.primary,
            fontSize: FontResponsive.font(
              context,
              mobile: 14,
              tablet: 15,

            ),
            fontWeight: FontWeight.bold,
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isObscure??false,
              validator: validator,
              cursorColor: ColorManager.primary,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                //  hintText: "  ${widget.hint}   ",
                hint: Text(
                  hint,
                  style: TextStyle(color: ColorManager.textHint),
                ),
                filled: true,
                fillColor: ColorManager.white,
                prefixIcon: Icon(icon, color: ColorManager.primary),
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
