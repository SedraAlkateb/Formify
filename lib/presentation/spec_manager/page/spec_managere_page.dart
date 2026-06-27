import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/spec_manager/bloc/spec_manager_bloc.dart';

class SpecManagementPage extends StatefulWidget {
  const SpecManagementPage({super.key});

  @override
  State<SpecManagementPage> createState() => _SpecManagementPageState();
}

class _SpecManagementPageState extends State<SpecManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _specTitleController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void initState() {
    context.read<SpecManagerBloc>().add(GetAllSpecsEvent());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _specTitleController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF1E293B),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF475569),
                    size: 20,
                  ),
                  onPressed: () {
                    context.read<SpecManagerBloc>().add(GetAllSpecsEvent());
                  },
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      SizedBox(height: 16.h),
                      _buildKpiAndAddSection(context),
                      SizedBox(height: 20.h),
                      _buildSearchField(),
                      SizedBox(height: 24.h),
                      _buildListTitle(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),

                BlocBuilder<SpecManagerBloc, SpecManagerState>(
                  builder: (context, state) {
                    if (state is GetAllSpecLoadingState ||
                        state is SpecManagerInitial) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      );
                    }

                    if (state is GetAllSpecErrorState) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFEF4444),
                                size: 48,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                state.failure.massage ??
                                    "حدث خطأ غير متوقع أثناء تحميل البيانات",
                                style: const TextStyle(
                                  color: Color(0xFF475569),
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is GetAllSpecEmptyState) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.folder_open_rounded,
                                color: Color(0xFF94A3B8),
                                size: 48,
                              ),
                              SizedBox(height: 8.h),
                              const Text(
                                "لا توجد اختصاصات طبية مسجلة حالياً",
                                style: TextStyle(
                                  color: Color(0xFF64748B),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state is GetAllSpecState) {
                      final filteredSpecs = state.allSpec.where((spec) {
                        final title = spec.title?.toLowerCase() ?? '';
                        final search = state.searchText.toLowerCase();
                        return title.contains(search);
                      }).toList();

                      if (filteredSpecs.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Text(
                              "لم نجد أي اختصاص يطابق بحثك",
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final spec = filteredSpecs[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: _buildSpecCard(context, spec),
                          );
                        }, childCount: filteredSpecs.length),
                      );
                    }

                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.gavel_rounded, color: Color(0xFF7C3AED), size: 28),
            SizedBox(width: 8.w),
            const Text(
              "إدارة الاختصاصات الطبية",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        const Text(
          "إضافة وتعديل الاختصاصات المتاحة للأطباء والمستخدمين في النظام",
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildKpiAndAddSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: Color(0xFF7C3AED),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<SpecManagerBloc, SpecManagerState>(
                        builder: (context, state) {
                          int count = 0;
                          if (state is GetAllSpecState) {
                            count = state.allSpec.length;
                          }
                          return Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          );
                        },
                      ),
                      const Text(
                        "إجمالي الاختصاصات",
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 5,
          child: ElevatedButton.icon(
            onPressed: () => _showSpecDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              minimumSize: Size(double.infinity, 52.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            label: const Text(
              "إضافة اختصاص",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: _searchController,
        onChanged: (value) {
          _searchDebounce?.cancel();
          _searchDebounce = Timer(const Duration(milliseconds: 300), () {
            // context.read<SpecManagerBloc>().add(SearchSpecsEvent(value));
          });
        },
        decoration: InputDecoration(
          hintText: "ابحث عن اختصاص معين...",
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF94A3B8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildListTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "قائمة الاختصاصات الحالية",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecCard(BuildContext context, SpecModel spec) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            alignment: Alignment.center,
            child: Text(
              "#${spec.id ?? ''}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              spec.title ?? "بدون اسم",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Row(
            children: [
              _buildActionCardButton(
                Icons.edit_outlined,
                const Color(0xFF475569),
                () => _showSpecDialog(context, spec: spec),
              ),
              SizedBox(width: 6.w),
              _buildActionCardButton(
                Icons.delete_outline_rounded,
                const Color(0xFFEF4444),
                () => _showDeleteConfirmation(context, spec),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCardButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }

  void _showSpecDialog(BuildContext context, {SpecModel? spec}) {
    final bool isEdit = spec != null;
    _specTitleController.text = isEdit ? (spec.title ?? "") : "";

    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: Text(
            isEdit ? "تعديل الاختصاص" : "إضافة اختصاص جديد",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _specTitleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "أدخل اسم الاختصاص (مثال: العظام)",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "إلغاء",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final String textResult = _specTitleController.text.trim();
                if (textResult.isNotEmpty) {
                  // استخراج الـ Bloc والـ State الحالي قبل إغلاق الـ Dialog
                  final bloc = context.read<SpecManagerBloc>();
                  final currentState = bloc.state;

                  List<SpecModel> currentList = [];
                  if (currentState is GetAllSpecState) {
                    currentList = currentState.allSpec;
                  }

                  if (isEdit) {
                    // في حال التعديل: تمرير الاسم الجديد، المعرف، والقائمة الكاملة للـ Bloc
                    // bloc.add(UpdateSpecEvent(
                    //   spec: SpecModel(id: spec.id, title: textResult),
                    //   currentSpecs: currentList,
                    // ));
                  } else {
                    // في حال الإضافة: تمرير الاسم الجديد مع القائمة الحالية (List<SpecModel>)
                    bloc.add(CreateSpecEvent(textResult, currentList));
                  }
                  Navigator.pop(dialogContext);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                isEdit ? "تعديل" : "إضافة",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SpecModel spec) {
    showDialog(
      context: context,
      builder: (dialogContext) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: const Text(
            "تأكيد الحذف",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "هل أنت متأكد من رغبتك في حذف اختصاص (${spec.title})؟ لا يمكن التراجع عن هذا الإجراء.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "إلغاء",
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final bloc = context.read<SpecManagerBloc>();
                final currentState = bloc.state;

                // if (currentState is GetAllSpecState && spec.id != null) {
                //   bloc.add(DeleteSpecEvent(
                //     id: spec.id!,
                //     currentSpecs: currentState.allSpec,
                //   ));
                // }
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: const Text("حذف", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
