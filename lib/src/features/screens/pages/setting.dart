import 'package:flutter/material.dart';
import 'package:thanhson/src/features/screens/pages/change_password.dart';
import 'package:thanhson/src/features/widgets/box.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/controllers/login_controllers.dart';
import 'package:thanhson/src/features/models/gardener.dart';
import 'package:thanhson/src/features/controllers/gardener_controller.dart';

class Setting extends StatefulWidget {
  final VoidCallback? onPressedCallback;

  const Setting({super.key, this.onPressedCallback});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late Gardener _gardener;
  late bool _loading;
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    Gardener fetchedData = await getGardenerDetail();
    setState(() {
      _gardener = fetchedData;
      _loading = false;
    });
  }

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
        body: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  _loading) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 200),
                    Center(
                      child: CircularProgressIndicator(
                        color: mainColor,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Error fetching data'),
                );
              } else {
                return Container(
                    color: greyColor,
                    child: Column(
                      children: [
                        SizedBox(
                          width: imageSize,
                          height: imageSize,
                          child: ClipOval(
                            child: _gardener.avatar != null &&
                                    _gardener.avatar!.isNotEmpty
                                ? Image.network(
                                    _gardener.avatar!,
                                    fit: BoxFit.cover,
                                    height: 200,
                                    width: 200,
                                  )
                                : const Image(
                                    image: AssetImage(userLogo),
                                    height: 200,
                                    width: 200,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _gardener.name,
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
                          onPressedCallback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ChangePassword()));
                          },
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
                    ));
              }
            }));
  }
}
