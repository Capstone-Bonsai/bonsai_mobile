import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart  ';
import 'package:thanhson/src/features/models/working_process.dart';
import 'package:thanhson/src/features/widgets/Task.dart';
import 'package:thanhson/src/features/controllers/task_controller.dart';

class Process extends StatefulWidget {
  const Process({super.key});
  @override
  State<Process> createState() => _ProcessState();
}

class _ProcessState extends State<Process> {
  late List<WorkingProcess> _workingProcess;
  late bool _loading;
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    List<WorkingProcess> fetchedData = await fetchData();
    setState(() {
      _workingProcess = fetchedData;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        backgroundColor: greyColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Công việc',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => initializeData(),
        backgroundColor: greyColor,
        color: greyColor,
        child: FutureBuilder(
          future: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                _loading) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 200),
                  Center(
                    child: CircularProgressIndicator(
                      color: mainColor,
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else {
              return SizedBox(
                child: Column(
                  children: [
                    if (_workingProcess.isEmpty)
                      const Text('There is no task for today')
                    else
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(20.0),
                          itemCount: _workingProcess.length,
                          itemBuilder: (context, index) {
                            WorkingProcess workingProcess =
                                _workingProcess[index];
                            return Task(
                              workingProcess: workingProcess,
                            );
                          },
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            mainColor, // Set the background color to green
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10.0), 
                        ),
                         minimumSize: const Size(300, 40),
                      ),
                      onPressed: () {
                        updateWorkingProcesses(context, _workingProcess);
                      },
                      child: const Text(
                        'Cập nhật',
                        style: TextStyle(
                            color: Colors.white), // Set text color to white
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
