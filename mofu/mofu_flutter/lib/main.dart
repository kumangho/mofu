import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'package:mofu_flutter/ui/view/intro_view/loading_page.dart';
import 'package:mofu_flutter/ui/view/foodvision_view/foodvision_page.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp( DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(), 
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      title: 'Flutter Demo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const FoodVisionPage(),
    );
  }
}