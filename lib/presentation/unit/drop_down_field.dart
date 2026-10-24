import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/font_manager.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';

class DropDownField extends StatelessWidget {
  const DropDownField({
    super.key,
    required this.label,
    required this.icon,
    required this.hint,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final String label;
  final String hint;
  final IconData icon;
  final UserType? value;
  final void Function(UserType?) onChanged;
  final String? Function(UserType?)? validator;

  @override
  Widget build(BuildContext context) {
    // خطوط ثابتة معتدلة: الثيم يكبّرها على التابلت فتطغى على الحقل
    final double textSize = FontResponsive.font(context, mobile: 14, tablet: 16);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontFamily: FontConstants.fontFamily1,
            fontSize: textSize,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 10),
          child: DropdownButtonFormField<UserType>(
            value: value,
            isExpanded: true,
            validator: validator,
            style: TextStyle(fontFamily: FontConstants.fontFamily1, fontSize: textSize, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontFamily: FontConstants.fontFamily1, fontSize: textSize),
              prefixIcon: Icon(icon),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            items: UserType.values.map((type) {
              return DropdownMenuItem<UserType>(
                value: type,
                child: Text(
                  type.nameAr,
                  style: TextStyle(fontFamily: FontConstants.fontFamily1, fontSize: textSize),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}