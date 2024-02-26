class WorkingDetail{
  final String title;
  final List<String> image;
  final String location;
  final String customerName;
  final String email;
  final String phoneNumber;
  WorkingDetail({
    required this.title,
    required this.image,
    required this.location,
    required this.customerName,
    required this.email,
    required this.phoneNumber
  });
  factory WorkingDetail.fromJson(Map<String, dynamic> json) {
    return WorkingDetail(
      title: json['service']['name'],
      image: List<String>.from(json['serviceImages']?.map((image) => image['imageUrl']) ?? []),
      location: json['address'] ?? "",
      customerName: json['customer']['applicationUser']['fullname'] ?? "", 
      email: json['customer']['applicationUser']['email'] ?? "", 
      phoneNumber: json['customer']['applicationUser']['phoneNumber'] ?? "",
    );
  }
}