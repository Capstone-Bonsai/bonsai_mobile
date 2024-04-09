class WorkingDate {
  final String contractId;
  final DateTime startDate;
  final DateTime endDate;
  final String customerName;
  final String customerPhoneNumber;
  final String address;
  WorkingDate({
    required this.contractId,
    required this.startDate,
    required this.endDate,
    required this.customerName,
    required this.customerPhoneNumber,
    required this.address,
  });
  factory WorkingDate.fromJson(Map<String, dynamic> json) {
    return WorkingDate(
        contractId: json['id'],
        startDate: DateTime.parse(json['startDate']),
        endDate: DateTime.parse(json['endDate']),
        customerName: json['customerName'],
        customerPhoneNumber: json['customerPhoneNumber'],
        address: json['address']);
  }
}
