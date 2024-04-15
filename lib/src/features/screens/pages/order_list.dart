import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/controllers/order_controller.dart';
import 'package:thanhson/src/features/models/order.dart';
import 'package:thanhson/src/features/screens/pages/order_detail.dart';
import 'package:thanhson/src/features/widgets/order_widget.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<Order> orders = [];
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    List<Order> fetchedData = await fetchData(context);
    setState(() {
      orders = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
   final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Đơn hàng cần giao',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: RefreshIndicator(
            onRefresh: initializeData,
            backgroundColor: greyColor,
            color: mainColor,
            child: (orders.isEmpty || orders == [])
                ? Center(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: screenHeight / 3,
                                    ),
                                    const Text(
                                        'Bạn không có đơn hàng nào trong ngày hôm nay')
                                  ]),
                            ))))
                : Container(
                    color: greyColor,
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetail(orderId: orders[index].orderId),
                              ),
                            );
                          },
                          child: OrderWidget(order: orders[index]),
                        );
                      },
                    ),
                  )));
  }
}
