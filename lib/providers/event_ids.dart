import 'package:flutter_riverpod/flutter_riverpod.dart';

final eventIdsProvider =
    StateNotifierProvider.family<EventIdsNotifier, List<String>, String>(
        (ref, arg) => EventIdsNotifier([]));

class EventIdsNotifier extends StateNotifier<List<String>> {
  EventIdsNotifier(List<String> state) : super(state);

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
