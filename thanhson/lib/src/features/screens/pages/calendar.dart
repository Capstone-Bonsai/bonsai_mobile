import 'package:flutter/material.dart';
import 'package:thanhson/src/constants/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:thanhson/src/features/models/working_date.dart';
import 'package:thanhson/src/features/screens/pages/detail.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late DateTime _focusedDay;
  late DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: greyColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Lịch Làm Việc',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
          ),
        ),
        body: Center(
          child: Container(
            color: greyColor,
          child: Column(children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(DateTime.now().year, 1, 1),
              lastDay: DateTime(DateTime.now().year, 12, 31),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                    color: mainColor, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: mainColor, // Set the color of the border (line) here
                    width: 2.0, // Set the width of the border
                  ),
                ),
                todayTextStyle: const TextStyle(
                  color: Colors
                      .black, // Set the color of the text for today's date here
                ),
              ),
              eventLoader: (date) => _getEventsForDay(date),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay =
                      focusedDay; // Update the focused day when a day is selected
                });
                // Handle day selection if needed
              },
            ),
            const SizedBox(
                height: 16.0), // Adjust the space between calendar and events
            Expanded(
              child: _buildEventsList(),
            ),
          ]),
        )));
  }

  List<DateTime> _getEventsForDay(DateTime day) {
    List<DateTime> events = [];

    for (var workingDate in workingDates) {
      if (!day.isBefore(workingDate.startDate) &&
          !day.isAfter(workingDate.endDate.add(const Duration(days: 1)))) {
        events.add(day);
      }
    }

    return events;
  }

  List<String> _getEventTitle(DateTime day) {
    List<String> events = [];

    for (var workingDate in workingDates) {
      if (!day.isBefore(workingDate.startDate) &&
          !day.isAfter(workingDate.endDate.add(const Duration(days: 1)))) {
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
              // Navigate to another page when the container is clicked
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Detail(),
                ),
              );
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
              child: Text(
                events[index],
              ),
            ),
          ),
        ),
      );
    },
  );
}
}