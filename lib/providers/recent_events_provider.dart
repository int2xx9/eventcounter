import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../models/event.dart';
import 'events.dart';

final recentEventsProvider =
    Provider.autoDispose.family<List<Event>, Tuple2<String, int>>((ref, arg) {
  final sortedEvents = ref.watch(eventsProvider.create(arg.item1));
  sortedEvents.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  return sortedEvents.take(arg.item2).toList();
});
