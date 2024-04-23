import 'package:thanhson/src/features/models/working_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thanhson/src/constants/colors.dart';


Future<WorkingProcess> fetchData(String serviceOrderId) async {
  {
    
    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri = Uri.parse(
        '${ApiConfig.baseUrl}/Task/$serviceOrderId');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      WorkingProcess workingProcess = WorkingProcess.fromJson(jsonResponse);
      return workingProcess;
    }else {

      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
    
  }
}

Future<void> updateWorkingProcesses(
    BuildContext context, String serviceOrderId, List<String> finishedTasks) async {
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
  Map<String, dynamic> jsonMap = {
    "serviceOrderId": serviceOrderId,
    "finishedTasks": finishedTasks,
  };
  var sharedPref = await SharedPreferences.getInstance();
  String? token = sharedPref.getString('token');
  final uri = Uri.parse('${ApiConfig.baseUrl}/Task/Progress');
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
    Fluttertoast.showToast(
      msg: "Cập nhật thông tin thành công!",
    );
  }
  else{
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: response.body          ,
    );
  }
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "Đã xảy ra lỗi trong quá trình cập nhật, vui lòng thử lại sau!",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
 
}
