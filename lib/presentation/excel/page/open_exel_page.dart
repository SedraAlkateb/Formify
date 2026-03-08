import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart'; // مكتبة لفتح الملف
import 'dart:io';
import 'package:permission_handler/permission_handler.dart'; // مكتبة الأذونات



class OpenFilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("فتح ملف Excel")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // طلب الأذونات
            await requestPermissions();

            // الحصول على المسار للمجلد الخارجي
            final directory = await getExternalStorageDirectory();
            final path = '${directory?.path}/user_data.xlsx'; // المسار للمجلد الخارجي

            File file = File(path);
            if (await file.exists()) {
              // فتح الملف باستخدام مكتبة open_file
              await OpenFile.open(path);
            } else {
              // إذا لم يكن الملف موجودًا
              print('الملف غير موجود');
            }
          },
          child: Text("فتح ملف Excel"),
        ),
      ),
    );
  }

  Future<void> requestPermissions() async {
    // طلب صلاحيات القراءة والكتابة
    PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      print("تم منح الأذونات بنجاح");
    } else {
      print("الأذونات مرفوضة");
    }
  }
}