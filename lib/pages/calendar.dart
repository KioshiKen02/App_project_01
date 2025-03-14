import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../database/calendar_helper.dart';
import 'package:provider/provider.dart';
import '../theme/themeprovider.dart'; // Import your ThemeProvider

class CalendarPages extends StatefulWidget {
  const CalendarPages({super.key});

  @override
  State<CalendarPages> createState() => _CalendarPagesState();
}

class _CalendarPagesState extends State<CalendarPages> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime(_focusedDay.year, _focusedDay.month, _focusedDay.day);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadEvents());
  }

  Future<void> _loadEvents() async {
    final dbHelper = DatabaseHelper1.instance;
    final DateTime selectedDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
    final String formattedDate = selectedDate.toIso8601String().split("T")[0];
    final List<Map<String, dynamic>> events = await dbHelper.getEventsByDate(formattedDate);

    setState(() {
      _events[selectedDate] = events.isNotEmpty
          ? events.map((e) => {'id': e['id'], 'title': e['title']}).toList()
          : [];
    });
  }

  void _addEvent() {
    if (_selectedDay == null) return;
    showDialog(
      context: context,
      builder: (context) {
        String eventTitle = "";
        return AlertDialog(
          title: Text("Add Event", style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
          content: TextField(
            onChanged: (value) {
              eventTitle = value;
            },
            decoration: InputDecoration(
              hintText: "Enter event title",
              border: const OutlineInputBorder(),
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
            ),
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (eventTitle.isNotEmpty) {
                  final dbHelper = DatabaseHelper1.instance;
                  final DateTime selectedDate = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                  final String formattedDate = selectedDate.toIso8601String().split("T")[0];

                  await dbHelper.insertEvent(formattedDate, eventTitle);
                  await _loadEvents();

                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              child: Text("Save", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(int id) async {
    final dbHelper = DatabaseHelper1.instance;
    await dbHelper.deleteEvent(id);
    _loadEvents();
  }

  void _editEvent(int id, String currentTitle) {
    TextEditingController controller = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Event", style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color)),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Enter new title",
              border: const OutlineInputBorder(),
              hintStyle: TextStyle(color: Theme.of(context).hintColor),
            ),
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  final dbHelper = DatabaseHelper1.instance;
                  await dbHelper.updateEvent(id, controller.text);
                  _loadEvents();
                }
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: Text("Update", style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

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
                _loadEvents();
              },
              onFormatChanged: (format) => setState(() => _calendarFormat = format),
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
                weekendTextStyle: TextStyle(color: Colors.red),
                defaultTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                holidayTextStyle: TextStyle(color: Colors.red),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Events on ${_selectedDay!.toLocal().toString().split(' ')[0]}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: (_events[_selectedDay] ?? []).map((event) {
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    elevation: 2,
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    child: ListTile(
                      title: Text(event['title'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: isDarkMode ? Colors.blue[200] : Colors.blue),
                            onPressed: () => _editEvent(event['id'], event['title']),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: isDarkMode ? Colors.red[200] : Colors.red),
                            onPressed: () => _deleteEvent(event['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
        child: Icon(Icons.add, color: isDarkMode ? Colors.white : Colors.black),
      ),
    );
  }
}