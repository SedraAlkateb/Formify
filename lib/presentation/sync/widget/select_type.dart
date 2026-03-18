import 'package:flutter/material.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
class SelectType extends StatefulWidget {
   SelectType({super.key,required this.selectedUserType});
   UserType selectedUserType;
  @override
  State<SelectType> createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحضور',
          style: TextStyle(
            color: ColorManager.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        Wrap(
          spacing: 10, // مسافة أفقية
          runSpacing: 10, // مسافة بين الأسطر
          children: UserType.values.map((type) {
            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  widget.selectedUserType = type;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: widget.selectedUserType == type
                      ? ColorManager.primary.withOpacity(0.1)
                      : Colors.transparent,
                  border: Border.all(
                    color: widget.selectedUserType == type
                        ? ColorManager.primary
                        : ColorManager.border,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<UserType>(
                      value: type,
                      groupValue: widget.selectedUserType,
                      activeColor: ColorManager.primary,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.selectedUserType = value;
                          });
                        }
                      },
                    ),
                    Text(
                      type.nameAr,
                      style: TextStyle(
                        color: ColorManager.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }}

