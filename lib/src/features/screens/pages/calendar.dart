import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thanhson/src/features/controllers/calendar_controller.dart';
import 'package:thanhson/src/features/models/working_date.dart';
import 'package:thanhson/src/features/screens/pages/detail.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<WorkingDate> workingDates = [];
  late DateTime _focusedDay;
  late DateTime? _selectedDay;
  late bool _loading;
  @override
  void initState() {
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      _loading = true;
    });
    List<WorkingDate> fetchedData =
        await fetchData(_focusedDay.month, _focusedDay.year);
    setState(() {
      workingDates = fetchedData;
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
            'Lịch Làm Việc',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: FutureBuilder(
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
                return Container(
                  color: greyColor,
                  child: Column(children: [
                    TableCalendar(
                      focusedDay: _focusedDay,
                      firstDay: DateTime(DateTime.now().year, 1, 1),
                      lastDay: DateTime(DateTime.now().year, 12, 31),
                      selectedDayPredicate: (day) =>
                          isSameDay(_selectedDay, day),
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                        initializeData();
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                            color: mainColor, shape: BoxShape.circle),
                        todayDecoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: mainColor,
                            width: 2.0,
                          ),
                        ),
                        todayTextStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      eventLoader: (date) => _getEventsForDay(date),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: _buildEventsList(),
                    ),
                  ]),
                );
              }
            }));
  }

  List<DateTime> _getEventsForDay(DateTime day) {
    List<DateTime> events = [];

    for (var workingDate in workingDates) {
      // Check if the day matches the working date
      if (day.year == workingDate.date.year &&
          day.month == workingDate.date.month &&
          day.day == workingDate.date.day) {
        events.add(day);
      }
    }

    return events;
  }

  List<String> _getEventTitle(DateTime day) {
    List<String> events = [];

    for (var workingDate in workingDates) {
      if (day.year == workingDate.date.year &&
          day.month == workingDate.date.month &&
          day.day == workingDate.date.day) {
        events.add(workingDate.title);
      }
    }

    return events;
  }

  Widget _buildEventsList() {
    final events = _getEventTitle(_selectedDay ?? DateTime.now());

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Center(
            child: GestureDetector(
              onTap: () {
                if (workingDates.isNotEmpty && index < workingDates.length) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detail(
                          serviceOrderId: workingDates[index].serviceOrderId),
                    ),
                  );
                } else {
                  // Handle the case where workingDates is empty or index is out of range
                  // You may display a message or take appropriate action here
                }
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.green,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        events[index],
                      ),
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}
