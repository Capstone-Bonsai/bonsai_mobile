import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/constants/images.dart';
import 'package:thanhson/src/features/controllers/bonsai_controller.dart';
import 'package:thanhson/src/features/models/bonsai.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BonsaiDetail extends StatefulWidget {
  final String bonsaiId;

  const BonsaiDetail({required this.bonsaiId, super.key});

  @override
  State<BonsaiDetail> createState() => _BonsaiDetailState();
}

class _BonsaiDetailState extends State<BonsaiDetail> {
  late Bonsai _bonsai;
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
    Bonsai fetchedData = await getBonsai(widget.bonsaiId);
    setState(() {
      _bonsai = fetchedData;
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
            'Chi tiết Bonsai',
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
                return SafeArea(
                  child: Column(
                    children: [
                      if (_bonsai.bonsaiImages.isEmpty)
                        const Image(
                          image: AssetImage(notfound),
                          fit: BoxFit.cover,
                        ),
                      if (_bonsai.bonsaiImages.isNotEmpty)
                        CarouselSlider(
                          items: _bonsai.bonsaiImages
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
                      if (_bonsai.bonsaiImages.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ..._bonsai.bonsaiImages.map((url) {
                              int index = _bonsai.bonsaiImages.indexOf(url);
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
                            _bonsai.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30),
                          )),
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
                                      text: 'Mã bonsai: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.code,
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
                                      text: 'Mô tả: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.description,
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
                                      text: 'Năm trồng: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.yearOfPlanting != null ? _bonsai.yearOfPlanting.toString() : "Không có",
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
                                      text: 'Hoành: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.trunkDimenter != null ? _bonsai.trunkDimenter.toString() : "Không có",
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
                                      text: 'Chiều cao: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.height != null ? _bonsai.height.toString() : "Không có",
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
                                      text: 'Số thân: ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20),
                                    ),
                                    TextSpan(
                                      text: _bonsai.numberOfTrunk != null ? _bonsai.numberOfTrunk.toString() : "Không có",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ]),
                      ),
                    ],
                  ),
                );
              }
            }));
  }
}
