import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/widget/spec_widget.dart';

// عدّل الاستيرادات حسب مشروعك
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';

class CreateConferencePage extends StatelessWidget {
  CreateConferencePage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
        ),
        title: Text(
          'انشاء مؤتمر',
          style: TextStyle(
            color: ColorManager.black,
            fontSize: FontResponsive.font(context, mobile: 20, tablet: 24),
          ),
        ),
        backgroundColor: ColorManager.white,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppPadding.p16),
                    margin: EdgeInsets.symmetric(vertical: AppPadding.p12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "اسم المؤتمر",
                          style: TextStyle(
                            fontSize: FontResponsive.font(
                              context,
                              mobile: 16,
                              tablet: 20,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                            hintText: 'ادخل اسم المؤتمر',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "الوصف",
                          style: TextStyle(
                            fontSize: FontResponsive.font(
                              context,
                              mobile: 16,
                              tablet: 20,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'description',
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'ادخل وصف المؤتمر',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(5),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "العنوان",

                          style: TextStyle(
                            fontSize: FontResponsive.font(
                              context,
                              mobile: 16,
                              tablet: 20,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'address',
                          decoration: InputDecoration(
                            hintText: 'ادخل عنوان المؤتمر',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: FormBuilderValidators.required(),
                        ),
                      ],
                    ),
                  ),

                  // تواريخ + الحالة
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "التاريخ",
                          style: TextStyle(
                            fontSize: FontResponsive.font(
                              context,
                              mobile: 18,
                              tablet: 22,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                cursorColor: ColorManager.primary,
                                style: TextStyle(color: ColorManager.primary),
                                name: 'start_date',

                                inputType: InputType.date,
                                decoration: InputDecoration(
                                  labelText: 'تاريخ البدء',
                                  focusColor: ColorManager.primary,
                                  hoverColor: ColorManager.primary,
                                  iconColor: ColorManager.primary,
                                  labelStyle: TextStyle(
                                    color: ColorManager.primary,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon: const Icon(Icons.calendar_month),
                                ),
                                validator: FormBuilderValidators.required(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                name: 'end_date',
                                cursorColor: ColorManager.primary,
                                inputType: InputType.date,
                                style: TextStyle(
                                  color: ColorManager.primary,
                                ), // لون النص
                                decoration: InputDecoration(
                                  labelText: 'تاريخ الانتهاء',
                                  labelStyle: TextStyle(
                                    color: ColorManager.primary,
                                  ),
                                  hintStyle: TextStyle(
                                    color: ColorManager.primary.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    color: ColorManager.primary,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                      width: 2,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                      color: ColorManager.primary,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                validator: (val) {
                                  final start =
                                      _formKey
                                              .currentState
                                              ?.fields['start_date']
                                              ?.value
                                          as DateTime?;
                                  if (val == null) return 'مطلوب';
                                  if (start != null && val.isBefore(start)) {
                                    return 'تاريخ الانتهاء يجب ان يكون بعد تاريخ البدء';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // FormBuilderSwitch(
                        //   name: 'is_active',
                        //   initialValue: true,
                        //   title: const Text(
                        //     'Is Active',
                        //     style: TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.bold),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // الاختصاص
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        BlocBuilder<ConferenceBloc, ConferenceState>(
                            buildWhen: (previous, current) =>
                            current is GetAllSpecState ||
                                current is GetAllSpecLoadingState ||
                                current is GetAllSpecErrorState,
                          builder: (context, state) {
                            return Column(
                              children: [
                                SpecialtyDropdownField(
                                  specialties: state is GetAllSpecState
                                      ? state.allSpec
                                      : null,
                                  isLoading: state is GetAllSpecLoadingState,
                                  errorText: state is GetAllSpecErrorState
                                      ? "فشل تحميل البيانات"
                                      : null,
                                  onChanged: (selected) {
                                    if (selected != null) {
                                      context.read<ConferenceBloc>().add(AddSpecialtyToLocalListEvent(selected));
                                      print(
                                        "تم اختيار الاختصاص ذو المعرف: ${selected.title}",
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildAddSpecButton(context,(state is GetAllSpecState
                                  ? state.allSpec:[])),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<ConferenceBloc, ConferenceState>(
                          buildWhen: (previous, current) => current is SelectedSpecialtiesUpdatedState,
                          builder: (context, state) {
                            List<SpecModel> specs = [];
                            if (state is SelectedSpecialtiesUpdatedState) {
                              specs = state.selectedSpecs;
                            }

                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: specs.isEmpty
                                  ? const SizedBox.shrink() // إخفاء الواجهة تماماً إذا كانت القائمة فارغة
                                  : Container(
                                key: ValueKey(specs.length), // يساعد في تفعيل الأنيميشن عند تغيير العدد
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: const Color(0xFF3A5A75).withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: DataTable(
                                    headingRowColor: MaterialStateProperty.all(
                                      const Color(0xFF3A5A75).withOpacity(0.1), // لون خفيف للترويسة
                                    ),
                                    columnSpacing: 24,
                                    horizontalMargin: 16,
                                    columns: const [
                                      DataColumn(
                                        label: Text(
                                          'الاختصاص',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A5A75)),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'الإجراء',
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A5A75)),
                                        ),
                                      ),
                                    ],
                                    rows: specs.map((s) => DataRow(
                                      cells: [
                                        DataCell(Text(s.title??"", style: const TextStyle(fontSize: 14))),
                                        DataCell(

                                          IconButton(
                                            alignment: Alignment.centerLeft,
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                                            onPressed: () {
                                              // إرسال حدث الحذف إلى الـ Bloc
                                              context.read<ConferenceBloc>().add(RemoveSpecialtyFromLocalListEvent(s.id??0));
                                            },
                                          ),
                                        ),
                                      ],
                                    )).toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),


                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // ===== BLoC submit =====
            BlocListener<ConferenceBloc, ConferenceState>(
              listener: (context, state) {
                if (state is CreateConferenceLoadingState) {
                  loading(context);
                } else if (state is CreateConferenceErrorState) {
                  error(context, state.failure.massage, state.failure.code);
                } else if (state is CreateConferenceState) {
                  success(context);
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.conferenceSurveyById,
                    arguments: {"conferenceId": state.conferenceId},
                  );
                  BlocProvider.of<ConferenceBloc>(
                    context,
                  ).add(GetAllSurveyByConferenceEvent(state.conferenceId));
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary, // لون الخلفية
                    foregroundColor: Colors.white, // لون النص
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    final ok =
                        _formKey.currentState?.saveAndValidate() ?? false;
                    if (!ok) return;

                    final v = _formKey.currentState!.value;
                    final payload = {
                      "name": v["name"],
                      "description": v["description"],
                      "address": v["address"],
                      "start_date": _toYmd(v["start_date"] as DateTime),
                      "end_date": _toYmd(v["end_date"] as DateTime),
                      "is_active": (v["is_active"] == true) ? 1 : 0,

                    };

                    BlocProvider.of<ConferenceBloc>(context).add(
                      CreateConferenceEvent(ConferenceModel.fromMap(payload)),
                    );
                  },
                  child: Text(
                    'إنشاء',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontResponsive.font(
                        context,
                        mobile: 16,
                        tablet: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ويدجيت الزر الخاص بإضافة اختصاص جديد
  Widget _buildAddSpecButton(BuildContext context,List<SpecModel> spec) {
    return TextButton.icon(
      onPressed: () => _showAddSpecDialog(context,spec),
      icon: const Icon(Icons.add_circle_outline, size: 22),
      label: Text(
        "إنشاء اختصاص جديد",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: FontResponsive.font(context, mobile: 14, tablet: 18),
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor:
            ColorManager.primary, // اللون الأزرق المعتمد لتطبيق DoForm
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      ),
    );
  }

  // نافذة إدخال اسم الاختصاص
  void _showAddSpecDialog(BuildContext context,List<SpecModel> spec) {
    final TextEditingController specController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("إضافة اختصاص جديد", textAlign: TextAlign.right),
        content: TextField(
          controller: specController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "اسم الاختصاص (مثلاً: جراحة قلب)",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (specController.text.isNotEmpty) {
                BlocProvider.of<ConferenceBloc>(context).add(CreateSpecEvent(specController.text,spec));
                Navigator.pop(context);
              }
            },
            child: const Text("إضافة", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _toYmd(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return "$y-$m-$day";
  }
}
