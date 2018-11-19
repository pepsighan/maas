import 'package:flutter/material.dart';
import 'package:maas/day_dialog.dart';

class CalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _CalendarControls(),
        Expanded(
          child: _CalendarTable(),
        )
      ],
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

const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

class _CalendarTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set the initial page to arbitrary high number, so that the PageView seems
    // infinitely large.
    final initialPage = 1073741824;

    return PageView.builder(
      controller: PageController(initialPage: initialPage),
      itemBuilder: (context, index) {
        return _table();
      },
    );
  }

  Widget _table() {
    final headings = weekdays.map((day) => _CalendarHeadingCell(day)).toList();

    return Container(
      margin: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Table(
        defaultColumnWidth: FractionColumnWidth(1 / 7),
        children: <TableRow>[
          TableRow(children: headings),
          TableRow(children: _week()),
          TableRow(children: _week()),
          TableRow(children: _week()),
          TableRow(children: _week()),
        ],
      ),
    );
  }

  List<Widget> _week() {
    return List.generate(
        7,
        (index) =>
            _CalendarDayCell(date: DateTime.now().add(Duration(days: index))));
  }
}

class _CalendarHeadingCell extends StatelessWidget {
  final String day;

  const _CalendarHeadingCell(this.day, {Key key})
      : assert(day != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        this.day,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[700]),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final DateTime date;

  const _CalendarDayCell({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text('${date.day}'),
        onPressed: () {
          showDialog(context: context, builder: (context) => DayDialog());
        },
        shape: CircleBorder(),
        padding: EdgeInsets.all(0),
      ),
      height: 50,
    );
  }
}
