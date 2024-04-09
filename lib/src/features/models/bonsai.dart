class Bonsai{
  final String id;
  final List<String> bonsaiImages;
  final String name;
  final String code;
  final String description;
  final int? yearOfPlanting;
  final int? trunkDimenter;
  final int? height;
  final int? numberOfTrunk;
  Bonsai({
    required this.id,
    required this.bonsaiImages,
    required this.name,
    required this.code,
    required this.description,
    this.yearOfPlanting,
    this.trunkDimenter,
    this.height,
    this.numberOfTrunk
  });
  factory Bonsai.fromJson(Map<String, dynamic> json) {
    return Bonsai(
      id: json['bonsai']['id'] ?? "",
      bonsaiImages: List<String>.from((json['bonsai']['bonsaiImages'] as List<dynamic>? ?? []).map((image) => image.toString())),
      name: json['bonsai']['name'] ?? "",
      code: json['bonsai']['code'] ?? "", 
      description: json['bonsai']['description'] ?? "",
      yearOfPlanting: json['bonsai']['yearOfPlanting'],
      trunkDimenter: json['bonsai']['trunkDimenter'],
      height: json['bonsai']['height'],
      numberOfTrunk: json['bonsai']['numberOfTrunk']
    );
  }
}