import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventGroupIdsProvider =
    StateNotifierProvider<EventGroupIdsNotifier, List<String>>(
        (ref) => EventGroupIdsNotifier([]));

class EventGroupIdsNotifier extends StateNotifier<List<String>> {
  EventGroupIdsNotifier(List<String> state) : super(state);

  void add(String id) {
    if (state.contains(id)) {
      throw StateError("id exists");
    }
    state = [...state, id];
  }

  void remove(String id) {
    state = state.where((element) => element != id).toList();
  }
}
