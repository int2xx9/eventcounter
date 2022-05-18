import 'package:eventcounter/widgets/summary_table_record.dart';
import 'package:flutter/material.dart';

class SummaryTable extends StatelessWidget {
  final List<SummaryTableRecord> records;

  const SummaryTable({Key? key, required this.records}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <TableRow>[];
    for (final item in records.asMap().entries) {
      children.add(_createTableRow(
          item.value.name, item.value.value, _getRowColorFromIndex(item.key)));
    }

    return Table(
      children: children,
    );
  }

  Color _getRowColorFromIndex(int index) {
    return (index + 1) % 2 == 0
        ? const Color(0xffbbbbbb)
        : const Color(0xffdddddd);
  }

  TableRow _createTableRow(String name, String value, Color backgroundColor) {
    return TableRow(
        decoration: BoxDecoration(color: backgroundColor),
        children: [
          TableCell(
              child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 8, bottom: 8),
                  child: Text(name))),
          TableCell(
              child: Container(
                  color: backgroundColor,
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 8, bottom: 8),
                  child: Text(value))),
        ]);
  }
}
