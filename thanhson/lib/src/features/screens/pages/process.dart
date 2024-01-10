import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart  ';
import 'package:thanhson/src/features/models/working_process.dart';
import 'package:thanhson/src/features/widgets/Task.dart';

class Process extends StatefulWidget {
  const Process({super.key});

  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greyColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Công việc',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Container(
        color: greyColor,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: workingProcesses.length,
                itemBuilder: (context, index) {
                  WorkingProcess workingProcess = workingProcesses[index];
                  return Task(workingProcess: workingProcess);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
