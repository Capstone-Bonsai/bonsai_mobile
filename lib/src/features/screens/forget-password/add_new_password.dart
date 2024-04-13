import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/texts.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/controllers/forget_password_controller.dart';

class AddNewPassword extends StatefulWidget {
  final String email;
  final String otp;

  const AddNewPassword({super.key, required this.email, required this.otp});

  @override
  State<AddNewPassword> createState() => _AddNewPasswordState();
}

class _AddNewPasswordState extends State<AddNewPassword> {
  late Size mediaSize;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  bool obscureText = true;
  bool obscureTextConfirm = true;
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
        padding: const EdgeInsets.all(20.0),
        width: mediaSize.width,
        height: mediaSize.height,
        color: greyColor,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  'Đặt lại mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Hãy nhập mật khẩu mới cho tài khoản.'),
              const SizedBox(
                height: 20,
              ),
              _buildPasswordInputField(
                  tPassword, passwordController, obscureText),
              const SizedBox(
                height: 20,
              ),
              _buildPasswordInputField("Nhâp lại mật khẩu",
                  passwordConfirmController, obscureTextConfirm),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: mediaSize.width,
                child: ElevatedButton(
                  onPressed: () {
                    String newPassword = passwordController.text;
                    String confirmPassword = passwordConfirmController.text;
                    resetPassword(context, widget.email, widget.otp,
                        newPassword, confirmPassword);
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
    );
  }

  Widget _buildPasswordInputField(
      String text, TextEditingController controller, bool inputObscure) {
    return TextFormField(
      controller: controller,
      obscureText: inputObscure,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.fingerprint),
        labelText: text,
        hintText: text,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              if (controller == passwordController) {
                obscureText = !obscureText;
              } else if (controller == passwordConfirmController) {
                obscureTextConfirm = !obscureTextConfirm;
              }
            });
          },
          icon: Icon(
            inputObscure
                ? Icons.remove_red_eye_sharp
                : Icons.remove_red_eye_outlined,
          ),
        ),
      ),
    );
  }
}
