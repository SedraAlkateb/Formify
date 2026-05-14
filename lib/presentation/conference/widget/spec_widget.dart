import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';

class SpecialtyDropdownField extends StatelessWidget {
  final List<SpecModel>? specialties; // جعلناها اختيارية لدعم حالات التحميل
  final String name;
  final String label;
  final bool isLoading; // حالة التحميل
  final String? errorText; // نص الخطأ
  final Function(SpecModel?)? onChanged;

  const SpecialtyDropdownField({
    super.key,
    this.specialties,
    this.isLoading = false,
    this.errorText,
    this.name = 'specialty_id',
    this.label = 'الاختصاص',
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        FormBuilderDropdown<SpecModel>(
          name: name,
          // تعطيل الحقل إذا كان هناك تحميل أو خطأ
          enabled: !isLoading && errorText == null,
          decoration: InputDecoration(
            // تغيير النص الملمح (Hint) بناءً على الحالة
            hintText: isLoading
                ? 'جاري تحميل الاختصاصات...'
                : (errorText ?? 'اختر الاختصاص'),
            // تغيير لون الحدود في حالة الخطأ أو التحميل
            hintStyle: TextStyle(
                color: errorText != null ? Colors.red : (isLoading ? Colors.grey : Colors.black54)
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon: isLoading
                ? const Padding(
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator(strokeWidth: 2), // مؤشر تحميل صغير
            )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          ),
          // عرض القائمة فقط في حالة النجاح
          items: (specialties ?? []).map((spec) => DropdownMenuItem<SpecModel>(
            value: spec,
            child: Text(spec.title),
          )).toList(),
          validator: FormBuilderValidators.required(errorText: 'يرجى اختيار الاختصاص'),
          onChanged: onChanged,
        ),
      ],
    );
  }
}