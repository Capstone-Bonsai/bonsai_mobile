import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/order.dart';
import 'package:intl/intl.dart';
import 'package:thanhson/src/features/widgets/bonsai_small_widget.dart';

class OrderWidget extends StatelessWidget {
  final Order order;

  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return  Card(
       elevation: 2,
       shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Địa chỉ: ${order.address}'),
            const SizedBox(height: 4),
            Text('Phương tiện: ${order.deliveryType}'),
            const SizedBox(height: 4),
            Text('Ngày đặt hàng: ${DateFormat('dd/MM/yyyy').format(order.orderDate)}'),
             SizedBox(
              child: ListView.builder(
                shrinkWrap: true, // Use shrinkWrap property
                itemCount: order.bonsaiDetail.length,
                itemBuilder: (context, index) {
                  return BonsaiDetailWidget(bonsaiDetail: order.bonsaiDetail[index]);
                },
              ),)
          ],
        ),
      ),
    );
  }
}
