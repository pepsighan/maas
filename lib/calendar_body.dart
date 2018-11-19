import 'package:flutter/material.dart';
import 'package:maas/day_dialog.dart';

class CalendarBody extends StatelessWidget {
  // Set the initial page to arbitrary high number, so that the PageView seems
  // infinitely large.
  final _pageController = PageController(initialPage: 1073741824);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _CalendarControls(
          onPressedBack: () {
            _pageController.jumpToPage(_pageController.page.round() - 1);
          },
          onPressedNext: () {
            _pageController.jumpToPage(_pageController.page.round() + 1);
          },
        ),
        Expanded(
          child: _CalendarTable(pageController: _pageController),
        )
      ],
    );
  }
}

class _CalendarControls extends StatelessWidget {
  final VoidCallback onPressedBack;
  final VoidCallback onPressedNext;

  const _CalendarControls({Key key, this.onPressedBack, this.onPressedNext})
      : super(key: key);

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
            onPressed: onPressedBack,
          ),
          Text(
            'Month - Year',
            style: headline,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            iconSize: headline.fontSize,
            onPressed: onPressedNext,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

class _CalendarTable extends StatelessWidget {
  final PageController pageController;

  const _CalendarTable({Key key, this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
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
