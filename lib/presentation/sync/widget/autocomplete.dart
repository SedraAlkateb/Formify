import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

class DoctorAutocompleteField extends StatelessWidget {
  final List<DoctorsModel> allDoctors;
  final Function(DoctorsModel) onSelected;
  final TextEditingController controller;
  final FocusNode? focusNode; // إضافة هذا الحقل
  final int index;
  final AnimationController animationController;
  final Widget Function({required Widget child, required int index, required AnimationController controller}) buildAnimatedField;

  const DoctorAutocompleteField({
    super.key,
    required this.allDoctors,
    required this.onSelected,
    required this.controller,
    this.focusNode, // حقل اختياري
    required this.index,
    required this.animationController,
    required this.buildAnimatedField,
  });

  @override
  Widget build(BuildContext context) {
    // حل مشكلة Assertion: إذا لم يوجد FocusNode، ننشئ واحد محلي
    final FocusNode effectiveFocusNode = focusNode ?? FocusNode();

    return buildAnimatedField(
      index: index,
      controller: animationController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("الاسم الكامل", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          RawAutocomplete<DoctorsModel>(
            textEditingController: controller,
            focusNode: effectiveFocusNode, // تمرير الـ focusNode هنا ضروري جداً
            displayStringForOption: (DoctorsModel option) => option.name,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<DoctorsModel>.empty();
              }
              return allDoctors.where((DoctorsModel doc) {
                return doc.name.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: onSelected,
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 80, // تعديل العرض قليلاً
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        separatorBuilder: (context, i) => Divider(height: 1, color: Colors.grey.shade100),
                        itemBuilder: (context, index) {
                          final DoctorsModel doc = options.elementAt(index);
                          return ListTile(
                            title: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text("${doc.region} - ${doc.description}"),
                            onTap: () => onSelected(doc),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
            fieldViewBuilder: (context, textController, fieldFocusNode, onFieldSubmitted) {
              return TextFormField(
                controller: textController,
                focusNode: fieldFocusNode, // استخدام الـ node الممرر من الـ Autocomplete
                onChanged: (value) {
                  context.read<SyncBloc>().add(const ClearDoctorSelectionEvent());
                },
                decoration: InputDecoration(
                  hintText: "ابحث عن اسم الطبيب...",
                  prefixIcon: Icon(Icons.person_search, color: ColorManager.primary),
                  filled: true,
                  fillColor: ColorManager.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorManager.primary.withOpacity(0.35), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorManager.primary, width: 2),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}