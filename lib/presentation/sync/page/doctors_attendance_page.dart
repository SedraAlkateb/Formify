import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/sync/cubit/cubit_attendance.dart';
import 'package:formify/presentation/sync/cubit/cubit_attendance_state.dart';
import 'package:formify/presentation/sync/widget/gialog_add_password.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';


class DoctorsBySpsPage extends StatefulWidget {

  const DoctorsBySpsPage({super.key});
  @override
  State<DoctorsBySpsPage> createState() => _DoctorsBySpsPageState();
}

class _DoctorsBySpsPageState extends State<DoctorsBySpsPage> {

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SyncBloc>(context).add(GetDoctorBySpsEvent());
    // قائمة الاختصاصات تلزم لصفحة إضافة طبيب جديد
    BlocProvider.of<SyncBloc>(context).add(SpecEvent());
    instance<AppPreferences>().setLoggedIn(4);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  void _logoutFromConference() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "تسجيل الخروج",
          textAlign: TextAlign.right,
          style: TextStyle(color: ColorManager.primary, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "هل أنت متأكد من تسجيل الخروج من هذا المؤتمر؟",
          textAlign: TextAlign.right,
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("إلغاء", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              instance<AppPreferences>().setLoggedIn(1);
              Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
            },
            child: const Text("خروج", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: ColorManager.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.person_add_alt_1),
          label: const Text("إضافة مستخدم"),
          onPressed: () async {
            final bloc = context.read<SyncBloc>();
            await Navigator.pushNamed(
              context,
              Routes.insertAttendee,
              arguments: context
                  .read<DoctorFilterCubit>()
                  .state
                  .conference
                  .spec,
            );
            // تحديث القائمة ليظهر الطبيب الجديد
            bloc.add(GetDoctorBySpsEvent());
          },
        ),
        body: SafeArea(
          child: BlocConsumer<SyncBloc, SyncState>(
            listener: (context, state) {
              if(state is DoctorsAttendanceState){
                context.read<DoctorFilterCubit>().toggleDoctor(state.users, state.value);
              }
              if (state is DoctorsBySpsState) {
                final cubit = context.read<DoctorFilterCubit>();

                cubit.setDoctors(
                  state.users,
                );

                  cubit.setConferenceSpecs(state.conferenceModel);

              }
              else if (state is DoctorsBySpsEmptyState) {
                context.read<DoctorFilterCubit>().clear();
              }
              else if (state is DoctorsBySpsErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "خطأ: ${state.failure.massage}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is DoctorsBySpsLoadingState) {
                return loadingFullScreen(context);
              }
              if (state is DoctorsBySpsEmptyState) {
                return emptyFullScreen(
                  context,
                  message: "لا يوجد مؤتمر",
                  onRefresh: () =>
                      context.read<SyncBloc>().add(GetDoctorBySpsEvent()),
                );
              }
              if (state is DoctorsBySpsErrorState) {
                return errorFullScreen(
                  context,
                  mes: state.failure.massage,
                  func: () =>
                      context.read<SyncBloc>().add(GetDoctorBySpsEvent()),
                );
              }
              return RefreshIndicator(
                color: ColorManager.primary,
                onRefresh: () async {
                  context.read<SyncBloc>().add(GetDoctorBySpsEvent());
                },
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                          child: Column(
                            children: [
                              _buildCustomHeader(),
                              const SizedBox(height: 16),
                              _buildConferenceCard(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _StickySearchAndFilterDelegate(
                          minExtentHeight: FontResponsive.font(
                            context,
                            mobile: 118,
                            tablet: 138,
                          ),
                          maxExtentHeight: FontResponsive.font(
                            context,
                            mobile: 118,
                            tablet: 138,
                          ),
                          child: Container(
                            color: const Color(0xFFF8FAFC),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 4,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildSearchField(),
                                const SizedBox(height: 10),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Row(
                                      children: [
                                        _buildFilterChip(
                                          label: "الكل",
                                          status: DoctorFilterStatus.all,
                                          icon: Icons.group_outlined,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildFilterChip(
                                          label: "لم يحضروا",
                                          status: DoctorFilterStatus.notAttended,
                                          icon: Icons.person_off_outlined,
                                        ),
                                        const SizedBox(width: 8),
                                        _buildFilterChip(
                                          label: "حضروا",
                                          status: DoctorFilterStatus.attended,
                                          icon: Icons.how_to_reg_outlined,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocBuilder<DoctorFilterCubit, DoctorFilterState>(
                      builder: (context, filterState) {
                        final doctors = filterState.filteredDoctors;
                        return Stack(
                          children: [
                            if (doctors.isEmpty &&
                                state is! DoctorsBySpsLoadingState)
                              emptyFullScreen(
                                context,
                                message: "لا يوجد أطباء مسجلين يطابقون الفرز",
                              )
                            else
                              ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 20,
                                ),
                                itemCount: doctors.length,
                                itemBuilder: (context, index) {
                                  return _buildDoctorCard(doctors[index]);
                                },
                              ),
                            if (state is DoctorsBySpsLoadingState &&
                                filterState.allDoctors.isEmpty)
                              loadingFullScreen(context),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            color: Colors.transparent,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _logoutFromConference,
              child: Text(
                "الخروج من المؤتمر",
                style: TextStyle(
                  fontSize: FontResponsive.font(
                    context,
                    mobile: 16,
                    tablet: 22,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // ✨ تعديل الـ App Bar ليكون بتصميم طافٍ (Floating UI) يجمع بين الرقي والوضوح العالي
  Widget _buildCustomHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorManager.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.assignment_ind_outlined, color: ColorManager.primary, size: 24),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "تسجيل الحضور",
                      style: TextStyle(
                        fontSize: FontResponsive.font(context, mobile: 20, tablet: 26),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      "إدارة وتدقيق قوائم الأطباء",
                      style: TextStyle(
                        fontSize: FontResponsive.font(context, mobile: 12, tablet: 15),
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined),
                onPressed: () async {
              final correctPassword = await instance<AppPreferences>().getPassword() ?? "لا يوجد كلمة سر";
              if (!context.mounted) return;
              showPasswordDialog(
                context: context,
                onSuccess: () {
                  BlocProvider.of<SyncBloc>(context).add(GetInfoConferenceEvent());
                  BlocProvider.of<SyncBloc>(context).add(GetAllUserEvent());
                  Navigator.pushNamed(
                    context,
                    Routes.settingPage,
                    arguments: context.read<DoctorFilterCubit>().state.conference.id,
                  );
                },
                correctPassword: correctPassword,
              );
            }, ),
          ],
        ),
      ),
    );
  }

  // ✨ إعادة تصميم كرت المؤتمر تماً ليصبح بطاقة معلومات غنية ومنظمة هندسياً (Modern Dashboard Card)
  Widget _buildConferenceCard() {
    instance<AppPreferences>().setLoggedIn(4);
    final filterState = context.watch<DoctorFilterCubit>().state;
    final conferenceModel = filterState.conference;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child:
       Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الجزء العلوي: الأيقونة والاسم والوصف
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.gavel_rounded, color: Color(0xFF2563EB), size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        conferenceModel.name,
                        style: TextStyle(
                          fontSize: FontResponsive.font(context, mobile: 16, tablet: 22),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                          height: 1.3,
                        ),
                      ),
                      if (conferenceModel.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          conferenceModel.description,
                          style: TextStyle(
                            fontSize: FontResponsive.font(context, mobile: 12, tablet: 16),
                            color: const Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // خط فاصل داخلي أنيق
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),

          // الجزء السفلي: تفاصيل المكان والتوقيت والاختصاصات
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              children: [
                // الموقع الجغرافي
                Row(
                  children: [
                    const Icon(Icons.map_outlined, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        conferenceModel.address,
                        style: TextStyle(
                          fontSize: FontResponsive.font(context, mobile: 12, tablet: 16),
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // التوقيت الزمني
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined, size: 16, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "الفترة المحددة: ${conferenceModel.startDate}  إلى  ${conferenceModel.endDate}",
                        style: TextStyle(
                          fontSize: FontResponsive.font(context, mobile: 12, tablet: 16),
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                // الأوسمة الطبية للاختصاصات
                if (conferenceModel.spec.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.local_activity_outlined, size: 16, color: Color(0xFF94A3B8)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: conferenceModel.spec.map((specialization) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: ColorManager.primary.withValues(alpha: 0.06),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: ColorManager.primary.withValues(alpha: 0.12)),
                              ),
                              child: Text(
                                specialization.title??"",
                                style: TextStyle(
                                  fontSize: FontResponsive.font(context, mobile: 11, tablet: 14),
                                  color: ColorManager.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildSearchField() {
    final filterState = context.watch<DoctorFilterCubit>().state;
    final specList = filterState.conference.spec;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  context.read<DoctorFilterCubit>().search(value),
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: "ابحث بالاسم أو الرقم...",
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: FontResponsive.font(context, mobile: 14, tablet: 19),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButton<int?>(
            // القيمة المختارة قد تكون من مؤتمر سابق وغير موجودة بالقائمة الحالية
            value: (filterState.selectedSpecId == -1 ||
                    specList.any((e) => e.id == filterState.selectedSpecId))
                ? filterState.selectedSpecId
                : -1,
            underline: const SizedBox(),
            items: [
              DropdownMenuItem(value: -1, child: Text("الكل")),
              ...specList.map(
                    (spec) => DropdownMenuItem(
                  value: spec.id,
                  child: Text(spec.title ?? ""),
                ),
              ),
            ],
            onChanged: (value) {
              context.read<DoctorFilterCubit>().changeSpecFilter(value);
            },
          ),
        ),
      ],
    );
  }
  Widget _buildFilterChip({
    required String label,
    required DoctorFilterStatus status,
    required IconData icon,
  }) {
    final filterState = context.watch<DoctorFilterCubit>().state;
    final bool isSelected = filterState.selectedFilter == status;

    return ChoiceChip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      iconTheme: IconThemeData(
        color: isSelected ? Colors.white : Colors.grey[600],
        size: 18,
      ),
      avatar: Icon(icon),
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) {
          context.read<DoctorFilterCubit>().changeFilter(status);
        }
      },
      selectedColor: ColorManager.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
        fontWeight: FontWeight.bold,
        fontSize: FontResponsive.font(context, mobile: 13, tablet: 18),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? ColorManager.primary : Colors.grey.shade300,
        ),
      ),
      showCheckmark: false,
    );
  }

  Widget _buildDoctorCard(UserDoneModel doctor) {
    final bool isChecked = doctor.isDone == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isChecked
              ? ColorManager.primary.withValues(alpha: 0.3)
              : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        onTap: () => _showNoteDialog(doctor),
        title: Text(
          doctor.userModel.fullName,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontResponsive.font(context, mobile: 16, tablet: 22),
            color: isChecked ? ColorManager.primary : Colors.black87,
          ),
        ),
        subtitle: _buildDoctorDetails(doctor.userModel),
        trailing: Checkbox(
          activeColor: ColorManager.primary,
          value: isChecked,
          onChanged: (bool? value) {
            if (value != null) {
              context.read<SyncBloc>().add(
                UpdateDoneDoctorEvent(
                    doctor: doctor,isDone: value?1:0),
              );
            }
          },
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(
            Icons.person_outline_rounded,
            color: isChecked ? ColorManager.primary : Colors.grey,
          ),
        ),
      ),
    );
  }

  /// الهاتف والعنوان والملاحظة تحت اسم الطبيب (يُتخطى الفارغ)
  Widget? _buildDoctorDetails(UserModel user) {
    Widget line(IconData icon, String text) => Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );

    final phone = user.phone.trim();
    final address = (user.address ?? '').trim();
    final notes = (user.notes ?? '').trim();
    if (phone.isEmpty && address.isEmpty && notes.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phone.isNotEmpty) line(Icons.phone_outlined, phone),
        if (address.isNotEmpty) line(Icons.location_on_outlined, address),
        if (notes.isNotEmpty) line(Icons.note_alt_outlined, notes),
      ],
    );
  }

  /// نافذة ملاحظة على الطبيب: تعدّل الملاحظة فقط وتعلّم السجل للرفع
  /// دون المساس ببقية بياناته (يبقى server_user_id كما هو).
  Future<void> _showNoteDialog(UserDoneModel doctor) async {
    final user = doctor.userModel;
    final bloc = context.read<SyncBloc>();

    final result = await showDialog<({String phone, String note})>(
      context: context,
      builder: (_) => _DoctorNoteDialog(
        name: user.fullName,
        initialPhone: user.phone,
        initialNote: user.notes ?? '',
      ),
    );

    if (result == null) return;
    final text = result.note.trim();
    final phone = result.phone.trim();
    if (text == (user.notes ?? '').trim() && phone == user.phone.trim()) return;

    user.phone = phone;
    user.notes = text.isEmpty ? null : text;
    user.isUpload = 0;
    if (user.server_user_id != null) {
      // طبيب موجود على السيرفر: يُرفع كتعديل
      user.is_modified = 1;
      user.is_local_new = 0;
    } else {
      // طبيب جديد لم يُرفع بعد: يبقى جديداً وتذهب ملاحظته معه
      user.is_modified = 0;
      user.is_local_new = 1;
    }
    bloc.add(EditUserEvent(user));
    if (mounted) setState(() {});
  }
}

class _StickySearchAndFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minExtentHeight;
  final double maxExtentHeight;

  _StickySearchAndFilterDelegate({
    required this.child,
    required this.minExtentHeight,
    required this.maxExtentHeight,
  });

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(covariant _StickySearchAndFilterDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.minExtentHeight != minExtentHeight ||
        oldDelegate.maxExtentHeight != maxExtentHeight;
  }
}

/// نافذة الملاحظة: تملك الـ controller وتتخلص منه مع دورة حياة النافذة
class _DoctorNoteDialog extends StatefulWidget {
  final String name;
  final String initialPhone;
  final String initialNote;

  const _DoctorNoteDialog({
    required this.name,
    required this.initialPhone,
    required this.initialNote,
  });

  @override
  State<_DoctorNoteDialog> createState() => _DoctorNoteDialogState();
}

class _DoctorNoteDialogState extends State<_DoctorNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phone =
      TextEditingController(text: widget.initialPhone);
  late final TextEditingController _note =
      TextEditingController(text: widget.initialNote);

  @override
  void dispose() {
    _phone.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.name, textAlign: TextAlign.right),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: "رقم الهاتف",
                  prefixIcon: Icon(Icons.phone_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final t = (v ?? '').trim();
                  if (t.isEmpty) return 'رقم الهاتف مطلوب';
                  if (t.length >= 8) return null;
                  return 'الرقم قصير جداً، 8 أرقام على الأقل';
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                maxLines: 4,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: "اكتب ملاحظتك عن هذا الطبيب",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("إلغاء"),
        ),
        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(context, (phone: _phone.text, note: _note.text));
          },
          child: const Text("حفظ"),
        ),
      ],
    );
  }
}
