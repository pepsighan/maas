import 'package:flutter/material.dart';

class CalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_CalendarControls()],
    );
  }
}

class _CalendarControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headline;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.chevron_left),
            iconSize: headline.fontSize,
            onPressed: () {},
          ),
          Text(
            'Month - Year',
            style: headline,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: headline.fontSize,
            onPressed: () {},
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
