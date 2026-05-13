import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/autocomplete.dart';
import 'package:formify/presentation/unit/animation/animation-in_list.dart';
import 'package:formify/presentation/unit/animation/buttom_animation.dart';
import 'package:formify/presentation/unit/drop_down_field.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/unit/text_field.dart';

class EditUserPage extends StatefulWidget {
  final UserModel userModel;

  const EditUserPage({super.key, required this.userModel});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _doctorFocusNode = FocusNode();
  // وحدات التحكم بالنصوص
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController addressController;
  late final TextEditingController noteController;

  late final AnimationController _controller;
  late UserType _selectedUserType;

  @override
  void initState() {
    super.initState();
    // 1. تهيئة المتحكمات بالقيم القادمة من الـ userModel
    fullNameController = TextEditingController(text: widget.userModel.fullName);
    emailController = TextEditingController(text: widget.userModel.email ?? "");
    phoneController = TextEditingController(text: widget.userModel.phone);
    addressController = TextEditingController(text: widget.userModel.address ?? "");
    noteController = TextEditingController(text: widget.userModel.notes ?? "");

    // 2. تهيئة نوع المستخدم
    _selectedUserType = widget.userModel.userType;

    // 3. تهيئة الأنيميشن
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }
  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserModel(
     id:   widget.userModel.id,
         fullNameController.text,
         emailController.text,
        phoneController.text,
        addressController.text,
       userTypeFromId(_selectedUserType.id),
         noteController.text,
      );

      BlocProvider.of<SyncBloc>(context).add(EditUserEvent(user));
    }
  }
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    noteController.dispose();
    _controller.dispose();
    _doctorFocusNode.dispose(); // تدمير الـ node عند الخروج

    super.dispose();
  }

  void _updateSubmit() {
    if (_formKey.currentState!.validate()) {
      // بناء كائن المستخدم المعدل مع الحفاظ على الـ ID القديم
      final updatedUser = widget.userModel.copyWith(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        notes: noteController.text,
        userType: _selectedUserType,
      );

      // إرسال حدث التعديل إلى الـ Bloc (افترضنا وجود حدث اسمه UpdateUserSqlEvent)
      // BlocProvider.of<SyncBloc>(context).add(UpdateUserSqlEvent(updatedUser));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary, // الحفاظ على نفس هوية صفحة الإدخال
      appBar: AppBar(
        title: const Text("تعديل البيانات"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (_, c) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // أيقونة المستخدم العلوية
                            buildAnimatedField(
                              controller: _controller,
                              index: 1,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: ColorManager.primary.withOpacity(0.1),
                                child: Icon(Icons.edit_note_rounded,
                                    size: 40, color: ColorManager.primary),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                DoctorAutocompleteField(
                                  allDoctors: context.read<SyncBloc>().doctor,
                                  controller: fullNameController,
                                  focusNode:
                                  _doctorFocusNode, // تمريره هنا يحل المشكلة
                                  index: 4,
                                  animationController: _controller,
                                  buildAnimatedField: buildAnimatedField,
                                  onSelected: (doctor) {
                                    context.read<SyncBloc>().add(
                                      SelectDoctorEvent(doctor),
                                    );
                                    fullNameController.text = doctor.fullName;
                                    addressController.text = doctor.address??"";
                                    noteController.text = doctor.notes??"";
                                    _doctorFocusNode
                                        .unfocus(); // إغلاق الكيبورد بعد الاختيار
                                  },
                                ),

                                // نصيحة إضافية لحل الـ Overflow:
                                // في الـ Container الأساسي، اجعلي الارتفاع هكذا:
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 5,
                                  child: GlowTextField(
                                    controller: phoneController,
                                    label: 'رقم الهاتف *',
                                    hint: "09xxxxxxxx",
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) {
                                      // 1. إذا كان الحقل فارغاً تماماً أو يحتوي مسافات فقط
                                      if (v == null || v.trim().isEmpty) {
                                        return null; // مقبول لأنه ليس إجبارياً
                                      }

                                      // 2. إذا كتب المستخدم رقماً، نتحقق من الطول
                                      if (v.trim().length < 8) {
                                        return 'الرقم قصير جداً، يجب أن يكون 8 أرقام على الأقل';
                                      }

                                      return null; // مقبول إذا تجاوز الشرط
                                    },
                                  ),
                                ),
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 6,
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
                                  index: 7,
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
                                  index: 8,
                                  child: GlowTextField(
                                    controller: noteController,
                                    label: 'ملاحظة',
                                    hint: "أدخل الملاحظة كاملة",
                                    icon: Icons.location_on_outlined,
                                    validator: (v) => null,
                                  ),
                                ),
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 9,
                                  child: DropDownField(
                                    label: 'نوع الحضور',
                                    hint: 'اختر نوع الحضور',
                                    icon: Icons.category_outlined,
                                    value: _selectedUserType,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedUserType =
                                            value ?? UserType.other;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'يرجى اختيار نوع الحضور';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                SizedBox(height: AppSize.s20),
                                BlocConsumer<SyncBloc, SyncState>(
                                  listener: (context, state) {
                                    if (state is EditUserState) {
                                      Navigator.pop(context);
                                    } else if (state
                                    is EditUserErrorState) {
                                error(context, state.failure.massage, state.failure.code);
                                    }
                                  },
                                  builder: (context, state) {

                                    return    buildAnimatedField(
                                      controller: _controller,
                                      index: 7,
                                      child: bottomAnimation(
                                        context,
                                        _submit,
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('حفظ التعديلات'),
                                            SizedBox(width: 10),
                                            Icon(Icons.check_circle_outline),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
}