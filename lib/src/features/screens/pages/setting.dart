import 'package:flutter/material.dart';
import 'package:thanhson/src/features/widgets/box.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';
import 'package:thanhson/src/features/models/gardener.dart';

class Setting extends StatefulWidget {
  final VoidCallback? onPressedCallback;

  const Setting({super.key, this.onPressedCallback});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 2 / 3;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Cài đặt',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Container(
            color: greyColor,
            child: Column(
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipOval(
                    child: Image.network(
                      gardener.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  gardener.name,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                Box(
                  titleString: 'Quản lý thông tin',
                  onPressedCallback: () {},
                ),
                const SizedBox(height: 10),
                Box(
                  titleString: 'Đổi mật khẩu',
                  onPressedCallback: () {},
                ),
                const SizedBox(height: 10),
                Box(
                  titleString: 'Đăng xuất',
                  onPressedCallback: () {
                    logoutFuture(context);
                  },
                  isLogout: true,
                ),
              ],
            )));
  }
}
