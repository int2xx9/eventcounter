import 'package:flutter/material.dart';

class Expandable extends StatefulWidget {
  final Widget Function(BuildContext context, bool isExpanded,
      void Function(bool newIsExpanded)) headerBuilder;
  final Widget child;

  const Expandable({Key? key, required this.headerBuilder, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandableState();
}

class _ExpandableState extends State<Expandable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));
  bool _isExpanded = false;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.headerBuilder(context, _isExpanded,
          (newIsExpanded) => _updateIsExpanded(newIsExpanded)),
      SizeTransition(
          sizeFactor: _animationController
              .drive(CurveTween(curve: Curves.fastOutSlowIn))
              .drive(Tween(begin: 0, end: 1)),
          child: widget.child)
    ]);
  }

  void _updateIsExpanded(bool newIsExpanded) {
    setState(() {
      _isExpanded = newIsExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
