import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/controllers/order_controller.dart';
import 'package:thanhson/src/features/models/order.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thanhson/src/features/widgets/bonsai_big_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetail extends StatefulWidget {
  final String orderId;

  const OrderDetail({required this.orderId, super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];

  void selectImage() async {
    final List<XFile> selectedImage = await imagePicker.pickMultiImage();
    if (selectedImage.isNotEmpty) {
      imageFileList.addAll(selectedImage);
      setState(() {});
    }
  }

  late Order _order;
  late bool _loading;
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future refresh() async {
    setState(() {
      initializeData();
    });
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    Order fetchedData = await getOrder(widget.orderId);
    setState(() {
      _order = fetchedData;
      _loading = false;
    });
  }

  String _getTextForOrderStatus(int phoneNumber) {
    switch (phoneNumber) {
      case 3:
        return 'Đang chuẩn bị hàng';
      case 4:
        return 'Đang giao hàng';
      case 5:
        return 'Đã giao hàng';
      case 6:
        return 'Giao hàng thất bại';
      // Add more cases as needed
      default:
        return 'Không rõ';
    }
  }

  Color _getColorForOrderStatus(int status) {
    switch (status) {
      case 6:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColor,
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
            'Chi tiết đơn hàng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () async {
                final Uri url =
                    Uri(scheme: 'tel', path: _order.customerPhoneNumber);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            ),
          ],
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
                return SafeArea(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                            child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children:
                                    _order.bonsaiDetail.map((bonsaiDetail) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: BonsaiBigDetailWidget(
                                      bonsaiDetail: bonsaiDetail,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Địa chỉ: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _order.address,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Số điện thoại: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _order.customerPhoneNumber,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Ngày đặt hàng: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat('dd/MM/yyyy')
                                            .format(_order.orderDate),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Trạng thái: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _getTextForOrderStatus(
                                            _order.orderStatus),
                                        style: TextStyle(
                                          color: _getColorForOrderStatus(
                                              _order.orderStatus),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          selectImage();
                                        },
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          child: const Image(
                                            image: AssetImage(addImage),
                                            height: 100,
                                            width: 100,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                                imageFileList.length, (index) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Image.file(
                                                  File(imageFileList[index]
                                                      .path),
                                                  fit: BoxFit.cover,
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: ElevatedButton(
                                      onPressed: (_order.orderStatus == 3)
                                          ? () {
                                              showDialog(
                                                  context: (context),
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: const Text(
                                                            'Bạn có chắc đơn hàng đang trên đường giao tới khách hàng?',
                                                            style: TextStyle(
                                                                fontSize: 20
                                                              ),),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                            ),
                                                            child: const Text(
                                                                'Không'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            style: TextButton
                                                                .styleFrom(
                                                              textStyle: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge,
                                                            ),
                                                            child: const Text(
                                                                'Có'),
                                                            onPressed: () {
                                                              changeOrderStatus(
                                                                  context,
                                                                  _order
                                                                      .orderId,
                                                                  4);
                                                              refresh();
                                                            },
                                                          ),
                                                        ],
                                                      ));
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF828BC4), // Change the color as needed
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                      ),
                                      child: const Text(
                                        'Đang giao hàng',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                    onPressed: (_order.orderStatus == 4)
                                        ? () {
                                            showDialog(
                                                context: (context),
                                                builder: (context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          'Bạn có chắc chắn đơn hàng giao không thành công?',
                                                          style: TextStyle(
                                                                fontSize: 20
                                                              ),),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          child: const Text(
                                                              'Không'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            textStyle: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge,
                                                          ),
                                                          child:
                                                              const Text('Có'),
                                                          onPressed: () {
                                                            changeOrderStatus(
                                                                context,
                                                                _order.orderId,
                                                                7);
                                                            refresh();
                                                          },
                                                        ),
                                                      ],
                                                    ));
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFD84557),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                    ),
                                    child: const Text(
                                      'Không thành công',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: (_order.orderStatus == 4)
                                        ? () {
                                            showDialog(
                                                context: (context),
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: const Text(
                                                              'Bạn có chắc chắn đơn hàng giao thành công?',
                                                              style: TextStyle(
                                                                fontSize: 20
                                                              ),),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge,
                                                              ),
                                                              child: const Text(
                                                                  'Không'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            ),
                                                            TextButton(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                textStyle: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge,
                                                              ),
                                                              child: const Text(
                                                                  'Có'),
                                                              onPressed: () {
                                                                if (imageFileList
                                                                        .isEmpty ||
                                                                    imageFileList ==
                                                                        []) {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            "Đã xảy ra lỗi!"),
                                                                        content:
                                                                            const Text("Vui lòng thêm ảnh giao hàng."),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            child:
                                                                                const Text("OK"),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                } else {
                                                                  sendImagesToAPI(
                                                                          context,
                                                                          _order
                                                                              .orderId,
                                                                          imageFileList)
                                                                      .then(
                                                                          (_) {
                                                                    refresh();
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          ],
                                                        ));
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF46C263),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                    ),
                                    child: const Text(
                                      'Thành công',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))));
              }
            }));
  }
}
