class WorkingDate {
  final DateTime startDate;
  final DateTime endDate;
  final String name;
  final String location;
  WorkingDate({
    required this.startDate,
    required this.endDate,
    required this.name,
    required this.location,
  });
  factory WorkingDate.fromJson(Map<String, dynamic> json) {
    String dateString = json['date']['iso'];
    DateTime date = DateTime.parse(dateString);
    return WorkingDate(
      startDate: date,
      endDate: date,
      name: json['name'],
      location: json['description'],
    );
  }
}
