class Gardener{
  final int id;
  final String name;
  final String image;
  final String email;
  Gardener({
    required this.id,
    required this.name,
    required this.image,
    required this.email
  });
}
Gardener gardener = Gardener(
    id: 1,
    name: "Đỗ Thành Bộ",
    image: "https://www.thrive.org.uk/files/images/News/_hero/Beardy-Gardener-Leigh-1.jpg",
    email: "ronalbo2610@gmail.com"
  );