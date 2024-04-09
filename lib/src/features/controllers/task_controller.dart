import 'package:thanhson/src/features/models/working_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thanhson/src/constants/colors.dart';


Future<WorkingProcess> fetchData(String contractId) async {
  {
    
    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri = Uri.parse(
        '${ApiConfig.baseUrl}/Task/$contractId');
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
    BuildContext context, String contractId, List<String> finishedTasks) async {
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
    "contractId": contractId,
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
