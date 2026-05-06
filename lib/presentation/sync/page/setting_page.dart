import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formify/app/app_preferences.dart';
import 'package:formify/app/di.dart';
import 'package:formify/domain/models/models.dart';
import 'package:formify/presentation/conference/widget/conferm_dialog.dart';
import 'package:formify/presentation/resources/color_manager.dart';
import 'package:formify/presentation/resources/routes_manager.dart';
import 'package:formify/presentation/resources/strings_manager.dart';
import 'package:formify/presentation/sync/bloc/sync_bloc.dart';
import 'package:formify/presentation/unit/animation/animation_container_widget.dart';
import 'package:formify/presentation/unit/state_renderer/stateWidget.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key, required this.id});

  final int id;

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    BlocProvider.of<SyncBloc>(context).add(GetAllUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f8),
      appBar: _buildAppBar(context),
      body: BlocListener<SyncBloc, SyncState>(
        listener: (context, state) {
          // الحفاظ على السلوك البرمجي للمزامنة
          if (state is DataLoadingState) loading(context);
          if (state is DataErrorState)
            error(context, state.failure.massage, state.failure.code);
          if (state is GetDataState) {
            BlocProvider.of<SyncBloc>(context).add(
              UploadDataEvent(state.users, state.conference_id, state.isActive),
            );
          } else if (state is UploadDataState) {
            state.isUpload == 0
                ? BlocProvider.of<SyncBloc>(context).add(DeleteUserEvent())
                : BlocProvider.of<SyncBloc>(context).add(DeleteDataEvent());
          } else if (state is DeleteDataState) {
            instance<AppPreferences>().setIConference(state.isActive != 0);
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
              // أزرار التحكم (إضافة، حفظ، رفع، خروج)
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

  Widget _buildActionCard(BuildContext context,
      String title,
      String desc,
      IconData icon,
      Color color,
      VoidCallback onTap,) {
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
              Icon(Icons.arrow_forward_ios, size: 14,
                  color: Colors.grey.shade400),
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
      builder: (context, state) {
        if(state is GetUserConferenceErrorState){
          return errorFullScreen(context);
        }else if(state is GetUserConferenceState){
          List<UserModel> users;
         return Column(
            children: users
                .map(
                  (u) =>
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 20,
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              u['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              u['info']!,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue.shade50,
                          child: Icon(
                            Icons.person,
                            color: Colors.blue.shade300,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
            )
                .toList(),
          );
        }
        return SizedBox();
      },
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
      onConfirm: () =>
          BlocProvider.of<SyncBloc>(context).add(GetDataEvent(widget.id, type)),
    );
  }
}
