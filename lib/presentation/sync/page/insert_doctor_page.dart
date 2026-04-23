import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';

// افترضت أن اسم البلوك SyncBloc واسم الموديل DoctorsModel
class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({super.key});

  @override
  State<AddDoctorPage> createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  // تعريف المتحكمات
  final _nameController = TextEditingController();
  final _regionController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _regionController.dispose();
    _descController.dispose();
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
            // عند النجاح
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("تمت إضافة الطبيب بنجاح"),
                backgroundColor: Colors.green,
              ),
            );
            // تحديث القائمة المحلية في الصفحة السابقة (اختياري حسب منطقك)
            // context.read<SyncBloc>().add(const GetLocalDoctorsEvent());
            Navigator.pop(context);
          } else if (state is InsertDoctorErrorState) {
            // عند الخطأ
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
                  // حقل الاسم
                  _buildTextField(
                    controller: _nameController,
                    label: "اسم الدكتور *",
                    hint: "مثال: د. محمد علي",
                    icon: Icons.person_add_alt_1_outlined,
                    validator: (v) => v!.isEmpty ? "الرجاء إدخال اسم الدكتور" : null,
                  ),
                  const SizedBox(height: 16),

                  // حقل المنطقة
                  _buildTextField(
                    controller: _regionController,
                    label: "المنطقة *",
                    hint: "مثال: حلب، دمشق...",
                    icon: Icons.map_outlined,
                    validator: (v) => v!.isEmpty ? "الرجاء إدخال المنطقة" : null,
                  ),
                  const SizedBox(height: 16),

                  // حقل الوصف
                  _buildTextField(
                    controller: _descController,
                    label: "ملاحظات / وصف",
                    hint: "أخصائي عينية، مشفى الجامعة...",
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),

                  // زر الإرسال
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is InsertDoctorLoadingState
                          ? null // تعطيل الزر أثناء التحميل
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
      final doctor = DoctorsModel(
        _nameController.text.trim(),
        _regionController.text.trim(),
        _descController.text.trim(),
      );

      // استدعاء البلوك
      context.read<SyncBloc>().add(InsertEvent( doctor));
    }
  }
}