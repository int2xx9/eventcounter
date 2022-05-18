import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/event.dart';

final eventsProvider =
    StateNotifierProvider.family<EventsNotifier, List<Event>, String>(
        (ref, arg) => EventsNotifier([]));

class EventsNotifier extends StateNotifier<List<Event>> {
  EventsNotifier(List<Event> state) : super(state);

  void add(Event event) {
    if (state.any((element) => element.id == event.id)) {
      throw StateError("id exists");
    }
    state = [...state, event];
  }

  void remove(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void update(Event event) {
    final index = state.indexWhere((element) => element.id == event.id);
    state.replaceRange(index, index + 1, [event]);
    state = [...state];
  }
}
