import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/constants/texts.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/sizes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';
import 'package:thanhson/src/features/screens/forget-password/forget_password.dart';

bool obscureText = true;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  late Box box1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: mainColor,
        body: Stack(
          children: [
            Positioned(top: 30, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom()),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
        width: mediaSize.width,
        child: const Column(children: [
          SizedBox(height: 40),
          Image(
            image: AssetImage(logo),
            height: 200,
          ),
        ]));
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      height: 450,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        )),
        child: Padding(
            padding: const EdgeInsets.all(20.0), child: _buildFormLogin()),
      ),
    );
  }

  Widget _buildFormLogin() {
    return Form(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              tLogin,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: tFormHeight,
            ),
            _buildInputField(tEmail, emailController),
            const SizedBox(
              height: tFormHeight - 20,
            ),
            _buildPasswordInputField(tPassword, passwordController),
            const SizedBox(
              height: tFormHeight - 20,
            ),
            _buildRememberForgot(),
            const SizedBox(
              height: tFormHeight - 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;
                  loginFuture(context, email, password, rememberUser);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10.0),
                  ),
                ),
                child: Text(
                  tLogin.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

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

  Widget _buildPasswordInputField(
      String text, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.fingerprint),
          labelText: text,
          hintText: text,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            icon: const Icon(Icons.remove_red_eye_sharp),
          )),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Transform.scale(
              scale: 0.7,
              child: Checkbox(
                  value: rememberUser,
                  onChanged: (value) {
                    setState(() {
                      rememberUser = value!;
                    });
                  
                  }),
            ),
            const Text(
              "Ghi nhớ tôi",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgetPassword(),
                ),
              );
            },
            child: const Text(
              "Quên mật khẩu?",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            )),
      ],
    );
  }
}
