import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  await Hive.initFlutter();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom 
    ..indicatorColor = Colors.blue 
    ..backgroundColor = Colors.white 
    ..textColor = Colors.black 
    ..maskColor = Colors.black.withOpacity(0.5)
    ..maskType = EasyLoadingMaskType.black 
    ..userInteractions = false
    ..dismissOnTap = false; 
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => FutureBuilder(
              future: autoLoginFuture(context),
              builder: (context, snapshot) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    );
              },
            ),
      },
      builder: EasyLoading.init(),
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
