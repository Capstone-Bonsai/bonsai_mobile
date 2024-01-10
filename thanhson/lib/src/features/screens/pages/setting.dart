import 'package:flutter/material.dart';
import 'package:thanhson/src/features/widgets/box.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';

class Setting extends StatefulWidget {
  final VoidCallback? onPressedCallback;

  const Setting({super.key, this.onPressedCallback});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          automaticallyImplyLeading: false,
          titleSpacing: 50,
          title: const Text(
            'Setting',
            style: TextStyle(
              fontWeight: FontWeight.bold, // Set text to bold
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Box(
              titleString: 'Change password',
              onPressedCallback: () {},
            ),
            const SizedBox(height: 20),
            Box(
              titleString: 'Log out!',
              onPressedCallback: () {
                logoutFuture(context);
              },
            ),
          ],
        ));
  }
}
