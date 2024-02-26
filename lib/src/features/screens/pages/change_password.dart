import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/texts.dart';
import 'package:thanhson/src/features/controllers/gardener_controller.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late Size mediaSize;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool obscureTextOld = true;
  bool obscureTextNew = true;
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
                child: Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _buildPasswordInputField(
                  "Mật khẩu cũ", oldPasswordController, obscureTextOld),
              const SizedBox(
                height: 20,
              ),
              _buildPasswordInputField(
                  tPassword, newPasswordController, obscureTextNew),
              const SizedBox(
                height: 20,
              ),
              _buildPasswordInputField("Nhâp lại mật khẩu",
                  confirmPasswordController, obscureTextConfirm),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: mediaSize.width,
                child: ElevatedButton(
                  onPressed: () {
                    String newPassword = newPasswordController.text;
                    String oldPassword = oldPasswordController.text;
                    String confirmPassword = confirmPasswordController.text;
                    changePasswordFuture(
                        context, oldPassword, newPassword, confirmPassword);
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
              if (controller == oldPasswordController) {
                obscureTextOld = !obscureTextOld;
              } else if (controller == newPasswordController) {
                obscureTextNew = !obscureTextNew;
              } else if (controller == confirmPasswordController) {
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
