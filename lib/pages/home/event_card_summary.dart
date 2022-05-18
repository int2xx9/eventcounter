import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../models/event.dart';
import '../../models/eventgroup.dart';
import '../../controllers/event_group_controller.dart';

class EventCardSummary extends ConsumerWidget {
  final EventGroup eventGroup;
  final Event event;
  final bool canDelete;

  const EventCardSummary(this.eventGroup, this.event, {this.canDelete = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(eventGroupControllerProvider);
    final textController = TextEditingController(text: event.summary);
    textController.selection = TextSelection.fromPosition(
        TextPosition(offset: textController.text.length));
    return Card(
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, right: 12, bottom: 16, top: 16),
            child: Column(children: [
              Row(children: [
                Text(_getEventDateString(),
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Colors.grey)),
              ]),
              FocusScope(
                onFocusChange: (value) {
                  controller.updateEvent(eventGroup.id,
                      event.copyWith(summary: textController.text));
                  controller.save();
                },
                child: TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    controller.updateEvent(
                        eventGroup.id, event.copyWith(summary: value));
                    controller.save();
                  },
                ),
              ),
              Visibility(
                visible: canDelete,
                child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () =>
                          _showDeleteConfirmationDialog(context, controller),
                      icon: const Icon(Icons.delete),
                      color: Colors.redAccent,
                    )),
              )
            ])));
  }

  String _getEventDateString() {
    final formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    return formatter.format(event.recordedAt);
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, EventGroupController controller) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Do you really want to delete this?"),
                actions: [
                  TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context)),
                  TextButton(
                      child: const Text("Delete"),
                      onPressed: () {
                        Navigator.pop(context);
                        controller.deleteEvent(eventGroup.id, event.id);
                        controller.save();
                      }),
                ]));
  }
}
