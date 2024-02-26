import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/models/gardener.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:thanhson/src/features/widgets/alert_dialog.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/screens/main-pages/main_pages.dart';

Future<Gardener> getGardenerDetail() async {
  {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      String? token = sharedPref.getString('token');
      final uri = Uri.parse('${ApiConfig.baseUrl}/User/Profile');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Gardener.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load working detail');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}

Future changePasswordFuture(
    BuildContext context, String oldPassword, String newPassword, String confirmPassword) async {
  {
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
    if(oldPassword == ""){
      if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        CustomAlertDialog.show(
          context,
          "Lỗi đặt lại mật khẩu",
          "Vui lòng nhập mật khẩu cũ",
        );
        return;
    }

    String checkPassword = validatePassword(newPassword);
    if (checkPassword != "Đúng"){
      if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        CustomAlertDialog.show(
          context,
          "Lỗi đặt lại mật khẩu",
          checkPassword,
        );
        return;
    }
    try {
      var sharedPref = await SharedPreferences.getInstance();
      String? token = sharedPref.getString('token');
      Map<String, dynamic> jsonMap = {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };
      final uri = Uri.parse('${ApiConfig.baseUrl}/User/Profile');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonMap),
      );

      if (response.statusCode == 200) {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.of(context).pop();
         CustomAlertDialog.show(
          context,
          "Thành công",
          "Đổi mật khẩu thành công",
        );
      } else {
        if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        CustomAlertDialog.show(
          context,
          "Lỗi đặt lại mật khẩu",
          response.body,
        );
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}

String validatePassword(String password) {
  if (password.length < 6) {
    return "Mật khẩu phải trên 6 kí tự";
  }
  
  bool hasUppercase = false;
  for (int i = 0; i < password.length; i++) {
    if (password[i].toUpperCase() == password[i]) {
      hasUppercase = true;
      break;
    }
  }
  if (!hasUppercase) {
    return "Mật khẩu phải có ít nhất một kí tự viết hoa";
  }
  
  bool hasNumber = false;
  for (int i = 0; i < password.length; i++) {
    if (int.tryParse(password[i]) != null) {
      hasNumber = true;
      break;
    }
  }
  if (!hasNumber) {
    return "Mật khẩu phải có ít nhất một số";
  }

  bool hasSpecialChar = false;
  RegExp specialCharRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  if (specialCharRegex.hasMatch(password)) {
    hasSpecialChar = true;
  }
  if (!hasSpecialChar) {
    return "Mật khẩu phải có ít nhất một kí tự đặc biệt";
  }

  return "Đúng";
}