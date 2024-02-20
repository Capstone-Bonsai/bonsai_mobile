class WorkingDate {
  final String serviceOrderId;
  final DateTime date;
  final String title;
  final String location;
  WorkingDate({
    required this.serviceOrderId,
    required this.date,
    required this.title,
    required this.location,
  });
  factory WorkingDate.fromJson(Map<String, dynamic> json) {
    return WorkingDate(
        serviceOrderId: json['serviceOrderId'],
        date: DateTime.parse(json['date']),
        title: json['serviceOrder']['address'],
        location: json['serviceOrder']['address']);
  }
}
