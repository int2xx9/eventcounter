import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/event_groups.dart';
import 'counter_list_view_item.dart';

class CounterListView extends ConsumerWidget {
  const CounterListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventGroups = ref.watch(eventGroupsProvider);
    return ListView(
        children:
            eventGroups.map((group) => CounterListViewItem(group.id)).toList());
  }
}
