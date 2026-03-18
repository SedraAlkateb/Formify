import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/constants.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/breakpoints.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/values_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
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

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  late final AnimationController _controller;
  UserType _selectedUserType = UserType.other;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200), // مدة الحركة كاملة
    );
    _controller.forward(); // تشغيل الأنيميشن مباشرة
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final user = UserSqlModel(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        userType: userTypeFromId(_selectedUserType.id),
        answerModel: [], // تُملأ لاحقًا
      );

      BlocProvider.of<SyncBloc>(context).add(InputUserSqlEvent(user));
      BlocProvider.of<SyncBloc>(context).add(GetSurveyAsyncEvent());
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.listOfSurveys,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(
      context,
    ).size.height; // للحصول على ارتفاع الشاشة

    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (_, c) {
                  final isTabletPortrait = Breakpoints.isTabletPortrait(
                    context,
                  );
                  final isMobilePortrait = Breakpoints.isMobilePortrait(
                    context,
                  );
                  return Container(
                    height: (isTabletPortrait || isMobilePortrait)
                        ? screenHeight * 1.1
                        : null,
                    width: double.infinity,

                    margin: Constants.isTablet
                        ? EdgeInsets.all(50)
                        : EdgeInsets.only(
                            top: 50,
                            bottom: 50,
                            right: 25,
                            left: 25,
                          ),
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorManager.border),
                      color: ColorManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                      //.withOpacity(0.1),
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
                            buildAnimatedField(
                              controller: _controller,
                              index: 1,
                              child: Card(
                                margin: const EdgeInsets.all(5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                // elevation: 4,
                                color: ColorManager.primary,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(
                                    Icons.person_outline,
                                    color: Color(0xffffffff),
                                    size: 45,
                                  ),
                                ),
                              ),
                            ),
                            buildAnimatedField(
                              controller: _controller,
                              index: 1,
                              child: Text(
                                "معلومات الحضور",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorManager.primary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            buildAnimatedField(
                              controller: _controller,
                              index: 2,
                              child: Text(
                                "يرجى إدخال بياناتك للمتابعة إلى الاستبيانات",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: ColorManager.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            ListView(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              children: [
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 3,
                                  child: GlowTextField(
                                    hint: " ادخل اسمك الكامل ",
                                    label: 'الاسم الكامل',
                                    controller: fullNameController,

                                    icon: Icons.person_outline,
                                    validator: (v) =>
                                        v!.isEmpty ? 'الاسم مطلوب' : null,
                                  ),
                                ),
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 5,
                                  child: GlowTextField(
                                    controller: phoneController,
                                    label: 'رقم الهاتف *',
                                    hint: "09xxxxxxxx",
                                    icon: Icons.phone_outlined,
                                    keyboardType: TextInputType.phone,
                                    validator: (v) =>
                                        v!.length < 8 ? 'رقم غير صحيح' : null,
                                  ),
                                ),
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 4,
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
                                  index: 6,
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
                                  index: 6,
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
                                buildAnimatedField(
                                  controller: _controller,
                                  index: 7,
                                  child: bottomAnimation(
                                    context,
                                    _submit,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('متابعة الى الاستبيان'),
                                        SizedBox(width: 9),
                                        Icon(Icons.arrow_forward),
                                      ],
                                    ),
                                  ),
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
