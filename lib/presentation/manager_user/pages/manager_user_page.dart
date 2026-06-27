import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/domain/models/user_type.dart';
import 'package:formify/presentation/manager_user/bloc/manager_user_bloc.dart';
import 'package:formify/presentation/manager_user/pages/edit_user_m_page.dart';
import 'package:formify/presentation/offline_sync/bloc/offline_sync_bloc.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/unit/drop_down_new.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class ManagerUserPage extends StatefulWidget {
  const ManagerUserPage({super.key});

  @override
  State<ManagerUserPage> createState() => _ManagerUserPageState();
}

class _ManagerUserPageState extends State<ManagerUserPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<ManagerUserBloc>().add(GetAllUsersEvent());
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }
  Timer? _searchDebounce;
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
          // إدخال الأزرار التفاعلية في جهة اليسار (الـ actions)
          actions: [
            BlocListener<OfflineSyncBloc, OfflineSyncState>(
              listener: (context, state) {
                // 1. عند نجاح الإضافة والتعديل المحلي -> نقوم برفع المستخدمين للسيرفر مباشرة
                if (state is AddAndModifyUserSucState) {
                  context.read<OfflineSyncBloc>().add(
                    UploadUserEvent(state.users),
                  );
                }
                if(state is SyncLoadingState){
                  loading(context);
                }
                else if(state is DataOfflineErrorState){
                  error(context, state.failure.massage, state.failure.code);
                }
                // 2. عند نجاح الرفع على السيرفر -> نقوم بتحديث الـ IDs المحلية بناءً على رد السيرفر
                else if (state is UploadUserSucState) {
                  context.read<OfflineSyncBloc>().add(
                    UpdateUserIdEvent(state.users),
                  );
                }
                // 3. المرحلة النهائية: نجاح العملية بالكامل وتحديث المعطيات محلياً وسحابياً
                else if (state is UpdateIdUserSucState) {
                  // إعادة تصفير حالة التعديلات أو الفلاتر في لوحة التحكم الرئيسية
                  context.read<ManagerUserBloc>().add(ResetUsersFiltersEvent());
                  success(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.white),
                          SizedBox(width: 8),
                          Text("تمت المزامنة وتحديث البيانات بنجاح"),
                        ],
                      ),
                      backgroundColor: Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9), // خلفية رمادية ناعمة ومريحة للعين
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0), // حد خارجي خفيف لإبراز الزر
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        // عند الضغط على الزر يتم إطلاق أول حلقة في سلسلة المزامنة فوراً
                        context.read<OfflineSyncBloc>().add(
                          const AddAndModifyUserEvent(-9, 0),
                        );
                      },
                      child: const Center(
                        child: Icon(
                          Icons.sync_rounded, // تم تغيير الأيقونة إلى المزامنة لتعبّر بدقة عن وظيفة الزر الجديدة البرمجية
                          color: Color(0xFF475569),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
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
                      _buildKpiGrid(context),
                      SizedBox(height: 20.h),
                      _buildAdvancedFilters(context),
                      SizedBox(height: 24.h),
                      _buildListTitle(),
                      SizedBox(height: 12.h),
                    ],
                  ),
                ),

                BlocBuilder<ManagerUserBloc, ManagerUserState>(
                  builder: (context, state) {
                    if (state is GetAllUsersState) {
                      if (state.filteredUsers.isEmpty) {
                        return SliverToBoxAdapter(
                          child: emptyFullScreen(context),
                        );
                      }

                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final user = state.filteredUsers[index];

                            final String firstLetter =
                            user.fullName.isNotEmpty
                                ? user.fullName.trim().substring(0, 1)
                                : "؟";

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _buildUserCard(
                                context: context,
                                index: (index + 1).toString(),
                                letter: firstLetter,
                                user:user ,
                             //   time: "سجل في: ٢٠٢٦/٦/١٣ ١١:٣٣ ص",
                                isPresent: false,
                                specs:state.specialities
                              ),
                            );
                          },
                          childCount: state.filteredUsers.length,
                        ),
                      );
                    }

                    if (state is GetAllUsersEmptyState) {
                      return SliverToBoxAdapter(
                        child: emptyFullScreen(context),
                      );
                    }

                    if (state is GetAllUsersLoadingState) {
                      return SliverToBoxAdapter(
                        child: loadingFullScreen(context),
                      );
                    }

                    if (state is GetAllUsersErrorState) {
                      return SliverToBoxAdapter(
                        child: errorFullScreen(context),
                      );
                    }

                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
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
            const Icon(
              Icons.people_alt_outlined,
              color: Color(0xFF7C3AED),
              size: 28,
            ),
            SizedBox(width: 8.w),
            const Text(
              "إدارة مستخدمي النظام",
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
          "التحكم بالبيانات، الفلترة المتقدمة، وتعديل وتصدير معلومات الحضور",
          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildKpiGrid(BuildContext context) {
    return BlocBuilder<ManagerUserBloc, ManagerUserState>(
      builder: (context, state) {
        // حساب الأعداد بناءً على الحالة الحالية للـ Bloc
        final total = state is GetAllUsersState ? state.allUsers.length : 0;
        final filtered = state is GetAllUsersState ? state.filteredUsers.length : 0;

        // جلب قائمة الاختصاصات من الـ state إذا كانت متوفرة، وإلا نمرر قائمة فارغة لحماية التطبيق من الكراش
        final List<SpecModel> currentSpecialities = state is GetAllUsersState ? state.specialities : [];

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildKpiItem(
                    title: "المسجلون الكلي",
                    value: total.toString(),
                    icon: Icons.people_outline_rounded,
                    iconBgColor: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF7C3AED),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildKpiItem(
                    title: "المطابق للفلاتر",
                    value: filtered.toString(),
                    icon: Icons.tune_rounded,
                    iconBgColor: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFB45309),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // زر إضافة مستخدم جديد
            ElevatedButton.icon(
              onPressed: () {
                // تمرير قائمة الاختصاصات المستقرة مباشرة لصفحة الإضافة
                Navigator.pushNamed(
                  context,
                  Routes.insertMDoctor,
                  arguments: currentSpecialities, // تم استبدال state.sp بالقائمة المضمونة علوياً
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "إضافة مستخدم جديد",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildKpiItem({
    required String title,
    required String value,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFilters(BuildContext context) {
    return BlocBuilder<ManagerUserBloc, ManagerUserState>(
      builder: (context, state) {
        if (state is! GetAllUsersState) {
          return const SizedBox.shrink();
        }

        if (_searchController.text != state.searchText) {
          _searchController.text = state.searchText;
          _searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: _searchController.text.length),
          );
        }

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          color: Color(0xFF8B5CF6),
                          size: 20,
                        ),
                        SizedBox(width: 6.w),
                        const Expanded(
                          child: Text(
                            "خيارات البحث والفلترة المتقدمة",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _searchController.clear();
                      context
                          .read<ManagerUserBloc>()
                          .add(ResetUsersFiltersEvent());
                    },
                    icon: const Icon(
                      Icons.refresh_rounded,
                      size: 16,
                      color: Color(0xFF64748B),
                    ),
                    label: const Text(
                      "إعادة تعيين الفلاتر",
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              TextFormField(
                controller: _searchController,
                onChanged: (value) {
                  _searchDebounce?.cancel();

                  _searchDebounce = Timer(
                    const Duration(milliseconds: 350),
                        () {
                      context.read<ManagerUserBloc>().add(SearchUsersEvent(value));
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: "البحث السريع بـ الاسم، الهاتف، الـ ID",
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF94A3B8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              CustomFilterDropdown<SpecModel>(
                label: "تصفية حسب الاختصاص",
                icon: Icons.filter_alt_outlined,
                value: state.selectedSpeciality,
                items: state.specialities,
                itemAsString: (spec) => spec.title ?? "غير محدد",
                onChanged: (SpecModel? value) {
                  context.read<ManagerUserBloc>().add(
                    FilterBySpecialityEvent(value),
                  );
                },
              ),

              SizedBox(height: 12.h),

              CustomFilterDropdown<String>(
                label: "تصفية حسب المنطقة",
                icon: Icons.location_on_outlined,
                value: state.selectedArea,
                items: state.areas,
                itemAsString: (area) => area,
                onChanged: (String? value) {
                  context.read<ManagerUserBloc>().add(
                    FilterByAreaEvent(value),
                  );
                },
              ),

              SizedBox(height: 12.h),

              CustomFilterDropdown<UserType>(
                label: "نوع المستخدم",
                icon: Icons.person_search_outlined,
                value: state.selectedUserType,
                items: UserType.values,
                itemAsString: (type) => type.nameAr,
                onChanged: (UserType? value) {
                  context.read<ManagerUserBloc>().add(
                    FilterByUserTypeEvent(value ?? UserType.all),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTitle() {
    return BlocBuilder<ManagerUserBloc, ManagerUserState>(
      builder: (context, state) {
        final total = state is GetAllUsersState ? state.allUsers.length : 0;
        final filtered =
        state is GetAllUsersState ? state.filteredUsers.length : 0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "جدول المسجلين النشطين",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "تم عرض $filtered مستخدم من أصل $total",
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Text(
                "تعديل حي وتفاعلي",
                style: TextStyle(
                  color: Color(0xFF475569),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserCard({
    required BuildContext context,
    required String index,
    required String letter,
 //   required String time,
    required bool isPresent,
    required UserModel user,
    required List<SpecModel> specs
  }) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F5FF),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Color(0xFF334155),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          index,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              user.userType.nameAr,
                              style: const TextStyle(
                                color: Color(0xFF0369A1),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      _buildInfoRow(Icons.phone_outlined, user.phone),
                      _buildInfoRow(Icons.mail_outline_rounded, user.email??""),
                      _buildInfoRow(Icons.location_on_outlined, user.address??""),
                      _buildInfoRow(Icons.note_outlined, user.notes??""),

                      SizedBox(height: 6.h),
                      Text(
                        "اختصاص ${user.spec?.title??""}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8FDF0),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: const Color(0xFFBFF6D4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.assignment_turned_in_outlined,
                          color: Color(0xFF15803D),
                          size: 16,
                        ),
                        SizedBox(width: 4.w),
                        const Flexible(
                          child: Text(
                            "أكمل الاستبيانات",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFF15803D),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                _buildActionButton(Icons.edit_outlined, const Color(0xFF64748B),() {
                 Navigator.push(context, MaterialPageRoute(builder: (context) =>
                     EditUserMPage(userModel: user, specs: specs),));
                  },),
                SizedBox(width: 4.w),
                _buildActionButton(Icons.person_outline_rounded, const Color(0xFF64748B),() {

                }),
                SizedBox(width: 4.w),
                _buildActionButton(Icons.delete_outline_rounded, const Color(0xFFEF4444),() {

                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 3.h),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _showSettingsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "إعدادات لوحة المستخدمين",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                SizedBox(height: 16.h),
                ListTile(
                  leading: const Icon(Icons.file_download_outlined, color: Color(0xFF7C3AED)),
                  title: const Text("تصدير قائمة الحضور لملف Excel"),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha_rounded, color: Color(0xFF7C3AED)),
                  title: const Text("ترتيب أبجدي حسب أسماء الأطباء"),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildActionButton(IconData icon, Color color,void Function()? onTap) {
    return InkWell(
      onTap: onTap,
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
}