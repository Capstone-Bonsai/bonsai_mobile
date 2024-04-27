import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thanhson/src/constants/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/features/models/order.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<List<Order>> fetchData(BuildContext context) async {
  {
    EasyLoading.show(status: 'Đang xử lý...');
    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri = Uri.parse('${ApiConfig.baseUrl}/Order?pageIndex=0&pageSize=5');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final dynamic jsonResponse = json.decode(response.body);
      int count = jsonResponse['totalItemsCount'];
      if (count > 0) {
        dynamic bonsaiJsonList = jsonResponse['items'];
        List<Order> orders = (bonsaiJsonList as List)
            .map((json) => Order.fromJson(json))
            .toList();

        return orders;
      }
      else{
        EasyLoading.dismiss();
        return [];
      }

    }
    EasyLoading.dismiss();
    return [];
  }
}

Future<Order> getOrder(String id) async {
  {
    try {
      var sharedPref = await SharedPreferences.getInstance();
      String? token = sharedPref.getString('token');
      final uri = Uri.parse('${ApiConfig.baseUrl}/Order/$id');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return Order.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load working detail');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}

Future<void> sendImagesToAPI(
    BuildContext context, orderId, List<XFile> imageFileList) async {
  EasyLoading.show(status: 'Đang xử lý...');
  var sharedPref = await SharedPreferences.getInstance();
  String? token = sharedPref.getString('token');
  var url = Uri.parse('${ApiConfig.baseUrl}/Order/DeliveryFinishing/$orderId');
  var request = http.MultipartRequest('PUT', url);
  request.headers['Authorization'] = 'Bearer $token';
  for (var imageFile in imageFileList) {
    var multipartFile = http.MultipartFile.fromBytes(
      'Image',
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

Future<void> changeOrderStatus(
    BuildContext context, String orderId, int status) async {
  try {
    EasyLoading.show(status: 'Đang xử lý...');

    var sharedPref = await SharedPreferences.getInstance();
    String? token = sharedPref.getString('token');
    final uri =
        Uri.parse('${ApiConfig.baseUrl}/Order/$orderId?orderStatus=$status');
    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

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
