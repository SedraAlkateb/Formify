import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/widget/autocomplete.dart';
import 'package:formify/presentation/unit/animation/animation-in_list.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class DoctorFilterCard extends StatefulWidget {
  final List<SpecModel> specialties;
  final SpecModel? selectedSpecialty;
  final TextEditingController specialtySearchController;
  final TextEditingController importantDoctorSearchController;
  final FocusNode anyDoctorFocusNode;
  final FocusNode importantDoctorFocusNode;
  final AnimationController animationController;
  final Function(UserModel) onDoctorSelected;

  const DoctorFilterCard({
    Key? key,
    required this.specialties,
    required this.selectedSpecialty,
    required this.specialtySearchController,
    required this.importantDoctorSearchController,
    required this.anyDoctorFocusNode,
    required this.importantDoctorFocusNode,
    required this.animationController,
    required this.onDoctorSelected,
  }) : super(key: key);

  @override
  State<DoctorFilterCard> createState() => _DoctorFilterCardState();
}

class _DoctorFilterCardState extends State<DoctorFilterCard> {
  bool _isFilterExpanded = false;
  SpecModel? _currentSpecialty;

  @override
  void initState() {
    super.initState();
    _currentSpecialty = widget.selectedSpecialty;
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedField(
      controller: widget.animationController,
      index: 3,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.person_search_outlined,
                color: ColorManager.primary,
              ),
              title: const Text(
                "البحث السريع والتصفية المتقدمة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              subtitle: Text(
                _isFilterExpanded
                    ? "اضغط لإخفاء أدوات البحث"
                    : "اضغط للبحث عن طبيب محدد واختياره",
                style: const TextStyle(fontSize: 12),
              ),
              trailing: Icon(
                _isFilterExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: ColorManager.primary,
              ),
              onTap: () {
                setState(() {
                  _isFilterExpanded = !_isFilterExpanded;
                });
              },
            ),
            if (_isFilterExpanded)
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 16),
                child: Column(
                  children: [
                    const Divider(),
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
                      value: _currentSpecialty,
                      hint: const Text("كل الاختصاصات"),
                      items: widget.specialties.map((specialty) {
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
                          _currentSpecialty = value;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<SyncBloc, SyncState>(
                      buildWhen: (previous, current) =>
                          current is UserFilterState ||
                          current is DataErrorState,
                      builder: (context, state) {
                        List<UserModel> users = [];
                        if (state is DataErrorState)
                          return errorFullScreen(context);
                        if (state is UserFilterState) users = state.data;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DoctorAutocompleteField(
                                // ✨ هنا التعديل السحري: تمرير Key ديناميكي يعتمد على طول المصفوفة
                                // ليجبر الحقل على التحديث الفوري وإظهار لستة الأسماء مباشرة تحت الحقل
                                key: ValueKey("doctors_count_${users.length}"),
                                lable: "اسم الطبيب",
                                allDoctors: users,
                                controller: widget.specialtySearchController,
                                focusNode: widget.anyDoctorFocusNode,
                                index: 4,
                                animationController: widget.animationController,
                                buildAnimatedField: buildAnimatedField,
                                onSelected: widget.onDoctorSelected,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // زر البحث
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: IconButton(
                                onPressed: () {
                                  BlocProvider.of<SyncBloc>(context).add(
                                    FilterDoctorBySpecAndNameEvent(
                                      widget.specialtySearchController.text,
                                      _currentSpecialty == null
                                          ? -1
                                          : _currentSpecialty!.id??0,
                                    ),
                                  );
                                  // طلب التركيز على الحقل لضمان فتح قائمة الخيارات المنبثقة
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(widget.anyDoctorFocusNode);
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: ColorManager.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.search_sharp, size: 22),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),

                    // 3️⃣ الحقل الثاني للأطباء المهمين
                    Row(
                      children: [
                        Expanded(
                          child: DoctorAutocompleteField(
                            lable: "اسم طبيب مهم",
                            allDoctors: context.read<SyncBloc>().doctor,
                            controller: widget.importantDoctorSearchController,
                            focusNode: widget.importantDoctorFocusNode,
                            index: 5,
                            animationController: widget.animationController,
                            buildAnimatedField: buildAnimatedField,
                            onSelected: widget.onDoctorSelected,
                          ),
                        ),
                        const SizedBox(width: 8),

                        // زر البحث
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                            // ✨ التعديل: تغيير الأيقونة لتصبح على شكل حرف X ناعم ومقوس الحواف
                            icon: const Icon(Icons.close_rounded, size: 22),
                            style: IconButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              // 1️⃣ تصفير الطبيب المحدد داخل كتل إدارة الحالة SyncBloc
                              BlocProvider.of<SyncBloc>(
                                context,
                              ).selectedDoctor = null;

                              // 2️⃣ إظهار رسالة التنبيه (SnackBar) باللون الأخضر أسفل الشاشة
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  // تعيين الخلفية باللون الأخضر للتعبير عن نجاح الإلغاء
                                  backgroundColor: Colors.green,
                                  // جعل السناك بار عائماً ومقوس الحواف بشكل عصري
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  // محتوى السناك بار: صف يحتوي على أيقونة تأكيد ونص توضيحي
                                  content: const     Icon(
                                    Icons.cancel_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  // مدة بقاء التنبيه على الشاشة (ثانيتين ثم يختفي تلقائياً)
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
