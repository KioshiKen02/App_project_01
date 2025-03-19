import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:project_01/provider/event.dart';
import 'package:project_01/theme/themeprovider.dart';
import 'package:project_01/pages/add_event.dart';

class CalendarPages extends StatefulWidget {
  const CalendarPages({super.key});

  @override
  State<CalendarPages> createState() => _CalendarPagesState();
}

class _CalendarPagesState extends State<CalendarPages> {
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    await eventProvider.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final eventProvider = Provider.of<EventProvider>(context);

    // Convert events list to a map grouped by date
    final Map<DateTime, List<Map<String, dynamic>>> eventsByDate = {};
    for (var event in eventProvider.events) {
      DateTime eventDate = DateTime.parse(event['date']);
      eventDate = DateTime(eventDate.year, eventDate.month, eventDate.day); // Remove time part
      eventsByDate[eventDate] = eventsByDate[eventDate] ?? [];
      eventsByDate[eventDate]!.add(event);
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'en_US',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2090, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) => setState(() => _calendarFormat = format),

              // 🔹 Mark days with events
              eventLoader: (day) {
                DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                return eventsByDate[normalizedDay] ?? [];
              },

              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 15,
                ),
                weekendStyle: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                ),
              ),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: isDarkMode ? Colors.blue : Colors.black,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red, // Event marker color
                  shape: BoxShape.circle,
                ),
                markersAlignment: Alignment.bottomCenter,
                weekendTextStyle: const TextStyle(color: Colors.red),
                defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: isDarkMode ? Colors.white : Colors.grey),
                rightChevronIcon: Icon(Icons.chevron_right, color: isDarkMode ? Colors.white : Colors.grey),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddEvent page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEvent(selectedDay: _selectedDay),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}