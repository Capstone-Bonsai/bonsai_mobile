class Bonsai{
  final List<String> bonsaiImages;
  final String name;
  final String code;
  final String description;
  final int? yearOfPlanting;
  final int? trunkDimenter;
  final double? height;
  final int? numberOfTrunk;
  Bonsai({
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
    Map<String, dynamic> bonsaiJson = json['bonsai'];
    return Bonsai(
       bonsaiImages: (bonsaiJson['bonsaiImages'] as List<dynamic>?)
        ?.map((image) => image['imageUrl'].toString())
        .toList() ?? [],
      name: bonsaiJson['name'] ?? "",
      code: bonsaiJson['code'] ?? "", 
      description: bonsaiJson['description'] ?? "",
      yearOfPlanting: bonsaiJson['yearOfPlanting'],
      trunkDimenter: bonsaiJson['trunkDimenter'],
      height: bonsaiJson['height'].toDouble(),
      numberOfTrunk: bonsaiJson['numberOfTrunk']
    );
  }
}