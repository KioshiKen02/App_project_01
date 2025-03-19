import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:project_01/provider/event.dart';

class NotePages extends StatelessWidget {
  const NotePages({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final events = eventProvider.events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sort By'),
        leadingWidth: 20,
        leading: IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => _showSortOptions(context, eventProvider),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, eventProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await eventProvider.loadEvents();
        },
        child: events.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_note, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "No notes available.\nGo to calendar and tap '+' to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];

            // Parse the stored UTC DateTime
            final eventDateTime = DateTime.parse(event['date']).toUtc();

            // Convert to Philippine time (PHT, UTC+8)
            final eventDateTimePHT = eventDateTime.add(const Duration(hours: 8));

            // Format the DateTime in PHT
            final formattedDateTime = DateFormat('yyyy-MM-dd hh:mm a').format(eventDateTimePHT);

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Slidable(
                key: ValueKey(event['id']),
                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) => _editEvent(context, event, eventProvider),
                      backgroundColor: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                    SlidableAction(
                      onPressed: (context) => _confirmDeleteEvent(context, event['id'], eventProvider),
                      backgroundColor: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: event['isCompleted'] == 1, // Convert int to bool
                    onChanged: (value) async {
                      try {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Mark as Complete?"),
                              content: const Text("Are you sure you want to mark this event as complete?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Confirm"),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirmed == true) {
                          await eventProvider.toggleEventCompletion(event['id']);
                        }
                      } catch (e) {
                        debugPrint('Error toggling event completion: $e');
                        // Show Flushbar for successful offline login
                        if (!context.mounted) return;
                        await Flushbar(
                          message: 'An error occurred while updating the event.',
                          duration: const Duration(seconds: 3),
                          backgroundColor: Colors.red,
                          flushbarPosition: FlushbarPosition.TOP,
                          borderRadius: BorderRadius.circular(10),
                          margin: const EdgeInsets.all(10),
                          icon: const Icon(Icons.check_circle, color: Colors.white),
                        ).show(context);
                      }
                    },
                  ),
                  title: Text(
                    event['title'],
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: event['isCompleted'] == 1 ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    "$formattedDateTime PHT",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: event['isCompleted'] == 1 ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  ),
                  onTap: () => _showEventDetails(context, event, formattedDateTime),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event, String formattedDateTime) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              event['title'],
              textAlign: TextAlign.center,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date & Time Created: $formattedDateTime",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text("Status: ${event['isCompleted'] == 1 ? 'Completed' : 'Not Completed'}"),
              const SizedBox(height: 20),
              const Text("Description:"),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  event['description'] ?? 'No details available',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editEvent(BuildContext context, Map<String, dynamic> event, EventProvider eventProvider) async {
    try {
      TextEditingController titleController = TextEditingController(text: event['title']);
      TextEditingController descriptionController = TextEditingController(text: event['description']);
      bool isCompleted = event['isCompleted'] == 1; // Convert int to bool

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Edit Note"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleController, decoration: const InputDecoration(labelText: "Title")),
                    const SizedBox(height: 10),
                    TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text("Completed"),
                        Checkbox(
                          value: isCompleted,
                          onChanged: (value) {
                            // Update the state using setState
                            setState(() {
                              isCompleted = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  TextButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                        eventProvider.updateEvent(
                          event['id'],
                          titleController.text,
                          descriptionController.text,
                          isCompleted, // Pass bool directly
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Error editing event: $e');
      if (!context.mounted) return;
      // Show Flushbar for successful offline login
      await Flushbar(
        message: 'An error occurred while editing the event.',
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(10),
        margin: const EdgeInsets.all(10),
        icon: const Icon(Icons.check_circle, color: Colors.white),
      ).show(context);
    }
  }
  void _confirmDeleteEvent(BuildContext context, int eventId, EventProvider eventProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Note"),
          content: const Text("Are you sure you want to delete this note?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () {
                eventProvider.deleteEvent(eventId);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context, EventProvider eventProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sort Notes"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Sort by Date (Oldest First)"),
                onTap: () {
                  eventProvider.sortEventsByDate(ascending: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Sort by Date (Newest First)"),
                onTap: () {
                  eventProvider.sortEventsByDate(ascending: false);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Sort by Title (A-Z)"),
                onTap: () {
                  eventProvider.sortEventsByTitle(ascending: true);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text("Sort by Title (Z-A)"),
                onTap: () {
                  eventProvider.sortEventsByTitle(ascending: false);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context, EventProvider eventProvider) {
    final TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Search Notes"),
          content: TextField(
            controller: searchController,
            decoration: const InputDecoration(hintText: "Search by title or description"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                eventProvider.searchEvents(searchController.text);
                Navigator.pop(context);
              },
              child: const Text("Search"),
            ),
          ],
        );
      },
    );
  }
}