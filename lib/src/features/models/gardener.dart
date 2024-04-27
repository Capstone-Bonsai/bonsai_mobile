
class Gardener{
  final String name;
  final String? avatar;
  final String email;
  final String phoneNumber;
  final String userName;
  Gardener({
    required this.name,
    this.avatar,
    required this.email,
    required this.phoneNumber,
    required this.userName
  });
  factory Gardener.fromJson(Map<String, dynamic> json) {
    return Gardener(
      name: json['fullname'] ,
      avatar: json['avatarUrl'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? "", 
      userName: json['userName'],
    );
  }
}