import 'package:flutter/material.dart';

class ListScrollMoreWidget extends StatelessWidget {
  ListScrollMoreWidget({
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
    super.key,
  }) : assert(child.controller != null, '');
  final ListView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          if (canLoadMore(context)) onLoadMore(context);
        }
        return true;
      },
      child: child,
    );
  }
}

class GridScrollMoreWidget extends StatelessWidget {
  GridScrollMoreWidget({
    required this.child,
    required this.onLoadMore,
    required this.canLoadMore,
    super.key,
  }) : assert(child.controller != null, '');
  final GridView child;
  final void Function(BuildContext context) onLoadMore;
  final bool Function(BuildContext context) canLoadMore;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          if (canLoadMore(context)) onLoadMore(context);
        }
        return true;
      },
      child: child,
    );
  }
}
