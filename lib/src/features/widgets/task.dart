import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/working_process.dart';
import 'package:thanhson/src/constants/colors.dart';

class TaskPage extends StatefulWidget {
  final ServiceTask serviceTask;
  final VoidCallback onTaskCompleted;
  const TaskPage({
    super.key,
    required this.serviceTask,
    required this.onTaskCompleted,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isFinished = widget.serviceTask.completedTime != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isFinished,
      child: GestureDetector(
        onTap: () {
          if (!isFinished) {
            setState(() {
              isFinished = true;
              widget.onTaskCompleted();
            });
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: mainColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              Checkbox(
                value: isFinished,
                onChanged: isFinished
                    ? null
                    : (newValue) {
                        setState(() {
                          isFinished = newValue!;
                        });
                      },
                shape: const CircleBorder(),
                activeColor: isFinished ? Colors.grey : null,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.serviceTask.name,
                      style: TextStyle(
                        fontSize: 20,
                        decoration: isFinished ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (widget.serviceTask.note != null)
                      Text(
                        widget.serviceTask.note!,
                        style: TextStyle(
                        fontSize: 12,
                        decoration: isFinished ? TextDecoration.lineThrough : null,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
