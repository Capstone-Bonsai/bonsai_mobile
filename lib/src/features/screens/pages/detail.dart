import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/models/working_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
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
        ),
        body: SizedBox(
          child: Column(
            children: [
              CarouselSlider(
                items: details.image
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: details.image.map((url) {
                  int index = details.image.indexOf(url);
                  return Container(
                    width: 8,
                    height: 8,
                    margin:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current == index ? Colors.black : Colors.grey,
                    ),
                  );
                }).toList(),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    details.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const WidgetSpan(
                        child: Icon(Icons.location_on_outlined, size: 30),
                      ),
                      TextSpan(
                        text: details.location,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                              text: 'Tên Khách hàng: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 20),
                            ),
                            TextSpan(
                              text: details.customerName,
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
                              text: details.phoneNumber,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20),
                            ),
                          ],
                        ),
                      )
                    ]),
              )
            ],
          ),
        ));
  }
}
