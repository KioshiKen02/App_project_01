import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/event.dart';

class AddEvent extends StatelessWidget {
  final DateTime? selectedDay;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AddEvent({super.key, this.selectedDay});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter event title',
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter event description',
              ),
              maxLines: 3,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) async {
                if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
                  await eventProvider.addEvent(
                    _titleController.text,
                    _descriptionController.text,
                    selectedDay ?? DateTime.now(),
                    false,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _titleController.clear();
                    _descriptionController.clear();
                  },
                  child: const Text('Clear'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill in all fields')),
                      );
                      return;
                    }

                    await eventProvider.addEvent(
                      _titleController.text,
                      _descriptionController.text,
                      selectedDay ?? DateTime.now(),
                      false,
                    );
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Save Event'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}