import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/constants/texts.dart';
import 'package:thanhson/src/features/models/working_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:thanhson/src/features/controllers/calendar_controller.dart';
import 'package:thanhson/src/features/screens/pages/bonsai_detail.dart';
import 'package:thanhson/src/features/screens/pages/progress.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  final String contractId;

  const Detail({required this.contractId, super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late WorkingDetail _workingDetail;
  late bool _loading;
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future refresh() async {
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    WorkingDetail fetchedData = await getWorkingDetail(widget.contractId);
    setState(() {
      _workingDetail = fetchedData;
      _loading = false;
    });
  }

  int current = 0;

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
            'Chi tiết',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () async {
                final Uri url = Uri(
                    scheme: 'tel', path: _workingDetail.customerPhoneNumber);
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
                DateTime today = DateTime.now();
                DateTime startDate = _workingDetail.startDate;
                DateTime endDate = _workingDetail.endDate;

                DateTime todayDate =
                    DateTime(today.year, today.month, today.day);
                DateTime startDateDate =
                    DateTime(startDate.year, startDate.month, startDate.day);
                DateTime endDateDate =
                    DateTime(endDate.year, endDate.month, endDate.day + 1);
                bool isButtonVisible = startDateDate.isBefore(todayDate) &&
                        endDateDate.isAfter(todayDate) ||
                    todayDate == startDateDate ||
                    todayDate == endDateDate;
                String formattedStartDate =
                    DateFormat('dd/MM/yyyy').format(_workingDetail.startDate);
                String formattedEndDate =
                    DateFormat('dd/MM/yyyy').format(_workingDetail.endDate);

                return SafeArea(
                  child: Column(
                    children: [
                      if (_workingDetail.images.isEmpty)
                        const Image(
                          image: AssetImage(notfound),
                          fit: BoxFit.cover,
                        ),
                      if (_workingDetail.images.isNotEmpty)
                        CarouselSlider(
                          items: _workingDetail.images
                              .map((item) => SizedBox(
                                    width: double.infinity,
                                    child: Image.network(
                                      item,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: true,
                              viewportFraction: 1,
                              onPageChanged: ((index, reason) {
                                setState(() {
                                  current = index;
                                });
                              })),
                        ),
                      if (_workingDetail.images.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ..._workingDetail.images.map((url) {
                              int index = _workingDetail.images.indexOf(url);
                              return Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: current == index
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ],
                        ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          child: Text(
                            _workingDetail.serviceType == 1
                                ? bonsaiService
                                : gardenService,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )),
                      Text(
                        "$formattedStartDate - $formattedEndDate",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      Visibility(
                        visible: _workingDetail.serviceType == 1,
                        child: TextButton(
                          onPressed: () {
                           Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BonsaiDetail(
                                          bonsaiId: _workingDetail.customerBonsaiId,
                                        )),
                              );
                          },
                          child: const Text(
                            'Xem chi tiết bonsai',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const Divider(
                            thickness: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.topLeft,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Địa chỉ: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _workingDetail.address,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Tên Khách hàng: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _workingDetail.customerName,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Số điện thoại: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _workingDetail.customerPhoneNumber,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                      ),
                      const Expanded(
                        child: SizedBox(),
                      ),
                      Visibility(
                        visible: isButtonVisible,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: const Size(300, 40),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Progress(
                                          contractId: widget.contractId,
                                        )),
                              );
                            },
                            child: const Text(
                              'Cập nhật tiến độ công việc',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
