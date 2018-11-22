import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maas/converter.dart';
import 'package:maas/data/translations.dart';

const borderRadius = 15.0;

class DayDialog extends StatelessWidget {
  final BSDate date;

  const DayDialog({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: <Widget>[
          _DayBadge(date: date),
          Flexible(child: _Events()),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final BSDate date;

  const _DayBadge({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final largeText = textTheme.display4.apply(color: Colors.grey[800]);
    final mediumText = textTheme.display1.apply(fontWeightDelta: -1);
    final smallText = textTheme.title.apply(
      fontWeightDelta: -2,
      color: Colors.grey[400],
    );

    final greg = date.toGregorian();

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Text(
            '${date.day}',
            style: largeText,
          ),
          Text(date.monthText(), style: mediumText),
          Text(
            '${greg.day} ${gregorianMonths(greg.month)} ${greg.year}',
            style: smallText,
          ),
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
