import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

import '../../models/event.dart';
import '../../models/eventgroup.dart';
import '../../controllers/event_group_controller.dart';
import '../../providers/total_count_of_day_provider.dart';
import '../../providers/total_count_provider.dart';

class EventCardHeader extends ConsumerWidget {
  final EventGroup eventGroup;
  final bool isExpanded;
  final void Function(bool)? setExpand;

  const EventCardHeader(
      {Key? key,
      required this.eventGroup,
      required this.isExpanded,
      this.setExpand})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(eventGroupControllerProvider);
    final now = DateTime.now();
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setExpand?.call(!isExpanded),
        child: Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  isExpanded
                      ? const Icon(Icons.expand_more)
                      : const Icon(Icons.expand_less),
                  Text(
                      "${eventGroup.name} (${ref.watch(totalCountOfDayProvider.create(Tuple4(eventGroup.id, now.year, now.month, now.day)))}/${ref.watch(totalCountProvider.create(eventGroup.id))})")
                ]),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          final event = Event(
                              id: const Uuid().v4(),
                              recordedAt: DateTime.now());
                          controller.addEvent(eventGroup.id, event);
                          controller.save();
                          _showUndoSnackBar(context, controller, event.id);
                        },
                        onLongPress: () => _showNewEventDialog(
                            context, controller, DateTime.now()),
                        child: const Icon(Icons.add)),
                  ],
                )
              ],
            )));
  }

  void _showNewEventDialog(BuildContext context,
      EventGroupController controller, DateTime recordedAt) {
    final summaryController = TextEditingController();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("Enter new event summary"),
                content: TextField(
                  controller: summaryController,
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
                      final event = Event(
                          id: const Uuid().v4(),
                          recordedAt: recordedAt,
                          summary: summaryController.text);
                      controller.addEvent(eventGroup.id, event);
                      controller.save();
                      Navigator.pop(context);
                      _showUndoSnackBar(context, controller, event.id);
                    },
                  ),
                ]));
  }

  void _showUndoSnackBar(
      BuildContext context, EventGroupController controller, String id) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("An event has been created"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            controller.deleteEvent(eventGroup.id, id);
            controller.save();
          },
        )));
  }
}
