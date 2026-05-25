import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/offline_sync/bloc/offline_sync_bloc.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/search_field.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key, required this.id});
  final TextEditingController searchController = TextEditingController();

  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: _buildAppBar(context),
      body: BlocListener<OfflineSyncBloc, OfflineSyncState>(
        listener: (context, state) {
          if (state is SyncLoadingState)
          {
            loading(context);
          }

          else if (state is DataOfflineErrorState) {
            error(context, state.failure.massage, state.failure.code);
          } else if (state is AddAndModifyUserSucState) {
            BlocProvider.of<OfflineSyncBloc>(context).add(
              UploadUserEvent(state.users),
            );
          } else if (state is UploadUserSucState) {
            BlocProvider.of<OfflineSyncBloc>(context).add(UpdateUserIdEvent(state.users));

          }
          else if (state is UpdateIdUserSucState) {
            BlocProvider.of<OfflineSyncBloc>(context).add(GetUserAnswerAndUserConferenceEvent());

          }
          else if (state is GetUserAnswerAndUserConferenceState) {
            state.data.is_active=state.type;
            BlocProvider.of<OfflineSyncBloc>(context).add(UploadUserAnswerAndUserConferenceEvent(state.data));

          }
          else if (state is UploadUserAnswerAndUserConferenceState) {
            if(state.type==0){
              BlocProvider.of<OfflineSyncBloc>(context).add(DeleteSyncDataEvent());
            }else{
              BlocProvider.of<OfflineSyncBloc>(context).add(DeleteAllDataEvent());
            }

          }
          else if (state is DeleteSyncDataState) {
            BlocProvider.of<OfflineSyncBloc>(context).add(GetSaveDataEvent());

          } else if (state is GetSaveDataState) {
            BlocProvider.of<OfflineSyncBloc>(context).add(AddSaveDataEvent(state.data));

          }
          else if (state is AddSaveDataSqlState) {
            print("state.type");
            print(state.type == 0);
            instance<AppPreferences>().setIConference(state.type == 0);
            instance<AppPreferences>().setLoggedIn(1);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
                  (route) => false,
            );
          }
          else if (state is DeleteAllDataState) {
            instance<AppPreferences>().setIConference(state.type == 0);
            instance<AppPreferences>().setLoggedIn(1);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.home,
                  (route) => false,
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActionCard(
                context,
                "إضافة طبيب مهم",
                "إضافة بيانات الاطباء المهمين",
                Icons.person_add_alt_1,
                Colors.blue,
                    () => Navigator.pushNamed(context, Routes.insertDoctor),
              ),
              _buildActionCard(
                context,
                StringsManager.saveConference,
                StringsManager.uploadConferenceDesc,
                Icons.save_outlined,
                Colors.indigo,
                    () => _showConfirm(context, "حفظ البيانات", 0),
              ),
              _buildActionCard(
                context,
                StringsManager.uploadConference,
                StringsManager.uploadConferenceDesc,
                Icons.cloud_upload_outlined,
                Colors.teal,
                    () => _showConfirm(context, "رفع البيانات", 1),
              ),
              _buildActionCard(
                context,
                StringsManager.logoutConference,
                StringsManager.logoutConferenceDesc,
                Icons.logout_rounded,
                Colors.redAccent,
                    () {
                  instance<AppPreferences>().setLoggedIn(1);
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routes.home,
                        (route) => false,
                  );
                },
              ),

              const SizedBox(height: 25),
              _buildSectionTitle("إحصائيات المؤتمر"),
              _buildStatsRow(), // قسم الإحصائيات (مسجلين، ردود)

              const SizedBox(height: 25),
              _buildSectionTitle("قائمة الحضور والردود"),
              _buildUsersList(), // عرض قائمة المستخدمين المضافة
            ],
          ),
        ),
      ),
    );
  }

  // --- أدوات بناء الواجهة (Helper Widgets) ---
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        StringsManager.setting,
        style: TextStyle(
          color: ColorManager.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorManager.primary),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildActionCard(
      BuildContext context,
      String title,
      String desc,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return AnimationContainerWidget(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      desc,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statItem("12", "مسجلين", Colors.orange),
        _statItem("8", "عدد الاستبيانات", Colors.green),
        _statItem("2", "اجمالي الاستبيانات المسجلة", Colors.purple),
      ],
    );
  }

  Widget _statItem(String val, String label, Color col) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: col,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return BlocBuilder<SyncBloc, SyncState>(
      buildWhen: (previous, current) => current is GetUserConferenceState || current is GetUserConferenceErrorState,
      builder: (context, state) {
        if (state is GetUserConferenceErrorState) {
          return errorFullScreen(context);
        } else if (state is GetUserConferenceState) {
          List<UserModel> users = state.filterUsers;

          return Column(
            children: [
              SearchField(
                searchController: searchController,
                onPressed: (value) {
                  BlocProvider.of<SyncBloc >(
                    context,
                  ).add(
                    SearchInUsersEvent(
                      state.users,
                      value,
                    ),
                  );
                },
              ),
              SizedBox(height: 20,),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final u = users[index];

                  // تخصيص لون الوسم بناءً على نوع المستخدم
                  Color typeColor = u.userType.name.toLowerCase() == 'doctor'
                      ? Colors.blueAccent
                      : Colors.teal;

                  return AnimationContainerWidget(
                    child: InkWell(
                      onTap:u.isUpload==1?null: () {
                        Navigator.pushNamed(context, Routes.editUser,arguments: u);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Stack(
                            children: [
                              // لمسة فنية: دائرة ملونة في الخلفية
                              PositionRectangle(typeColor),

                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // أيقونة الحالة (تم التحقق)
                                    Icon(
                                        u.isUpload==1?Icons.check_circle_outline:
                                        Icons.edit, color:
                                    u.isUpload!=0?Colors.grey:
                                    Colors.green.shade400, size: 20),

                                    const Spacer(),

                                    // تفاصيل المستخدم
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            u.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color: Color(0xFF2D3142),
                                            ),
                                          ),
                                          const SizedBox(height: 4),

                                          // رقم الهاتف مع أيقونة صغيرة
                                          _buildInfoRow(u.phone, Icons.phone_android_outlined),

                                          if (u.email != null && u.email!.isNotEmpty)
                                            _buildInfoRow(u.email!, Icons.email_outlined),

                                          if (u.address != null && u.address!.isNotEmpty)
                                            _buildInfoRow(u.address!, Icons.location_on_outlined),

                                          const SizedBox(height: 10),

                                          // وسام نوع المستخدم (Tag)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: typeColor.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: typeColor.withOpacity(0.2)),
                                            ),
                                            child: Text(
                                              u.userType.name.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: typeColor,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 15),

                                    // الصورة الشخصية (Avatar) بتصميم عصري
                                    _buildModernAvatar(u),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        }


        return SizedBox();
      },
    );
  }
// --- توابع مساعدة للديزاين الجديد ---

  Widget _buildInfoRow(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 5),
          Icon(icon, size: 14, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildModernAvatar(UserModel u) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.blue.shade200, Colors.blue.shade500],
        ),
      ),
      child: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.white,
        child: Text(
          u.fullName.isNotEmpty ? u.fullName[0] : "?",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

// ودجت تزيينية للخلفية
  Widget PositionRectangle(Color color) {
    return Positioned(
      right: -20,
      top: -20,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showConfirm(BuildContext context, String title, int type) {
    showConfirmDialog(
      context: context,
      title: title,
      message: "هل أنت متأكد من تنفيذ هذا الإجراء؟ تأكد من اتصالك بالإنترنت.",
      onConfirm1: () =>
          BlocProvider.of<OfflineSyncBloc>(context).add(AddAndModifyUserEvent(id, type)),
    );
  }
}
