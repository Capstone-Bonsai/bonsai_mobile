import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';
import 'dart:io';

void main() async {
  await Hive.initFlutter();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
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
                  return const CircularProgressIndicator();
              },
            ),
      }
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
