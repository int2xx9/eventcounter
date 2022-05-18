import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/eventgroup.dart';
import '../../controllers/event_group_controller.dart';
import 'counter_list_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(eventGroupControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const CounterListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewEventGroupDialog(context, controller),
        tooltip: 'Add a group',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNewEventGroupDialog(
      BuildContext context, EventGroupController controller) {
    final nameController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("Enter new group name"),
                content: TextField(
                  controller: nameController,
                  autofocus: true,
                ),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("Add"),
                    onPressed: () {
                      final eventGroup = EventGroup(
                          id: const Uuid().v4(), name: nameController.text);
                      controller.addEventGroup(eventGroup);
                      controller.save();
                      Navigator.pop(context);
                      _showUndoSnackBar(context, controller, eventGroup.id);
                    },
                  ),
                ]));
  }

  void _showUndoSnackBar(
      BuildContext context, EventGroupController controller, String id) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("An event group has been created"),
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              controller.deleteEventGroup(id);
              controller.save();
            })));
  }
}
