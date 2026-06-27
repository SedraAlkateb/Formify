import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final IconData icon;
  final List<T> items;
  final String Function(T) itemAsString;
  final ValueChanged<T?> onChanged;

  const CustomFilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 4.h),

        DropdownButtonFormField<T>(
          isExpanded: true,
          value: items.contains(value) ? value : null,
          hint: Text(
            "اختر من القائمة...",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.sp,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          onChanged: onChanged,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: const Color(0xFF64748B),
            size: 22.r,
          ),
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8B5CF6),
              size: 18.r,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
          ),
          selectedItemBuilder: (context) {
            return items.map((item) {
              return Align(
                alignment: Alignment.centerRight,
                child: Text(
                  itemAsString(item),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                ),
              );
            }).toList();
          },
          items: items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemAsString(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}