import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/eventgroup.dart';

final eventGroupsProvider =
    StateNotifierProvider<EventGroupsNotifier, List<EventGroup>>(
        (ref) => EventGroupsNotifier([]));

class EventGroupsNotifier extends StateNotifier<List<EventGroup>> {
  EventGroupsNotifier(List<EventGroup> state) : super(state);

  void add(EventGroup eventGroup) {
    if (state.any((element) => element.id == eventGroup.id)) {
      throw StateError("id exists");
    }
    state = [...state, eventGroup];
  }

  void remove(String id) {
    state = state.where((element) => element.id != id).toList();
  }

  void update(EventGroup eventGroup) {
    final index = state.indexWhere((element) => element.id == eventGroup.id);
    state.replaceRange(index, index + 1, [eventGroup]);
    state = [...state];
  }
}
