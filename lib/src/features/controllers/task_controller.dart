import 'package:thanhson/src/features/models/working_process.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thanhson/src/constants/colors.dart';

Future<List<WorkingProcess>> fetchData() async {
  {
    
    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri = Uri.parse(
        '${ApiConfig.baseUrl}/OrderServiceTask/GetDailyTasksForGarndener');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      final List<dynamic> items = jsonResponse['items'];
      List<WorkingProcess> workingProcesses =
          (items).map((json) => WorkingProcess.fromJson(json)).toList();
      return workingProcesses;
    }
    return [];
  }
}

Future<void> updateWorkingProcesses(
    BuildContext context, List<WorkingProcess> processes) async {
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
 List<String> orderServiceTaskIds =
      processes.map((process) => process.id).toList();
  List<bool> isFinishedList =
      processes.map((process) => process.finished).toList();
  Map<String, dynamic> jsonMap = {
    "orderServiceTaskId": orderServiceTaskIds,
    "isFinished": isFinishedList,
  };
  var sharedPref = await SharedPreferences.getInstance();
  String? token = sharedPref.getString('token');
  final uri = Uri.parse('${ApiConfig.baseUrl}/OrderServiceTask/UpdateProgress');
  final response = await http.put(
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
    if (!context.mounted) return;
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
