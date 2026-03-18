import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16, top: 10),
          child: DropdownButtonFormField<UserType>(
            value: value,
            isExpanded: true,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon),
            ),
            items: UserType.values.map((type) {
              return DropdownMenuItem<UserType>(
                value: type,
                child: Text(
                  type.nameAr,
                  style: TextStyle(
                    fontSize: FontResponsive.font(
                      context,
                      mobile: 15,
                      tablet: 19,
                    ),
                  ),
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