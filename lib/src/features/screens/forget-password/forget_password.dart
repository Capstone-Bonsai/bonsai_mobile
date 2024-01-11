import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/texts.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>{
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
     appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Quên mật khẩu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Container(
          width: mediaSize.width,
          color: greyColor,
          child:
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Text(
              tEmailRequest
            ),
            const SizedBox(
              height:  20,
            ),
          _buildInputField(tEmail, emailController),
          ]),
        ),
    ));
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
}