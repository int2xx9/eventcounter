import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/event_group.dart';
import 'event_card.dart';

class CounterListViewItem extends ConsumerWidget {
  final String _id;

  const CounterListViewItem(this._id);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventGroup = ref.watch(eventGroupProvider.create(_id));
    return EventCard(eventGroup);
  }
}
