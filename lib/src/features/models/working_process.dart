class WorkingProcess {
  final String id;
  final String customerName;
  final String address;
  final List<ServiceTask> serviceTasks;

  WorkingProcess({
    required this.id,
    required this.customerName,
    required this.address,
    required this.serviceTasks,
  });

  factory WorkingProcess.fromJson(Map<String, dynamic> json) {
    final List<dynamic> taskList = json['taskOfServiceOrders'];
    List<ServiceTask> tasks = taskList.map((taskJson) => ServiceTask.fromJson(taskJson)).toList();

    return WorkingProcess(
      id: json['serviceOrderId'],
      customerName: json['customerName'],
      address: json['address'],
      serviceTasks: tasks, 
    );
  }
}

class ServiceTask {
  final String id;
  final String name;
  final String? note;
  final DateTime? completedTime;

  ServiceTask({
    required this.id,
    required this.name,
    this.note,
    this.completedTime,
  });

  factory ServiceTask.fromJson(Map<String, dynamic> json) {
    DateTime? completedTime = json['completedTime'] != null ? DateTime.parse(json['completedTime']) : null;

    return ServiceTask(
      id: json['id'],
      name: json['name'],
      note: json['note'],
      completedTime: completedTime,
    );
  }
}
