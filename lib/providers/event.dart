import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../models/event.dart';
import 'events.dart';

final eventProvider = Provider.autoDispose
    .family<Event, Tuple2<String, String>>((ref, arg) => ref.watch(
        eventsProvider.create(arg.item1).select((value) => value.singleWhere(
            (element) => element.id == arg.item2,
            orElse: () => InvalidEvent))));
