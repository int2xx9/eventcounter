import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'event_ids.dart';

final totalCountProvider = Provider.autoDispose.family<int, String>(
    (ref, arg) => ref.watch(eventIdsProvider.create(arg)).length);
