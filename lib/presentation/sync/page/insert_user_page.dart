import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/doctor_filter_card.dart';
import 'package:formify/presentation/unit/animation/animation-in_list.dart';
import 'package:formify/presentation/unit/animation/buttom_animation.dart';
import 'package:formify/presentation/unit/drop_down_field.dart';
import 'package:formify/presentation/unit/text_field.dart';

class InsertUserPage extends StatefulWidget {
  const InsertUserPage({super.key});

  @override
  State<InsertUserPage> createState() => _InsertUserPageState();
}
class _InsertUserPageState extends State<InsertUserPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController importantDoctorSearchController =
      TextEditingController();
  final TextEditingController specialtySearchController =
      TextEditingController();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  UserType _selectedUserType = UserType.other;
  SpecModel? _selectedSpecialty;
  List<SpecModel> _specialties = [];

  final FocusNode _importantDoctorFocusNode = FocusNode();
  final FocusNode _anyDoctorFocusNode =
      FocusNode();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _selectedSpecialty = null;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
    BlocProvider.of<SyncBloc>(context).selectedDoctor=null;
    // جلب قائمة الاختصاصات من البلوك عند التهيئة
    _specialties = BlocProvider.of<SyncBloc>(context).spec;

  }

  @override
  void dispose() {
    importantDoctorSearchController.dispose();
    specialtySearchController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    _importantDoctorFocusNode.dispose();
    _anyDoctorFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserSqlModel(
        user: UserModel(
            fullNameController.text,
            emailController.text, phoneController.text,
            addressController.text,
          spec: _selectedSpecialty,
            userTypeFromId(_selectedUserType.id), noteController.text,

        ),
        answerModel: [],
      );

      BlocProvider.of<SyncBloc>(context).add(InputUserSqlEvent(user));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (_, c) {
                  return Container(
                    width: double.infinity,
                    margin: Constants.isTablet
                        ? const EdgeInsets.all(50)
                        : const EdgeInsets.only(top: 50, bottom: 50, right: 25, left: 25),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: ColorManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: AppPadding.p40,
                        left: AppPadding.p40,
                        top: AppPadding.p20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildHeaderIcon(),
                            _buildHeaderTitle(),
                            const SizedBox(height: 5),
                            ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                _buildFilterSectionHeader(),
                                DoctorFilterCard(
                                  specialties: _specialties,
                                  selectedSpecialty: _selectedSpecialty,
                                  specialtySearchController: specialtySearchController,
                                  importantDoctorSearchController: importantDoctorSearchController,
                                  anyDoctorFocusNode: _anyDoctorFocusNode,
                                  importantDoctorFocusNode: _importantDoctorFocusNode,
                                  animationController: _controller,
                                  onDoctorSelected: (doctor) {
                                    setState(() {
                                      print("ssssssss");
                                      print(doctor.spec?.id ?? 9);
                                      BlocProvider.of<SyncBloc>(context).selectedDoctor = doctor;
                                      _selectedUserType = doctor.userType;
                                      fullNameController.text = doctor.fullName;
                                      addressController.text = doctor.address ?? "";
                                      noteController.text = doctor.notes ?? "";
                                      emailController.text = doctor.email ?? "";
                                      phoneController.text = doctor.phone;

                                      // 🌟 التعديل هنا: ابحث عن الاختصاص داخل القائمة المحلية بواسطة الـ id لمنع اختلاف المراجع
                                      if (doctor.spec != null && _specialties.any((e) => e.id == doctor.spec!.id)) {
                                        _selectedSpecialty = _specialties.firstWhere((e) => e.id == doctor.spec!.id);
                                      } else {
                                        _selectedSpecialty = null; // أو اتركه فارغاً إذا لم يكن مسجلاً له اختصاص
                                      }

                                      specialtySearchController.clear();
                                    });
                                    _importantDoctorFocusNode.unfocus();
                                  },
                                ),
                                _buildPersonalDataHeader(),
                                _buildPersonalDataFields(),
                                 SizedBox(height: AppSize.s20),
                                _buildSubmitButtonConsumer(),
                                 SizedBox(height: AppSize.s20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeaderIcon() {
    return buildAnimatedField(
      controller: _controller,
      index: 1,
      child: Card(
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: ColorManager.primary,
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(
            Icons.person_outline,
            color: Color(0xffffffff),
            size: 45,
          ),
        ),
      ),
    );
  }
  /// عنوان الصفحة العلوي المتحرك
  Widget _buildHeaderTitle() {
    return buildAnimatedField(
      controller: _controller,
      index: 2,
      child: Text(
        "معلومات الحضور",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: ColorManager.primary,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// عنوان قسم التصفية والبحث
  Widget _buildFilterSectionHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        "البحث المتقدم والتصفية:",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
  /// عنوان قسم البيانات الشخصية للحضور
  Widget _buildPersonalDataHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),

        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0),

          child: Text("البيانات الشخصية للحضور:",style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),),
        ),
      ],
    );
  }

  /// تجميعة حقول إدخال البيانات الشخصية ونوع الحضور
  Widget _buildPersonalDataFields() {
    return Column(
      children: [
        buildAnimatedField(
          controller: _controller,
          index: 7,
          child: GlowTextField(
            controller: fullNameController,
            label: 'الاسم الكامل *',
            hint: "أدخل الاسم الكامل أو اختر من الأعلى",
            icon: Icons.badge_outlined,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'يرجى إدخال الاسم أو اختيار طبيب من حقول البحث';
              }
              return null;
            },
          ),
        ),
        buildAnimatedField(
          controller: _controller,
          index: 8,
          child: GlowTextField(
            controller: phoneController,
            label: 'رقم الهاتف *',
            hint: "09xxxxxxxx",
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return null;
              if (v.trim().length < 8) {
                return 'الرقم قصير جداً، يجب أن يكون 8 أرقام على الأقل';
              }
              return null;
            },
          ),
        ),
        buildAnimatedField(
          controller: _controller,
          index: 9,
          child: GlowTextField(
            controller: emailController,
            hint: "example@gmail.com",
            label: 'البريد الإلكتروني *',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => null,
          ),
        ),
        buildAnimatedField(
          controller: _controller,
          index: 10,
          child: GlowTextField(
            controller: addressController,
            label: 'العنوان',
            hint: "أدخل عنوانك الكامل",
            icon: Icons.location_on_outlined,
            validator: (v) => null,
          ),
        ),
        buildAnimatedField(
          controller: _controller,
          index: 11,
          child: GlowTextField(
            controller: noteController,
            label: 'ملاحظة',
            hint: "أدخل الملاحظة كاملة",
            icon: Icons.note_alt_outlined,
            validator: (v) => null,
          ),
        ),
        const SizedBox(height: 8),

        // 1️⃣ منسدلة الاختصاصات
        DropdownButtonFormField<SpecModel>(
          decoration: InputDecoration(
            labelText: "اختر الاختصاص الطبي",
            prefixIcon: const Icon(Icons.biotech_outlined),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: ColorManager.white,
          ),
          value: _selectedSpecialty,
          hint: const Text("كل الاختصاصات"),
          items: _specialties.map((specialty) {
            return DropdownMenuItem<SpecModel>(
              value: specialty,
              child: Text(
                specialty.title??"",
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedSpecialty = value;
            });
          },
        ),
        buildAnimatedField(
          controller: _controller,
          index: 12,
          child: DropDownField(
            label: 'نوع الحضور',
            hint: 'اختر نوع الحضور',
            icon: Icons.category_outlined,
            value: _selectedUserType,
            onChanged: (value) {
              setState(() {
                _selectedUserType = value ?? UserType.other;
              });
            },
            validator: (value) {
              if (value == null) return 'يرجى اختيار نوع الحضور';
              return null;
            },
          ),
        ),
      ],
    );
  }

  /// زر المتابعة إلى الاستبيان المرتبط بالـ BlocConsumer لإدارة الحالة والتنقل
  Widget _buildSubmitButtonConsumer() {
    return BlocConsumer<SyncBloc, SyncState>(
      listener: (context, state) {
        if (state is NavigateToSurveyState) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.listOfSurveys, (route) => false);
        }
        else if (state is NavigateToConferenceState) {
          // final localUser = UserSqlModel(
          //   user: UserModel(
          //       fullNameController.text,
          //       emailController.text,phoneController.text,
          //       addressController.text,
          //      spec: _selectedSpecialty,
          //       userTypeFromId(_selectedUserType.id),noteController.text),
          //   answerModel: [],
          // );
          BlocProvider.of<SyncBloc>(context).add(InsertUserSqlEvent());
        } else if (state is FinishedSurveyState) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.showConference, (route) => false);
        }
      },
      builder: (context, state) {
        return bottomAnimation(
          context,
          _submit,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                state is InsertUserErrorState
                    ? state.failure.massage
                    : state is InsertUserLoadingState
                    ? "Loading..."
                    : 'متابعة الى الاستبيان',
              ),
              const SizedBox(width: 9),
              const Icon(Icons.arrow_forward),
            ],
          ),
        );
      },
    );
  }
}
