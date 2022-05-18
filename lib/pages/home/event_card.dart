import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

import '../../models/eventgroup.dart';
import '../../providers/event.dart';
import '../../providers/recent_events_provider.dart';
import '../../providers/total_count_of_day_provider.dart';
import '../../providers/total_count_provider.dart';
import '../../widgets/expandable.dart';
import '../../widgets/summary_table.dart';
import '../../widgets/summary_table_record.dart';
import '../detail/detail_page.dart';
import 'event_card_header.dart';
import 'event_card_summary.dart';

class EventCard extends ConsumerStatefulWidget {
  final EventGroup eventGroup;

  const EventCard(this.eventGroup);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EventCardState();
}

class _EventCardState extends ConsumerState<EventCard> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final recentEvents =
        ref.watch(recentEventsProvider.create(Tuple2(widget.eventGroup.id, 3)));
    final summaries = recentEvents.map((event) {
      final eventInfo = ref.watch(eventProvider
          .create(Tuple2<String, String>(widget.eventGroup.id, event.id)));
      return EventCardSummary(widget.eventGroup, eventInfo);
    }).toList();
    return Card(
        child: Expandable(
            headerBuilder: (context, isExpanded, setExpanded) =>
                EventCardHeader(
                    eventGroup: widget.eventGroup,
                    isExpanded: isExpanded,
                    setExpand: setExpanded),
            child: Column(children: [
              Container(
                  margin: const EdgeInsets.all(20),
                  child: SummaryTable(
                    records: [
                      SummaryTableRecord(
                          "Today",
                          ref
                              .watch(totalCountOfDayProvider.create(Tuple4(
                                  widget.eventGroup.id,
                                  now.year,
                                  now.month,
                                  now.day)))
                              .toString()),
                      SummaryTableRecord(
                          "Total",
                          ref
                              .watch(totalCountProvider
                                  .create(widget.eventGroup.id))
                              .toString()),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(children: summaries)),
              TextButton(
                  child: const Text("show more"),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (context) =>
                              DetailPage(groupId: widget.eventGroup.id))))
            ])));
  }
}
