class WorkingDetail{
  final String id;
  final String customerBonsaiId;
  final List<String> images;
  final String address;
  final String customerName;
  final String customerPhoneNumber;
  final DateTime startDate;
  final DateTime endDate;
  final int serviceType;
  WorkingDetail({
    required this.id,
    required this.customerBonsaiId,
    required this.images,
    required this.address,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.startDate,
    required this.endDate,
    required this.serviceType
  });
  factory WorkingDetail.fromJson(Map<String, dynamic> json) {
    return WorkingDetail(
      id: json['id'] ?? "",
      customerBonsaiId: json['customerBonsaiId'] ?? "",
      images: List<String>.from((json['image'] as List<dynamic>? ?? []).map((image) => image.toString())),
      address: json['address'] ?? "",
      customerName: json['customerName'] ?? "", 
      customerPhoneNumber: json['customerPhoneNumber'] ?? "",
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      serviceType: json['serviceType'],
    );
  }
}