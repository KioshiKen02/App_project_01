import 'package:flutter/material.dart';
import 'package:project_01/database/calendar_helper.dart';

class EventProvider with ChangeNotifier {
  final DatabaseHelper1 _databaseHelper = DatabaseHelper1();

  List<Map<String, dynamic>> _events = [];

  List<Map<String, dynamic>> get events => _events;

  Future<void> loadEvents() async {
    final events = await _databaseHelper.getEvents();
    _events = List<Map<String, dynamic>>.from(events); // Ensure the list is modifiable
    notifyListeners();
  }

  Future<void> addEvent(String title, String description, DateTime date, bool isCompleted) async {
    final event = {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0, // Convert bool to int for database
    };
    await _databaseHelper.insertEvent(event);
    await loadEvents();
  }

  Future<void> updateEvent(int id, String title, String description, bool isCompleted) async {
    try {
      final event = {
        'id': id,
        'title': title,
        'description': description,
        'isCompleted': isCompleted ? 1 : 0, // Convert bool to int
      };
      debugPrint('Updating event: $event');
      await _databaseHelper.updateEvent(event);
      await loadEvents();
    } catch (e) {
      debugPrint('Error updating event: $e');
      rethrow; // Rethrow the error to propagate it
    }
  }

  Future<void> deleteEvent(int id) async {
    await _databaseHelper.deleteEvent(id);
    await loadEvents();
  }

  Future<void> toggleEventCompletion(int id) async {
    try {
      final eventIndex = _events.indexWhere((event) => event['id'] == id);
      if (eventIndex != -1) {
        // Create a new map with the updated isCompleted value
        final updatedEvent = Map<String, dynamic>.from(_events[eventIndex]);
        updatedEvent['isCompleted'] = updatedEvent['isCompleted'] == 1 ? 0 : 1;

        // Update the event in the list
        _events[eventIndex] = updatedEvent;

        // Update the event in the database
        await _databaseHelper.updateEvent(updatedEvent);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error toggling event completion: $e');
      rethrow;
    }
  }

  // Sort events by date
  void sortEventsByDate({bool ascending = true}) {
    _events.sort((a, b) {
      final dateA = DateTime.parse(a['date']);
      final dateB = DateTime.parse(b['date']);
      return ascending ? dateA.compareTo(dateB) : dateB.compareTo(dateA);
    });
    notifyListeners();
  }

  // Sort events by title
  void sortEventsByTitle({bool ascending = true}) {
    _events.sort((a, b) {
      final titleA = a['title'].toLowerCase();
      final titleB = b['title'].toLowerCase();
      return ascending ? titleA.compareTo(titleB) : titleB.compareTo(titleA);
    });
    notifyListeners();
  }

  // Search events by title or description
  void searchEvents(String query) {
    if (query.isEmpty) {
      loadEvents(); // Reset to all events if the query is empty
    } else {
      _events = _events
          .where((event) =>
      event['title'].toLowerCase().contains(query.toLowerCase()) ||
          event['description'].toLowerCase().contains(query.toLowerCase()))
          .toList();
      notifyListeners();
    }
  }

}