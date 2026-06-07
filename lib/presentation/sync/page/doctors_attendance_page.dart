import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/responsive/font_responseve.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

enum DoctorFilterStatus { all, notAttended, attended }

class DoctorsAttendancePage extends StatefulWidget {
  const DoctorsAttendancePage({super.key});

  @override
  State<DoctorsAttendancePage> createState() => _DoctorsAttendancePageState();
}

class _DoctorsAttendancePageState extends State<DoctorsAttendancePage> {
  List<DoctorMockItem> _allDoctors = [];
  List<DoctorMockItem> _filteredDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  DoctorFilterStatus _selectedFilter = DoctorFilterStatus.all;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SyncBloc>(context).add(GetConferenceAsyncEvent());
    context.read<SyncBloc>().add(DoctorsAttendanceEvent());
    instance<AppPreferences>().setLoggedIn(4);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilter() {
    final String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDoctors = _allDoctors.where((doc) {
        final bool matchesSearch = doc.name.toLowerCase().contains(query);
        bool matchesStatus = true;
        if (_selectedFilter == DoctorFilterStatus.notAttended) {
          matchesStatus = (doc.isDone == 0);
        } else if (_selectedFilter == DoctorFilterStatus.attended) {
          matchesStatus = (doc.isDone == 1);
        }
        return matchesSearch && matchesStatus;
      }).toList();
    });
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
        backgroundColor: const Color(0xFFF8FAFC), // خلفية ناعمة ومريحة جداً للعين
        body: SafeArea(
          child: BlocConsumer<SyncBloc, SyncState>(
            listenWhen: (previous, current) =>
            current is DoctorsAttendanceState ||
                current is DoctorsAttendanceErrorState,
            buildWhen: (previous, current) =>
            current is DoctorsAttendanceState ||
                current is DoctorsAttendanceLoadingState ||
                current is DoctorsAttendanceErrorState,
            listener: (context, state) {
              if (state is DoctorsAttendanceState) {
                setState(() {
                  _allDoctors = state.users;
                  _applyFilter();
                });
              } else if (state is DoctorsAttendanceErrorState) {
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
              return RefreshIndicator(
                color: ColorManager.primary,
                onRefresh: () async {
                  context.read<SyncBloc>().add(DoctorsAttendanceEvent());
                },
                child: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 0),
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
                          minExtentHeight: FontResponsive.font(context, mobile: 118, tablet: 138),
                          maxExtentHeight: FontResponsive.font(context, mobile: 118, tablet: 138),
                          child: Container(
                            color: const Color(0xFFF8FAFC),
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Stack(
                      children: [
                        _filteredDoctors.isEmpty && state is! DoctorsAttendanceLoadingState
                            ? Center(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Center(
                                child: Text(
                                  "لا يوجد أطباء مسجلين يطابقون الفرز",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: FontResponsive.font(context, mobile: 15, tablet: 20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          itemCount: _filteredDoctors.length,
                          itemBuilder: (context, index) {
                            return _buildDoctorCard(_filteredDoctors[index]);
                          },
                        ),
                        if (state is DoctorsAttendanceLoadingState && _allDoctors.isEmpty)
                          const Center(
                            child: CircularProgressIndicator(color: ColorManager.primary),
                          ),
                      ],
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
                  fontSize: FontResponsive.font(context, mobile: 16, tablet: 22),
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
                    color: ColorManager.primary.withOpacity(0.1),
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
          ],
        ),
      ),
    );
  }

  // ✨ إعادة تصميم كرت المؤتمر تماً ليصبح بطاقة معلومات غنية ومنظمة هندسياً (Modern Dashboard Card)
  Widget _buildConferenceCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: BlocBuilder<SyncBloc, SyncState>(
        buildWhen: (previous, current) =>
        current is GetConferenceAsyncLoadingState ||
            current is AsyncConferenceErrorState ||
            current is GetConferenceAsyncState ||
            current is GetConferenceAsyncEmptyState,
        builder: (context, state) {
          if (state is GetConferenceAsyncLoadingState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: loadingFullScreen(context),
            );
          } else if (state is AsyncConferenceErrorState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: errorFullScreen(context),
            );
          } else if (state is GetConferenceAsyncState) {
            instance<AppPreferences>().setLoggedIn(4);
            GetAllConferenceModel conferenceModel = state.conferenceModel;

            return Directionality(
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
                                        color: ColorManager.primary.withOpacity(0.06),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: ColorManager.primary.withOpacity(0.12)),
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => _applyFilter(),
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: "ابحث بالاسم أو الرقم...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: FontResponsive.font(context, mobile: 14, tablet: 19)),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required DoctorFilterStatus status,
    required IconData icon,
  }) {
    final bool isSelected = _selectedFilter == status;

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
          setState(() {
            _selectedFilter = status;
            _applyFilter();
          });
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

  Widget _buildDoctorCard(DoctorMockItem doctor) {
    final bool isChecked = doctor.isDone == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isChecked ? ColorManager.primary.withOpacity(0.3) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CheckboxListTile(
        activeColor: ColorManager.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        controlAffinity: ListTileControlAffinity.trailing,
        title: Text(
          doctor.name,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: FontResponsive.font(context, mobile: 16, tablet: 22),
            color: isChecked ? ColorManager.primary : Colors.black87,
          ),
        ),
        value: isChecked,
        onChanged: (bool? value) {
          if (value != null) {
            setState(() {
              doctor.isDone = value ? 1 : 0;
              _applyFilter();
            });

            context.read<SyncBloc>().add(
              UpdateDoneDoctorEvent(
                doctorMockItem: doctor,
                doctors: _allDoctors,
              ),
            );
          }
        },
        secondary: CircleAvatar(
          backgroundColor: const Color(0xFFF1F5F9),
          child: Icon(
            Icons.person_outline_rounded,
            color: isChecked ? ColorManager.primary : Colors.grey,
          ),
        ),
      ),
    );
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