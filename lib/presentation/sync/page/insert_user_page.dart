import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

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
    if (_formKey.currentState!.validate()) {
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


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معلومات المستخدم'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: fullNameController,
                label: 'الاسم الكامل',
                icon: Icons.person,
                validator: (v) =>
                v!.isEmpty ? 'الاسم مطلوب' : null,
              ),
              _buildTextField(
                controller: emailController,
                label: 'البريد الإلكتروني',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                v!.contains('@') ? null : 'إيميل غير صالح',
              ),
              _buildTextField(
                controller: phoneController,
                label: 'رقم الهاتف',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) =>
                v!.length < 8 ? 'رقم غير صحيح' : null,
              ),
              _buildTextField(
                controller: addressController,
                label: 'العنوان',
                icon: Icons.location_on,
                validator: (v) =>
                v!.isEmpty ? 'العنوان مطلوب' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('حفظ'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
