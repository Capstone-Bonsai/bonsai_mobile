import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/screens/login/login_screen.dart';
import 'package:thanhson/src/features/screens/main-pages/main_pages.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thanhson/src/features/models/jwt_token_response.dart';
import 'package:thanhson/src/features/widgets/alert_dialog.dart';

late Box box1;
Future loginFuture(BuildContext context, String email, String password,
    bool rememberUser) async {
  showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: mainColor,
            backgroundColor: greyColor,
          ),
        );
      });
  try {
    final uri = Uri.parse('${ApiConfig.baseUrl}/Auth/Login');
    final headers = {'Content-Type': 'application/json'};
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
    };
    final response = await http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final dynamic apiResponse = json.decode(response.body);
      JWTTokenResponse jwtResponse = JWTTokenResponse.fromJson(apiResponse);
      var sharedPref = await SharedPreferences.getInstance();
      sharedPref.setString('token', jwtResponse.token);
      if (jwtResponse.role == "Gardener") {
        if (rememberUser) {
          box1 = await Hive.openBox('logindata');
          box1.put('email', email);
          box1.put('password', password);
        }
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString('email', email);
        if (!context.mounted) return;
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => const MainPages(
                    index: 0,
                  )),
        );
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pop();
        CustomAlertDialog.show(
          context,
          "Lỗi đăng nhập",
          "Chỉ nhân viên làm vườn mới đăng nhập được vào app này!",
        );
      }
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      CustomAlertDialog.show(
        context,
        "Đăng nhập không thành công",
        "Tài khoản hoặc mật khẩu bạn vừa nhập không chính xác, vui lòng đăng nhập lại",
      );
    }
  } catch (error) {
    if (!context.mounted) return;
    Navigator.of(context).pop();
    CustomAlertDialog.show(
      context,
      "Đăng nhập không thành công",
      "Có lỗi xảy ra trong quá trình đăng nhập, vui lòng thử lại sau",
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
