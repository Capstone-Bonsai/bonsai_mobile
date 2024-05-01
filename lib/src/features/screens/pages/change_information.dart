import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/controllers/gardener_controller.dart';
import 'package:thanhson/src/features/models/gardener.dart';

class ChangeInformation extends StatefulWidget {
  const ChangeInformation({super.key});

  @override
  State<ChangeInformation> createState() => _ChangeInformationState();
}

class _ChangeInformationState extends State<ChangeInformation> {
  late Size mediaSize;
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  late Gardener _gardener;
  bool _loading = false;
  XFile? newImage;
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
      userNameController.text = _gardener.userName;
      nameController.text = _gardener.name;
      phoneNumberController.text = _gardener.phoneNumber;
    });
  }

  void selectImage() async {
    final XFile? selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      newImage = selectedImage;
      setState(() {});
    }
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
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Quản lý thông tin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: _loading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 200),
                Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ),
              ],
            )
          : _buildForm(),
    );
  }

  Widget _buildForm() {
  double imageSize = mediaSize.width * 2 / 5;
  double availableHeight = mediaSize.height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom;
    return SafeArea(
        child: SingleChildScrollView(
            child: Container(
      padding: const EdgeInsets.all(20.0),
      width: mediaSize.width,
      height: availableHeight,
      color: greyColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Stack(
              children: [
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: ClipOval(
                    child: newImage != null
                        ? Image.file(
                            File(newImage!.path),
                            fit: BoxFit.cover,
                          )
                        : _gardener.avatar != null &&
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
                Positioned(
                  bottom: 10.0,
                  right: 10.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      selectImage();
                    },
                    child: const Icon(Icons.camera_alt),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildInputField(
              Icons.face, "Tên", nameController),
          const SizedBox(height: 20),
          _buildInputField(
              Icons.account_circle, "Tên đăng nhập", userNameController),
          const SizedBox(height: 20),
          _buildNumberInputField(Icons.phone_android_sharp, "Số điện thoại",
              phoneNumberController),
          const Spacer(),
          SizedBox(
            width: mediaSize.width,
            child: ElevatedButton(
              onPressed: () {
                updateProfile(context, newImage, nameController.text, userNameController.text, phoneNumberController.text);
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
          ),
        ],
      ),
    )));
  }

  Widget _buildInputField(
      IconData icon, String text, TextEditingController controller) {
    return TextField(
      controller: controller,
      inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z\u00C0-\u024F\u1E00-\u1EFF\\s]")),
    ],
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: text,
        border: const OutlineInputBorder(),
      ),
    );
  }
  Widget _buildNumberInputField(
  IconData icon, String text, TextEditingController controller) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ],
    decoration: InputDecoration(
      prefixIcon: Icon(icon),
      labelText: text,
      border: const OutlineInputBorder(),
    ),
  );
}
}
