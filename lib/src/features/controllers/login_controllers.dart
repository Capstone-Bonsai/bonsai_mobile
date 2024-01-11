import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thanhson/src/features/screens/login/login_screen.dart';
import 'package:thanhson/src/features/screens/main-pages/main_pages.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
late Box box1;
Future loginFuture(BuildContext context, String email, String password,
    bool rememberUser) async {
  if (password == "123456") {
    Fluttertoast.showToast(
      msg: "Login Successful!",
    );

    if (rememberUser) {
      box1 = await Hive.openBox('logindata');
      box1.put('email', email);
      box1.put('password', password);
    }
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('email', email);

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPages(index: 0,)),
    );
  } else {
    Fluttertoast.showToast(
      msg: "Wrong email or password!",
    );
  }
}

Future<void> autoLoginFuture(BuildContext context) async {
  String email = "";
  String password = "";
  box1 = await Hive.openBox('logindata');

  if (box1.get('email') != null) {
    email = box1.get('email');
  }
  if (box1.get('password') != null) {
    password = box1.get('password');
  }
  if (email == "" || password == "") {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
  if (password == "123456") {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setString('email', email);

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainPages(index: 0)),
    );
  } else {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

Future<void> logoutFuture(BuildContext context) async {
  box1 = await Hive.openBox('logindata');
  await box1.clear();
  var sharedPref = await SharedPreferences.getInstance();
  sharedPref.clear();
  if (!context.mounted) return;
  Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
}
