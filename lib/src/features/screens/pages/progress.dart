import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:thanhson/src/features/models/working_process.dart';
import 'package:thanhson/src/features/controllers/task_controller.dart';
import 'package:thanhson/src/features/widgets/task.dart';

class Progress extends StatefulWidget {
  final String contractId;

  const Progress({required this.contractId, super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  late WorkingProcess _workingProcess;
  late bool _loading;
  final List<String> _taskId = [];
  bool _firstLoading = true;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    if (_firstLoading) {
      await _updateWorkingProcess();
      setState(() {
        _firstLoading = false;
      });
    } else {
      await _updateWorkingProcess();
    }
  }

  Future<void> _updateWorkingProcess() async {
    setState(() {
      _loading = true;
    });

    WorkingProcess fetchedData = await fetchData(widget.contractId);

    setState(() {
      _workingProcess = fetchedData;
      _loading = false;
    });
  }

  void addTaskId(String taskId) {
    if (!_taskId.contains(taskId)) {
      setState(() {
        _taskId.add(taskId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: greyColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Công việc',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: _loading
            ? _buildLoadingIndicator()
            : RefreshIndicator(
                onRefresh: initializeData,
                backgroundColor: greyColor,
                color: mainColor,
                child: _workingProcess.serviceTasks.isEmpty
                    ? const Center(
                        child: Text('There is no task for today'),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(20.0),
                              itemCount: _workingProcess.serviceTasks.length,
                              itemBuilder: (context, index) {
                                ServiceTask serviceTask =
                                    _workingProcess.serviceTasks[index];
                                return TaskPage(
                                  serviceTask: serviceTask,
                                  onTaskCompleted: () {
                                    addTaskId(serviceTask.id);
                                  },
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              minimumSize: const Size(300, 40),
                            ),
                            onPressed: () {
                              if (_taskId.isNotEmpty) {
                                updateWorkingProcesses(
                                    context, widget.contractId, _taskId);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Thông báo"),
                                      content:
                                          const Text("Chưa chọn công việc nào"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text(
                              'Cập nhật',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: mainColor,
        backgroundColor: greyColor,
      ),
    );
  }
}
