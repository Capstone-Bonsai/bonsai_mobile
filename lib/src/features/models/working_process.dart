class WorkingProcess{
  final String id;
  final String title;
  bool finished;

  WorkingProcess({
    required this.id,
    required this.title,
    required this.finished,
  });
  factory WorkingProcess.fromJson(Map<String, dynamic> json) {
    return WorkingProcess(
      id: json['id'],
      title: json['task']['name'],
      finished: json['serviceTaskStatus'] == 3 ? true : false,
    );
  }
}