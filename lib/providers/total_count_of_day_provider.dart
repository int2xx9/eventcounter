import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import 'events.dart';

final totalCountOfDayProvider =
    Provider.autoDispose.family<int, Tuple4<String, int, int, int>>((ref, arg) {
  var count = 0;
  ref.watch(eventsProvider.create(arg.item1)).forEach((event) {
    if (event.recordedAt.year == arg.item2 &&
        event.recordedAt.month == arg.item3 &&
        event.recordedAt.day == arg.item4) {
      count++;
    }
  });
  return count;
});
