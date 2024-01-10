import 'package:flutter/material.dart';
import 'package:thanhson/src/features/models/working_process.dart';
import 'package:thanhson/src/constants/colors.dart';

class Task extends StatefulWidget {
  final WorkingProcess workingProcess;

  const Task({
    super.key,
    required this.workingProcess,
  });

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.workingProcess.finished = !widget.workingProcess.finished;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: mainColor, // Set the border color here
            width: 2.0, // Set the border width here
          ),
          borderRadius: BorderRadius.circular(20.0), // Set the border radius here
        ),
        child: Row(
          children: [
            Checkbox(
              shape: const CircleBorder(),
              value: widget.workingProcess.finished,
              onChanged: (bool? value) {
                setState(() {
                  widget.workingProcess.finished = value ?? false;
                });
              },
              activeColor: Colors.grey,
            ),
            Expanded(
              child: Text(
                widget.workingProcess.title,
                style: TextStyle(
                  fontSize: 20,
                  decoration: widget.workingProcess.finished ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
