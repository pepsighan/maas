import 'dart:ui';

import 'package:flutter/material.dart';

const borderRadius = 15.0;

class DayDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[_DayBadge(), Flexible(child: _Events())],
        mainAxisSize: MainAxisSize.min,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final largeText = textTheme.display4;
    final mediumText = textTheme.display1.apply(fontWeightDelta: -1);
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              '12',
              style: mediumText,
              textAlign: TextAlign.right,
            ),
          ),
          Text(
            '30',
            style: largeText,
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Text(
              'Dashami',
              style: mediumText,
            ),
          )
        ],
      ),
    );
  }
}

class _Events extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: borderRadius),
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(title: Text('Diwali')),
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
    );
  }
}
