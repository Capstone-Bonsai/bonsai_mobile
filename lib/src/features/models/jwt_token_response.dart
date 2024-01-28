class JWTTokenResponse{
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String avatar;
  final String token;
  final String role;

  JWTTokenResponse({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.avatar,
    required this.token,
    required this.role,
  });

  factory JWTTokenResponse.fromJson(Map<String, dynamic> json) {
  return JWTTokenResponse(
    id: json['id'],
    username: json['username'],
    fullName: json['fullName'],
    email: json['email'],
    avatar: json['avatar'],
    token: json['token'],
    role: json['role'],
  );
}
}