import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/presentation/onboarding/bloc/onboarding_bloc.dart';
import 'package:formify/presentation/resources/assets_manager.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/responsive/sizer_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/animation/buttom_animation.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';
import 'package:formify/presentation/unit/text_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.firstScreenBackground2,
                ColorManager.firstScreenBackground1,
                ColorManager.firstScreenBackground1,
              ],
            ),
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 40.sp,
                      horizontal: 25.sp,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        left: 20.sp,
                        right: 20.sp,
                        bottom: 40.sp,
                      ),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageAssets.login,
                            color: ColorManager.primary,
                            height: 250,
                            width: 250,
                          ),
                          Text(
                            "مرجباً بك مجدداً",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: ColorManager.primary,
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 35,
                                tablet: 41,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.sp),
                          Text(
                            "قم بتسجيل الدخول للوصول إلى لوحة التحكم",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorManager.black,
                              fontSize: FontResponsive.font(
                                context,
                                mobile: 15,
                                tablet: 21,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ),

                          SizedBox(height: 60.sp),
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: LoginTextField(
                              hint: " ادخل اسم المستخدم ",
                              label: 'اسم المستخدم',
                              controller: userNameController,

                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v!.isEmpty ? 'الاسم مطلوب' : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                              right: 12,
                            ),
                            child: LoginTextField(
                              hint: " ادخل كلمة السر ",
                              keyboardType: TextInputType.visiblePassword,
                              label: 'كلمة السر',
                              controller: passwordController,
                              isObscure: true,
                              icon: Icons.password,
                              validator: (v) =>
                                  v!.isEmpty ? ' كلمة السر مطلوب' : null,
                            ),
                          ),
                          BlocListener<OnboardingBloc, OnboardingState>(
                            listener: (context, state) {
                              if (state is LoginErrorState) {
                                error(
                                  context,
                                  state.failure.massage,
                                  state.failure.code,
                                );
                              } else if (state is LoginLoadingState) {
                                loading(context);
                              } else if (state is LoginSuccessState) {
                                success(context);
                                instance<AppPreferences>().setPassword(
                                  passwordController.text,
                                );
                                instance<AppPreferences>().setLoggedIn(1);
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed(Routes.home);
                              }
                            },
                            child: bottomAnimation(
                              context,
                              () {
                                if (_formKey.currentState!.validate()) {
                                  BlocProvider.of<OnboardingBloc>(context).add(
                                    LoginRequestEvent(
                                      userNameController.text,
                                      passwordController.text,
                                    ),
                                  );
                                }
                              },
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('تسجيل الدخول'),
                                  SizedBox(width: 9),
                                  Icon(Icons.arrow_forward),
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
        ),
      ),
    );
  }
}
