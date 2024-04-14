import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/order.dart';

class BonsaiBigDetailWidget extends StatelessWidget {
  final BonsaiDetail bonsaiDetail;

  const BonsaiBigDetailWidget({super.key, required this.bonsaiDetail});

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

    return Container(
            width: 200,
            color: Colors.transparent,
            child: Material(
            elevation: 10, 
            shape:const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            clipBehavior: Clip.antiAlias, 
            child: Column(
                    children: [            
                      Image.network(firstImageUrl, width: 200, height: 250,),
                      const SizedBox(height: 10), 
                      Text(
                        bonsaiDetail.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        formatPrice(bonsaiDetail.price.toString()),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      ],
                    )
    ));
  }
}
