import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/models/gardener.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:thanhson/src/features/widgets/alert_dialog.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/controllers/Utils/Utils.dart';

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

Future changePasswordFuture(BuildContext context, String oldPassword,
    String newPassword, String confirmPassword) async {
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
    if (oldPassword == "") {
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

    if (newPassword != confirmPassword) {
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

Future<void> updateProfile(BuildContext context, XFile? imageFile,
    String fullName, String userName, String phoneNumber) async {
  EasyLoading.show(status: 'Đang xử lý...');
  var sharedPref = await SharedPreferences.getInstance();
  String? token = sharedPref.getString('token');
  var url = Uri.parse('${ApiConfig.baseUrl}/User/Profile');
  var request = http.MultipartRequest('PUT', url);
  request.headers['Authorization'] = 'Bearer $token';
  request.fields['UserName'] = userName;
  request.fields['FullName'] = fullName;
  request.fields['PhoneNumber'] = phoneNumber;
  if (imageFile != null) {
    var multipartFile = http.MultipartFile.fromBytes(
      'Avatar',
      await imageFile.readAsBytes(),
      filename: imageFile.name,
    );
    request.files.add(multipartFile);
  }
  try {
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thành công"),
            content: Text(response.body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      EasyLoading.dismiss();
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Đã xảy ra lỗi"),
            content: Text(response.body),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    EasyLoading.dismiss(); // Dismiss loading indicator
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đã xảy ra lỗi"),
          content: const Text("Đã xảy ra lỗi khi thực hiện yêu cầu."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
