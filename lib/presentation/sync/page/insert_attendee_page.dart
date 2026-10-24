import 'package:flutter/material.dart';
import 'package:formify/presentation/resources/font_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/animation/animation-in_list.dart';
import 'package:formify/presentation/unit/animation/buttom_animation.dart';
import 'package:formify/presentation/unit/drop_down_field.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/unit/text_field.dart';

/// إضافة مستخدم جديد من شاشة تسجيل الحضور مع اختيار نوعه (مهم أو غيره).
/// نفس واجهة صفحة تعديل البيانات.
class AddAttendeePage extends StatefulWidget {
  /// اختصاصات المؤتمر؛ أولها هو الاختصاص الافتراضي للمستخدم الجديد
  final List<SpecModel> conferenceSpecs;

  const AddAttendeePage({super.key, this.conferenceSpecs = const []});

  @override
  State<AddAttendeePage> createState() => _AddAttendeePageState();
}

class _AddAttendeePageState extends State<AddAttendeePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  late final AnimationController _anim;

  UserType _selectedType = UserType.other;
  SpecModel? _selectedSpecialty;
  late final List<SpecModel> _specialties;

  @override
  void initState() {
    super.initState();
    // نعرض اختصاصات المؤتمر ليظهر المستخدم الجديد في قائمة الحضور،
    // وإن لم تصل نرجع لكل الاختصاصات
    _specialties = widget.conferenceSpecs.isNotEmpty
        ? widget.conferenceSpecs
        : BlocProvider.of<SyncBloc>(context).spec;
    if (_specialties.isNotEmpty) _selectedSpecialty = _specialties.first;
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        title: const Text("إضافة مستخدم جديد"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: BlocListener<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state is InsertDoctorSucState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت إضافة المستخدم بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is InsertDoctorErrorState) {
            error(context, state.failure.massage, state.failure.code);
          }
        },
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildAnimatedField(
                        controller: _anim,
                        index: 1,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: ColorManager.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            size: 40,
                            color: ColorManager.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildAnimatedField(
                        controller: _anim,
                        index: 2,
                        child: DropDownField(
                          label: 'نوع المستخدم',
                          hint: 'اختر نوع المستخدم',
                          icon: Icons.category_outlined,
                          value: _selectedType,
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value ?? UserType.other;
                            });
                          },
                          // "الكل" خيار فلترة وليس نوعاً صالحاً لمستخدم جديد
                          validator: (value) =>
                              (value == null || value == UserType.all)
                              ? 'يرجى اختيار نوع صالح'
                              : null,
                        ),
                      ),
                      buildAnimatedField(
                        controller: _anim,
                        index: 3,
                        child: GlowTextField(
                          controller: _nameController,
                          label: 'الاسم الكامل *',
                          hint: "مثال: د. محمد علي",
                          icon: Icons.badge_outlined,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'الرجاء إدخال الاسم'
                              : null,
                        ),
                      ),
                      buildAnimatedField(
                        controller: _anim,
                        index: 4,
                        child: GlowTextField(
                          controller: _phoneController,
                          label: 'رقم الهاتف',
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
                        controller: _anim,
                        index: 5,
                        child: GlowTextField(
                          controller: _emailController,
                          label: 'البريد الإلكتروني',
                          hint: "example@gmail.com",
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => null,
                        ),
                      ),
                      buildAnimatedField(
                        controller: _anim,
                        index: 6,
                        child: GlowTextField(
                          controller: _addressController,
                          label: 'العنوان',
                          hint: "أدخل العنوان",
                          icon: Icons.location_on_outlined,
                          validator: (v) => null,
                        ),
                      ),
                      buildAnimatedField(
                        controller: _anim,
                        index: 7,
                        child: GlowTextField(
                          controller: _notesController,
                          label: 'ملاحظة',
                          hint: "أدخل الملاحظة كاملة",
                          icon: Icons.note_alt_outlined,
                          validator: (v) => null,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<SpecModel>(
                        isExpanded: true,
                        style: TextStyle(
                          fontFamily: FontConstants.fontFamily1,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontFamily: FontConstants.fontFamily1, fontSize: 14),
                          hintStyle: TextStyle(fontFamily: FontConstants.fontFamily1, fontSize: 14),
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
                        hint: const Text("بدون اختصاص"),
                        items: _specialties
                            .map(
                              (s) => DropdownMenuItem<SpecModel>(
                                value: s,
                                child: Text(
                                  s.title ?? "",
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedSpecialty = v),
                      ),
                      const SizedBox(height: 20),
                      buildAnimatedField(
                        controller: _anim,
                        index: 8,
                        child: bottomAnimation(
                          context,
                          _submit,
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('حفظ'),
                              SizedBox(width: 10),
                              Icon(Icons.check_circle_outline),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final user = UserModel(
      _nameController.text.trim(),
      email.isEmpty ? null : email,
      phone.isEmpty ? '0900000000' : phone,
      _addressController.text.trim(),
      _selectedType,
      _notesController.text.trim(),
      spec: _selectedSpecialty,
      isUpload: 0,
      is_local_new: 1,
      is_modified: 0,
    );
    context.read<SyncBloc>().add(InsertEvent(user, markAttended: true));
  }
}
