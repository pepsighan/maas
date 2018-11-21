import 'package:flutter/material.dart';
import 'package:maas/converter.dart';
import 'package:maas/data/saal.dart';
import 'package:maas/day_dialog.dart';
import 'package:quiver/iterables.dart';

int initialPage() {
  final today = DateTime.now();
  final bsDate = BSDate.fromGregorian(today.year, today.month, today.day);
  return (bsDate.year - startSaal) * 12 + bsDate.month - 1;
}

BSDate bsDateFromPageIndex(int index) {
  final year = (index ~/ 12) + startSaal;
  final month = index % 12 + 1;
  return BSDate(year, month);
}

class CalendarBody extends StatelessWidget {
  final _pageController = PageController(initialPage: initialPage());

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
    final headings = weekdays.map((day) => _CalendarHeadingCell(day)).toList();

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Table(
            defaultColumnWidth: FractionColumnWidth(1 / 7),
            children: <TableRow>[TableRow(children: headings)],
          ),
        ),
        Expanded(child: _tableBody())
      ],
    );
  }

  Widget _tableBody() {
    return PageView.builder(
      controller: pageController,
      itemCount: totalSaals() * 12,
      itemBuilder: (context, index) {
        final bsDate = bsDateFromPageIndex(index);
        final daysCount = saal(bsDate.year)[bsDate.month - 1];
        var firstWeekDay = bsDate.toGregorian().weekday;
        // Make it sunday first and 0-index it.
        firstWeekDay = firstWeekDay == 7 ? 0 : firstWeekDay;
        final paddedDays = firstWeekDay + daysCount;
        final totalWeeks =
            paddedDays % 7 == 0 ? paddedDays ~/ 7 : (paddedDays ~/ 7) + 1;

        // Pad with empty cells till the first day.
        final dayCells = List.generate(
          firstWeekDay,
          (index) => _CalendarDayCell(),
        );

        dayCells.addAll(List.generate(
          daysCount,
          (index) => _CalendarDayCell(date: bsDate.apply(day: index + 1)),
        ));

        // Append the table till the last cell.
        dayCells.addAll(List.generate(
          (totalWeeks * 7) - paddedDays,
          (index) => _CalendarDayCell(),
        ));

        // Parition the cells into their individual rows.
        final paritionedCells = partition(dayCells, 7)
            .map((inner) => TableRow(children: inner.cast()))
            .toList();

        return Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Table(
            defaultColumnWidth: FractionColumnWidth(1 / 7),
            children: paritionedCells,
          ),
        );
      },
    );
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
  final BSDate date;

  const _CalendarDayCell({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isToday = date?.isToday();
    return Container(
      child: date != null
          ? FlatButton(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: isToday ? Colors.white : null,
                ),
              ),
              onPressed: () {
                showDialog(context: context, builder: (context) => DayDialog());
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              color: isToday ? Colors.blue : null,
            )
          : null,
      height: 50,
    );
  }
}
