import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/gardener.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thanhson/src/features/screens/forget-password/code_for_reset_password.dart';


Future checkEmail(BuildContext context, String email) async {
  // Check email here

  if (email == "ronalbo2610@gmail.com") {
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => CodeForResetPassword(gardener: gardener)),
    );
    Fluttertoast.showToast(
      msg: "We have sent a code to your email!",
    );
  } else {
    // Handle other error cases here.
    Fluttertoast.showToast(
      msg: "Wrong email!",
    );
  }
}
