import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';

class UpdateConferencePage extends StatelessWidget {
  UpdateConferencePage({
    super.key,
    required this.conferenceModel,
  });
  late final GetAllConferenceByIdModel conferenceModel;
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
        title: Text('تعديل مؤتمر', style: TextStyle(color: ColorManager.black)),
        backgroundColor: ColorManager.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
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
                        const Text(
                          "اسم المؤتمر",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'name',
                          initialValue: conferenceModel.name,
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
                        const Text(
                          "الوصف",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'description',
                          initialValue: conferenceModel.description,
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
                        const Text(
                          "العنوان",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          initialValue: conferenceModel.address,
                          name: 'address',
                          decoration: InputDecoration(
                            hintText: 'ادخل وصف العنوان',
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
                        const Text(
                          "التاريخ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                initialValue: DateTime.parse(
                                  conferenceModel.startDate,
                                ),
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
                                initialValue: DateTime.parse(
                                  conferenceModel.endDate,
                                ),
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

                                //TODO
                                validator: (val) {
                                  final start =
                                      _formKey
                                              .currentState
                                              ?.fields['start_date']
                                              ?.value
                                          as DateTime?;
                                  if (val == null) return 'Required';
                                  if (start != null && val.isBefore(start)) {
                                    return 'End date must be after start date';
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
                ],
              ),
            ),

            // ===== BLoC submit =====
            BlocListener<ConferenceBloc, ConferenceState>(
              listener: (context, state) {
                if (state is UpdateConferenceLoadingState) {
                  loading(context);
                } else if (state is UpdateConferenceErrorState) {
                  error(context, state.failure.massage, state.failure.code);
                } else if (state is UpdateConferenceState) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                   (route) => false
                  );
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
                    conferenceModel.name=v["name"];
                    conferenceModel.description=v["description"];
                    conferenceModel.address=v["address"];
                    conferenceModel.startDate= _toYmd(v["start_date"] as DateTime);
                    conferenceModel.endDate=_toYmd(v["end_date"] as DateTime);
                    BlocProvider.of<ConferenceBloc>(context).add(
                      UpdateInfoConferenceEvent(
                        conferenceModel
                      ),
                    );
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
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
