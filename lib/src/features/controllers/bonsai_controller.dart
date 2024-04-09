import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/models/bonsai.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<Bonsai> getBonsai(String id) async {
  {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      String? token = sharedPref.getString('token');
      final uri = Uri.parse('${ApiConfig.baseUrl}/CustomerBonsai/$id');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Bonsai.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load working detail');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}