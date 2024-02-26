import 'package:flutter/material.dart';
import 'package:thanhson/src/features/screens/forget-password/code_for_reset_password.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/widgets/alert_dialog.dart';
import 'package:thanhson/src/constants/colors.dart';

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
            builder: (context) => CodeForResetPassword(gardenerEmail: email)),
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
