import 'package:flutter/material.dart';
import 'package:thanhson/src/features/screens/forget-password/add_new_password.dart';
import 'package:thanhson/src/features/screens/forget-password/code_for_reset_password.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/screens/login/login_screen.dart';
import 'package:thanhson/src/features/widgets/alert_dialog.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'dart:convert';
import 'package:thanhson/src/features/controllers/Utils/Utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future checkEmail(BuildContext context, String email) async {
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
    final uri = Uri.parse(
        '${ApiConfig.baseUrl}/Auth/ForgotPasswordForMobile?email=$email');
    final response = await http.post(
      uri,
    );

    if (response.statusCode == 200) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => CodeForResetPassword(email: email)),
      );
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      CustomAlertDialog.show(
        context,
        "Sai email",
        "Email bạn nhập không đúng, vui lòng thử lại!",
      );
    }
  } catch (e) {
    throw Exception('Failed to send request: $e');
  }
}

Future otpHandler(BuildContext context, String email, String otp) async {
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
    final uri =
        Uri.parse('${ApiConfig.baseUrl}/Auth/OtpHandler?email=$email&otp=$otp');
    final response = await http.get(
      uri,
    );

    if (response.statusCode == 200) {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => AddNewPassword(
                  email: email,
                  otp: otp,
                )),
      );
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      CustomAlertDialog.show(
        context,
        "Sai mã OTP",
        "OTP bạn nhập không đúng, vui lòng thử lại!",
      );
    }
  } catch (e) {
    throw Exception('Failed to send request: $e');
  }
}

Future resetPassword(BuildContext context, String email, String otp,
    String newPassword, String confirmPassword) async {
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
  String checkPassword = validatePassword(newPassword);
  if (checkPassword != "Đúng") {
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    CustomAlertDialog.show(
      context,
      "Lỗi đặt lại mật khẩu",
      checkPassword,
    );
    return;
  }
  if (newPassword != confirmPassword){
      if (!context.mounted) return;
        Navigator.of(context, rootNavigator: true).pop();
        CustomAlertDialog.show(
          context,
          "Lỗi đặt lại mật khẩu",
          "Xác nhận mật khẩu không khớp",
        );
        return;
    }
  try {
    Map<String, dynamic> jsonMap = {
      "email": email,
      "code": otp,
      "newPassword": newPassword,
      "confirmPassword": confirmPassword,
    };
    final uri = Uri.parse('${ApiConfig.baseUrl}/Auth/ResetPasswordForMobile');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(jsonMap),
    );

    if (response.statusCode == 200) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); 
      Fluttertoast.showToast(
      msg: "Cập nhật thông tin thành công, vui lòng đăng nhập lại!",
    );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const LoginScreen(
                )),
               
      );
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pop();
      CustomAlertDialog.show(
        context,
        "Đã xảy ra lỗi",
        response.body,
      );
    }
  } catch (e) {
    throw Exception('Failed to send request: $e');
  }
}
