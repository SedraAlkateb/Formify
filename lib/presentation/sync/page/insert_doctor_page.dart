import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/text_field.dart'; // تأكد من صحة مسار GlowTextField

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  // تعريف المتحكمات الكاملة للحقول
  final _nameController = TextEditingController();
  final _regionController = TextEditingController(); // تم ربطه بحقل العنوان/المنطقة
  final _descController = TextEditingController();   // الملاحظات أو الوصف
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  UserType _selectedUserType = UserType.importantDoctor; // القيمة الافتراضية لطبيب
  SpecModel? _selectedSpecialty;
  List<SpecModel> _specialties = [];

  @override
  void initState() {
    super.initState();
    // جلب قائمة الاختصاصات الطبية المتاحة من البلوك عند تهيئة الصفحة
    _specialties = BlocProvider.of<SyncBloc>(context).spec;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _descController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة طبيب جديد"),
        centerTitle: true,
      ),
      body: BlocConsumer<SyncBloc, SyncState>(
        listener: (context, state) {
          if (state is InsertDoctorSucState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت إضافة الطبيب بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is InsertDoctorErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("خطأ: ${state.failure.massage}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),

                  // 1️⃣ حقل اسم الدكتور الكامل
                  GlowTextField(
                    controller: _nameController,
                    label: 'اسم الدكتور *',
                    hint: "مثال: د. محمد علي",
                    icon: Icons.badge_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'الرجاء إدخال اسم الدكتور';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2️⃣ حقل رقم الهاتف
                  GlowTextField(
                    controller: _phoneController,
                    label: 'رقم الهاتف *',
                    hint: "09xxxxxxxx",
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'يرجى إدخال رقم الهاتف';
                      }
                      if (v.trim().length < 8) {
                        return 'الرقم قصير جداً، يجب أن يكون 8 أرقام على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // 3️⃣ حقل البريد الإلكتروني
                  GlowTextField(
                    controller: _emailController,
                    hint: "example@gmail.com",
                    label: 'البريد الإلكتروني',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // 4️⃣ حقل المنطقة / العنوان
                  GlowTextField(
                    controller: _regionController,
                    label: "المنطقة / العنوان *",
                    hint: "مثال: حلب، دمشق...",
                    icon: Icons.location_on_outlined,
                    validator: (v) => v!.isEmpty ? "الرجاء إدخال المنطقة" : null,
                  ),
                  const SizedBox(height: 16),

                  // 5️⃣ منسدلة الاختصاصات الطبية
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
                      fillColor: Colors.grey[50],
                    ),
                    value: _selectedSpecialty,
                    hint: const Text("كل الاختصاصات"),
                    items: _specialties.map((specialty) {
                      return DropdownMenuItem<SpecModel>(
                        value: specialty,
                        child: Text(
                          specialty.title ?? "",
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
                  const SizedBox(height: 16),
                  // 7️⃣ حقل الملاحظات / الوصف
                  _buildTextField(
                    controller: _descController,
                    label: "ملاحظات / وصف",
                    hint: "أخصائي عينية، مشفى الجامعة...",
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),


                  // زر حفظ الطبيب
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is InsertDoctorLoadingState
                          ? null
                          : _submitData,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is InsertDoctorLoadingState
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "حفظ الطبيب",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة مساعدة لبناء الحقول لتوفير تكرار الكود
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // بناء موديل البيانات بجميع القيم المضافة حديثاً من الحقول
      final doctor = UserModel(
        _nameController.text.trim(),
        _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        _phoneController.text.trim(),
        _regionController.text.trim(),
        UserType.importantDoctor,
        _descController.text.trim(),
        spec: _selectedSpecialty,
        isUpload: 0,
        is_local_new: 1,
        is_modified: 0,
      );

      // إرسال الإيفينت للبلوك الخاص بـ SyncBloc
      context.read<SyncBloc>().add(InsertEvent(doctor));
    }
  }
}