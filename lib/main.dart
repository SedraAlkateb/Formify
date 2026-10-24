import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:formify/app/app.dart';
import 'package:formify/app/di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _setupAppRequirements();

  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}

Future<void> _setupAppRequirements() async {
  await ScreenUtil.ensureScreenSize();

  await initAppModule();

  // عمودي فقط على التابلت (أقصر ضلع >= 600dp)، والموبايل يدور بحرية.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortestSide =
      view.physicalSize.shortestSide / view.devicePixelRatio;
  final isTablet = shortestSide >= 600;

  await SystemChrome.setPreferredOrientations(
    isTablet
        ? [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
        : DeviceOrientation.values,
  );
}
