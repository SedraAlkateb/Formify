import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:formify/domain/models/models.dart';

// عدّل الاستيرادات حسب مشروعك
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/conference/bloc/conference_bloc.dart';

class CreateConferencePage extends StatelessWidget {
   CreateConferencePage({super.key});

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.background,
      appBar:

      AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: ColorManager.black),
        ),
        title: Text(
          'Create Conference',
          style: TextStyle(color: ColorManager.black),
        ),
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
                          "Conference Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: InputDecoration(
                            hintText: 'enter conference name',
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
                          "Description",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'description',
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'enter conference description',
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
                          "Address",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        FormBuilderTextField(
                          name: 'address',
                          decoration: InputDecoration(
                            hintText: 'enter conference address',
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
                          "Dates",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: FormBuilderDateTimePicker(
                                cursorColor: ColorManager.primary,
                                style: TextStyle(color: ColorManager.primary, ),
                                name: 'start_date',

                                inputType: InputType.date,
                                decoration: InputDecoration(
                                  labelText: 'Start date',
                                  focusColor: ColorManager.primary,
                                  hoverColor: ColorManager.primary,
                                  iconColor: ColorManager.primary,
                                  labelStyle: TextStyle(color: ColorManager.primary, ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon:
                                  const Icon(Icons.calendar_month),
                                ),
                                validator: FormBuilderValidators.required(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child:FormBuilderDateTimePicker(
                                name: 'end_date',
                                cursorColor: ColorManager.primary,
                                inputType: InputType.date,
                                style: TextStyle(color: ColorManager.primary), // لون النص
                                decoration: InputDecoration(
                                  labelText: 'End date',
                                  labelStyle: TextStyle(color: ColorManager.primary),
                                  hintStyle: TextStyle(color: ColorManager.primary.withOpacity(0.6)),
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
                                  final start = _formKey
                                      .currentState
                                      ?.fields['start_date']
                                      ?.value as DateTime?;
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
                if (state is CreateConferenceLoadingState) {
                  loading(context);
                } else if (state is CreateConferenceErrorState) {
                  error(context, state.failure.massage, state.failure.code);
                } else if (state is CreateConferenceState) {
                  BlocProvider.of<ConferenceBloc>(context)
                      .add(GetAllSurveyByConferenceEvent(
                    state.conferenceId
                  ));
                 Navigator.pushReplacementNamed(context, Routes.conferenceSurveyById,
                   arguments: {
                     "conferenceId": state.conferenceId
                   },
                 );
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary, // لون الخلفية
                    foregroundColor: Colors.white,          // لون النص
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    final ok = _formKey.currentState?.saveAndValidate() ?? false;
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

                    BlocProvider.of<ConferenceBloc>(context)
                        .add(CreateConferenceEvent(ConferenceModel.fromMap(payload)));
                  },
                  child: const Text(
                    'Create',
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
