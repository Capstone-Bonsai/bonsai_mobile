class WorkingDate{
  final DateTime startDate;
  final DateTime endDate;
  final String title;
  WorkingDate({
    required this.startDate,
    required this.endDate,
    required this.title
  });
}
List<WorkingDate> workingDates=[
  WorkingDate(
    startDate: DateTime(2024, 1, 19),
    endDate: DateTime(2024, 1, 24),
    title: "Tỉa lá ở địa chỉ ABC",
    ),
    WorkingDate(
    startDate: DateTime(2024, 1, 27),
    endDate: DateTime(2024, 1, 29),
    title: "Valentine's Day Holiday",
  ),
  WorkingDate(
    startDate: DateTime(2023, 12, 31),
    endDate: DateTime(2023, 12, 31),
    title: "Test date",
  )
];