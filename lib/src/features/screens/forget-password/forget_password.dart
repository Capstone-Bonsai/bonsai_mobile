import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/texts.dart';
import 'package:thanhson/src/features/controllers/forget_password_controller.dart';
import 'package:thanhson/src/constants/images.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();

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
        body: Stack(
          children: [
            Container(
              width: mediaSize.width,
              color: greyColor,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Center(
                          child: Image(
                        image: AssetImage(logo),
                        height: 200,
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      const Center(
                        child: Text(
                          'Quên mật khẩu',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(tEmailRequest),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildInputField('Email', emailController),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        width: mediaSize.width,
                        child: ElevatedButton(
                          onPressed: () {
                            String email = emailController.text;
                            checkEmail(context, email);
                          },
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
          ],
        ));
  }}

  Widget _buildInputField(String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person_outline_outlined),
          labelText: text,
          hintText: text,
          border: const OutlineInputBorder(),
          suffixIcon: const IconButton(
            onPressed: null,
            icon: Icon(null),
          )),
    );
  }
