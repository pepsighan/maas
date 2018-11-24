import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:maas/converter.dart';
import 'package:maas/data/translations.dart';

final _radius = 15.0;
final _circularRadius = Radius.circular(_radius);

class DayDialog extends StatelessWidget {
  final BSDate date;

  const DayDialog({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(
      dialogBackgroundColor: Colors.transparent,
    );
    return Theme(
      data: theme,
      child: Dialog(
        child: Column(
          children: <Widget>[
            _DayBadge(date: date),
            Flexible(child: _Events()),
          ],
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  final BSDate date;

  const _DayBadge({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greg = date.toGregorian();
    final _isToday = isToday(greg);
    final _isSaturday = isSaturday(greg);
    final textTheme = Theme.of(context).textTheme;
    final largeText = textTheme.display4.apply(
      color: _isToday || _isSaturday ? Colors.grey[50] : Colors.grey[800],
    );
    final mediumText = textTheme.display1.apply(
      fontWeightDelta: -1,
      color: _isToday || _isSaturday ? Colors.grey[200] : Colors.grey[800],
    );
    final smallText = textTheme.title.apply(
      fontWeightDelta: -2,
      color: _isSaturday
          ? Colors.red[200]
          : _isToday ? Colors.blue[200] : Colors.grey[400],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color:
              _isSaturday ? Colors.red : _isToday ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: _circularRadius,
            topRight: _circularRadius,
          )),
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
      padding: EdgeInsets.only(bottom: _radius),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.only(
          bottomLeft: _circularRadius,
          bottomRight: _circularRadius,
        ),
      ),
      child: ListView.separated(
        itemCount: 5,
        shrinkWrap: true,
        itemBuilder: (context, index) => ListTile(title: Text('Diwali')),
        separatorBuilder: (context, index) => Divider(height: 1),
      ),
    );
  }
}
