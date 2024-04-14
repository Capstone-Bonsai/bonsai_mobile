class BonsaiDetail {
  final String name;
  final List<String> bonsaiImages;
  final int price;
  BonsaiDetail({
    required this.name,
    required this.bonsaiImages,
    required this.price,
  });
  factory BonsaiDetail.fromJson(Map<String, dynamic> json) {
    List<dynamic>? imageList = json['bonsai']['bonsaiImages'];
    List<String> parsedImageList = imageList != null
        ? List<String>.from(imageList.map((image) {
            if (image is Map<String, dynamic> &&
                image.containsKey('imageUrl')) {
              return image['imageUrl'].toString();
            } else {
              return '';
            }
          }))
        : [];
    return BonsaiDetail(
      name: json['bonsai']['name'],
      bonsaiImages: parsedImageList,
      price: json['bonsai']['price'],
    );
  }
}

class Order {
  final String orderId;
  final String address;
  final String customerPhoneNumber;
  final String deliveryType;
  final String customerName;
  final int numberOfBonsai;
  final DateTime orderDate;
  final List<BonsaiDetail> bonsaiDetail;
  final int orderStatus;
  Order(
      {required this.orderId,
      required this.address,
      required this.deliveryType,
      required this.customerPhoneNumber,
      required this.customerName,
      required this.numberOfBonsai,
      required this.orderDate,
      required this.bonsaiDetail,
      required this.orderStatus});
  factory Order.fromJson(Map<String, dynamic> json) {
    List<dynamic> bonsaiJsonList = json['orderDetails'] ?? [];
    var bonsaiDetail =
        bonsaiJsonList.map((e) => BonsaiDetail.fromJson(e)).toList();
    var deliveryType =
        json.containsKey('deliveryType') ? json['deliveryType'] : "";
    int convertStatusToNumber(String orderStatus) {
      try {
        return int.parse(orderStatus);
      } catch (e) {
        switch (orderStatus) {
          case 'Preparing':
            return 3;
          case 'Delivering':
            return 4;
          default:
            return -1;
        }
      }
    }

    return Order(
      orderId: json['id'],
      address: json['address'] ?? "",
      deliveryType: deliveryType.toString(),
      customerName: json['customer']['applicationUser']['fullname'] ?? "",
      customerPhoneNumber:
          json['customer']['applicationUser']['phoneNumber'] ?? "",
      numberOfBonsai: bonsaiJsonList.length,
      orderDate: DateTime.parse(json['orderDate']),
      bonsaiDetail: bonsaiDetail,
      orderStatus: convertStatusToNumber(json['orderStatus'].toString()),
    );
  }
}
