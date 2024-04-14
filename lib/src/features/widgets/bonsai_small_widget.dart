import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/order.dart';

class BonsaiDetailWidget extends StatelessWidget {
  final BonsaiDetail bonsaiDetail;

  const BonsaiDetailWidget({super.key, required this.bonsaiDetail});

  @override
  Widget build(BuildContext context) {
    String firstImageUrl = bonsaiDetail.bonsaiImages.isNotEmpty
        ? bonsaiDetail.bonsaiImages.first
        : '';
    String formatPrice(String price) {
      String formattedPrice = '';
      int count = 0;
      for (int i = price.length - 1; i >= 0; i--) {
        formattedPrice = '${price[i]}$formattedPrice';
        count++;
        if (count % 3 == 0 && i > 0) {
          formattedPrice = '.$formattedPrice';
        }
      }
      return formattedPrice;
    }

    return ListTile(
      leading: Image.network(firstImageUrl),
      title: Text(
        bonsaiDetail.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text('đ${formatPrice(bonsaiDetail.price.toString())}',  textAlign: TextAlign.right,)
    );
    
  }
}
