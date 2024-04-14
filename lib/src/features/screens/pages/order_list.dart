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
  late bool _loading;
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    List<Order> fetchedData = await fetchData();
    setState(() {
      orders = fetchedData;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Đơn cần giao',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body:  _loading
            ? _buildLoadingIndicator()
            : RefreshIndicator(
                onRefresh: initializeData,
                backgroundColor: greyColor,
                color: mainColor,
                child:  FutureBuilder(
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
                return (orders.isEmpty || orders == [])
                    ? const Center(
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Bạn không có đơn hàng nào trong hôm nay'),
                            ],
                          ),
                        ),
                      )
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
                                    builder: (context) => OrderDetail(
                                        orderId: orders[index].orderId),
                                  ),
                                );
                              },
                              child: OrderWidget(order: orders[index]),
                            );
                          },
                        ),
                      );
              }
            })));
  }
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: mainColor,
        backgroundColor: greyColor,
      ),
    );
  }
}
