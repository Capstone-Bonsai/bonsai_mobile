import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/models/gardener.dart';
import 'package:thanhson/src/features/screens/forget-password/add_new_password.dart';
import "package:flutter_verification_code/flutter_verification_code.dart";

class CodeForResetPassword extends StatefulWidget {
  final Gardener gardener;
  const CodeForResetPassword({super.key, required this.gardener});

  @override
  State<CodeForResetPassword> createState() => _CodeForResetPasswordState();
}

class _CodeForResetPasswordState extends State<CodeForResetPassword> {
  late Size mediaSize;
  late int code;
  late String inputCode;

  @override
  void initState() {
    super.initState();
    generateCode();
    sendEmail();
  }

  Future<void> generateCode() async {
    int min = 100000;
    int max = 999999;
    Random random = Random();
    int randomNumber = min + random.nextInt(max - min + 1);
    setState(() {
      code = randomNumber;
    });
  }

  Future sendEmail() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = "service_35f5igi";
    const templateId = "template_okhcbkk";
    const userId = "Gzp47JoNwGhKaXoZ3";
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          "origin": "http://ronalbo2610-001-site1.ftempurl.com"
        },
        body: json.encode({
          "service_id": serviceId,
          "template_id": templateId,
          "user_id": userId,
          "template_params": {
            "user_email": widget.gardener.email,
            "user_name": widget.gardener.name,
            "code": code,
          }
        }));
    return response.statusCode;
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: greyColor,
      ),
      body: Container(
        width: mediaSize.width,
        color: greyColor,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(
                  image: AssetImage(logoGreen),
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: Text(
                    'Nhập mã xác thực',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "We have sent a code to your email for reset password:"),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: VerificationCode(
                    length: 6,
                    textStyle:
                        const TextStyle(fontSize: 20, color: Colors.black),
                    underlineColor: Colors.black,
                    keyboardType: TextInputType.number,
                    underlineUnfocusedColor: Colors.black,
                    onCompleted: (value) {
                      setState(() {
                        inputCode = value;
                        if (inputCode == code.toString()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewPassword(),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: "Wrong code",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER);
                        }
                      });
                    },
                    onEditing: (value) {},
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  width: mediaSize.width,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      "Xác nhận".toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
