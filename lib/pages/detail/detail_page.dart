import 'package:eventcounter/pages/home/event_card_summary.dart';
import 'package:eventcounter/providers/event_group.dart';
import 'package:eventcounter/providers/events.dart';
import 'package:eventcounter/controllers/event_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/event.dart';
import '../../models/eventgroup.dart';

class DetailPage extends ConsumerWidget {
  final String groupId;

  const DetailPage({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(eventGroupControllerProvider);
    final detail = ref.watch(eventGroupProvider.create(groupId));
    final events = ref.watch(eventsProvider.create(groupId));
    events.sort(((a, b) => b.recordedAt.compareTo(a.recordedAt)));
    return Scaffold(
        appBar: AppBar(
          title: Text("Detail: ${detail.name}"),
          actions: [
            PopupMenuButton(
                onSelected: (value) async {
                  switch (value) {
                    case "exportAsCsv":
                      await _exportAsCsv(context, controller, events);
                      break;
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                          value: "exportAsCsv",
                          child: const Text("Export as csv"))
                    ])
          ],
        ),
        body: Column(children: [
          Row(children: [
            Expanded(
                child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ElevatedButton(
                        onPressed: () => _showRenameEventGroupDialog(
                            context, controller, detail),
                        child: const Text("Rename")))),
            Expanded(
                child: Container(
                    margin: const EdgeInsets.all(4),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(
                            context, controller, detail),
                        child: const Text("Delete")))),
          ]),
          Expanded(
              child: ListView(
                  children: events
                      .map((e) => EventCardSummary(detail, e, canDelete: true))
                      .toList()))
        ]));
  }

  void _showRenameEventGroupDialog(BuildContext context,
      EventGroupController controller, EventGroup eventGroup) {
    final nameController = TextEditingController(text: eventGroup.name);
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: const Text("Rename a group name"),
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
                    child: const Text("Rename"),
                    onPressed: () {
                      final newEventGroup =
                          eventGroup.copyWith(name: nameController.text);
                      controller.updateEventGroup(newEventGroup);
                      controller.save();
                      Navigator.pop(context);
                    },
                  ),
                ]));
  }

  void _showDeleteConfirmationDialog(BuildContext context,
      EventGroupController controller, EventGroup eventGroup) {
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
                        Navigator.pop(context);
                        controller.deleteEventGroup(eventGroup.id);
                        controller.save();
                      }),
                ]));
  }

  Future<void> _exportAsCsv(BuildContext context,
      EventGroupController controller, List<Event> events) async {
    final now = DateTime.now();
    final formatter = DateFormat("yyyyMMdd_HHmmss");
    final nowStr = formatter.format(now);
    final name = "events.$nowStr.csv";
    final csv = await controller.getEventsAsCsv(events);
    if (csv.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            const Text("Exporting has been cancelled because of empty group"),
      ));
      return;
    }
    Share.share(csv, subject: name);
  }
}
