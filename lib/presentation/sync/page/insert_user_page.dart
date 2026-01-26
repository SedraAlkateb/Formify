import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/text_field.dart';

class InsertUserPage extends StatefulWidget {
  const InsertUserPage({super.key});

  @override
  State<InsertUserPage> createState() => _InsertUserPageState();
}

class _InsertUserPageState extends State<InsertUserPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _submit() {
  //  if (_formKey.currentState!.validate()) {
      final user = UserSqlModel(
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        address: addressController.text,
        answerModel: [], // تُملأ لاحقًا
      );

      BlocProvider.of<SyncBloc>(context).add(InputUserSqlEvent(user));
      BlocProvider.of<SyncBloc>(context).add(GetSurveyAsyncEvent());
      debugPrint(user.toJson().toString());
      Navigator.pushReplacementNamed(context, Routes.listOfSurveys);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('تم حفظ البيانات بنجاح ✅')),
      // );
   // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(25),
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
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
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
                Text(
                  "معلومات الحضور",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "يرجى إدخال بياناتك للمتابعة إلى الاستبيانات",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorManager.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    GlowTextField(

                      controller: fullNameController,
                      label: 'الاسم الكامل',
                      icon: Icons.person_outline,
                      validator: (v) => v!.isEmpty ? 'الاسم مطلوب' : null,
                    ),
                    GlowTextField(
                      controller: emailController,
                      label: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v!.contains('@') ? null : 'إيميل غير صالح',
                    ),
                    GlowTextField(
                      controller: phoneController,
                      label: 'رقم الهاتف',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.length < 8 ? 'رقم غير صحيح' : null,
                    ),
                    GlowTextField(
                      controller: addressController,
                      label: 'العنوان',
                      icon: Icons.location_on_outlined,
                      validator: (v) => v!.isEmpty ? 'العنوان مطلوب' : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.arrow_forward),
                      iconAlignment:IconAlignment.end ,
                      label: const Text('متابعة الى الاستبيان'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        cursorColor: ColorManager.primary, // لون المؤشر

        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: ColorManager.white,

          prefixIcon: Icon(icon, color: Colors.grey.shade600),

          // قبل الفوكس
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.primary.withOpacity(0.4),
              width: 1.5,
            ),
          ),

          // أثناء الفوكس (يبقى Primary)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: ColorManager.primary,
              width: 2,
            ),
          ),

          // في حال الخطأ
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );

  }
}
