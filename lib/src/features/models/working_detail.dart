class WorkingDetail{
  final String title;
  final List<String> image;
  final String location;
  final String customerName;
  final String phoneNumber;
  WorkingDetail({
    required this.title,
    required this.image,
    required this.location,
    required this.customerName,
    required this.phoneNumber
  });
}
 WorkingDetail details = WorkingDetail(
    title: "Tỉa lá cây",
    image:[
      "https://s3-eu-west-1.amazonaws.com/blog-ecotree/blog/0001/01/ad46dbb447cd0e9a6aeecd64cc2bd332b0cbcb79.jpeg",
      "https://cdn.pixabay.com/photo/2018/11/17/22/15/trees-3822149_640.jpg"
    ],
    location: "372B quốc lộ 20, liên nghĩa, đức trọng, lâm đồng",
    customerName: "Đỗ Thành Bộ",
    phoneNumber: "0389212289"
  );