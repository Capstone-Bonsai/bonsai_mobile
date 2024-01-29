import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:thanhson/src/features/models/working_date.dart';

Future<List<WorkingDate>> fetchData(int month, int year) async {
  {
    final uri = Uri.parse('${ApiConfig.testDateUrl}&year=$year&month=$month');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = json.decode(response.body);
      List<WorkingDate> workingDates = (jsonResponse['response']['holidays'] as List)
          .map((holidayJson) => WorkingDate.fromJson(holidayJson))
          .toList();
      return workingDates;
    }
    return [];
  }
}
