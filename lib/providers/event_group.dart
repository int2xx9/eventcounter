import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/eventgroup.dart';
import 'event_groups.dart';

final eventGroupProvider = Provider.autoDispose.family<EventGroup, String>(
    (ref, arg) => ref.watch(eventGroupsProvider.select((value) =>
        value.singleWhere((element) => element.id == arg,
            orElse: () => InvalidEventGroup))));
