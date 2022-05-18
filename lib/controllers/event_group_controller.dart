import 'package:csv/csv.dart';
import 'package:eventcounter/repositories/events_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';
import '../models/eventgroup.dart';
import '../providers/event_group_ids.dart';
import '../providers/event_groups.dart';
import '../providers/event_ids.dart';
import '../providers/events.dart';

final eventGroupControllerProvider =
    Provider<EventGroupController>((ref) => EventGroupController(ref));

class EventGroupController {
  final Ref _ref;
  EventGroupController(this._ref);

  Future<void> load() async {
    final eventGroups =
        await _ref.read(eventsRepositoryProvider).getEventGroups();
    for (final eventGroup in eventGroups) {
      _ref.read(eventGroupIdsProvider.notifier).add(eventGroup.id);
      _ref.read(eventGroupsProvider.notifier).add(eventGroup);

      final events =
          await _ref.read(eventsRepositoryProvider).getEvents(eventGroup.id);
      for (final event in events) {
        _ref
            .read(eventIdsProvider.create(eventGroup.id).notifier)
            .add(event.id);
        _ref.read(eventsProvider.create(eventGroup.id).notifier).add(event);
      }
    }
  }

  Future<void> save() async {
    final eventGroups = _ref.read(eventGroupsProvider);
    await _ref.read(eventsRepositoryProvider).saveEventGroups(eventGroups);
    for (final eventGroup in eventGroups) {
      final events = _ref.read(eventsProvider.create(eventGroup.id));
      await _ref
          .read(eventsRepositoryProvider)
          .saveEvents(eventGroup.id, events);
    }
  }

  String getEventsAsCsv(List<Event> events) {
    final sortedEvents = List.of(events);
    sortedEvents.sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final csv = const ListToCsvConverter().convert(events
        .map((event) => [event.recordedAt, event.summary ?? ""])
        .toList());
    return csv;
  }

  void addEventGroup(EventGroup eventGroup) {
    _ref.read(eventGroupIdsProvider.notifier).add(eventGroup.id);
    _ref.read(eventGroupsProvider.notifier).add(eventGroup);
  }

  void deleteEventGroup(String id) {
    _ref.read(eventGroupIdsProvider.notifier).remove(id);
    _ref.read(eventGroupsProvider.notifier).remove(id);
  }

  void updateEventGroup(EventGroup eventGroup) {
    _ref.read(eventGroupsProvider.notifier).update(eventGroup);
  }

  void addEvent(String groupId, Event event) {
    _ref.read(eventIdsProvider.create(groupId).notifier).add(event.id);
    _ref.read(eventsProvider.create(groupId).notifier).add(event);
  }

  void deleteEvent(String groupId, String eventId) {
    _ref.read(eventIdsProvider.create(groupId).notifier).remove(eventId);
    _ref.read(eventsProvider.create(groupId).notifier).remove(eventId);
  }

  void updateEvent(String groupId, Event event) {
    _ref.read(eventsProvider.create(groupId).notifier).update(event);
  }
}
