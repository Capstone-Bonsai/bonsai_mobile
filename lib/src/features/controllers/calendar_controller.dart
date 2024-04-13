import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thanhson/src/features/models/working_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thanhson/src/features/models/working_detail.dart';

Future<List<WorkingDate>> fetchData(int month, int year) async {
  {
    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri = Uri.parse('${ApiConfig.baseUrl}/Contract/WorkingCalendar?month=$month&year=$year');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      List<WorkingDate> workingDates = (jsonResponse as List)
          .map((json) => WorkingDate.fromJson(json))
          .toList();
      return workingDates;
    }
    return [];
  }
}

Future<WorkingDetail> getWorkingDetail(String id) async {
  {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      String? token = sharedPref.getString('token');
      final uri = Uri.parse('${ApiConfig.baseUrl}/Contract/Gardener/$id');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return WorkingDetail.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load working detail');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
