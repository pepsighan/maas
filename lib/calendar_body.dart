import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maas/converter.dart';
import 'package:maas/data/events/events.dart';
import 'package:maas/data/saal.dart';
import 'package:maas/data/translations.dart';
import 'package:maas/day_dialog.dart';
import 'package:maas/store.dart';
import 'package:quiver/iterables.dart';

final maxPageIndex = totalSaals() * 12;

int initialPage() {
  final today = DateTime.now();
  final bsDate = BSDate.fromGregorian(today.year, today.month, today.day);
  return (bsDate.year - startSaal) * 12 + bsDate.month - 1;
}

BSDate _bsDateFromPageIndex(int index) {
  final year = (index ~/ 12) + startSaal;
  final month = index % 12 + 1;
  return BSDate(year, month);
}

class CalendarBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _CalendarControls(),
        Flexible(child: _CalendarTable()),
      ],
    );
  }
}

typedef void SetPageCallback(int page);

class _CalendarControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headline;
    return Container(
      child: StoreConnector<GlobalState, SetPageCallback>(
        converter: (store) {
          return (int delta) =>
              store.dispatch(SetCalendarPageIndexDelta(delta));
        },
        builder: (context, callback) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: headline.fontSize,
                onPressed: () {
                  callback(-1);
                },
              ),
              StoreConnector<GlobalState, int>(
                converter: (store) => store.state.calendarPageIndex,
                builder: (context, page) {
                  final bsDate = _bsDateFromPageIndex(page);
                  return Text(
                    '${bsDate.monthText()} - ${intoDevnagariNumeral(bsDate.year)}',
                    style: headline,
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                iconSize: headline.fontSize,
                onPressed: () {
                  callback(1);
                },
              )
            ],
          );
        },
      ),
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }
}

class _CalendarTable extends StatefulWidget {
  @override
  _CalendarTableState createState() => _CalendarTableState();
}

class _CalendarTableState extends State<_CalendarTable> {
  final PageController _pageController =
      PageController(initialPage: initialPage());

  StreamSubscription<GlobalState> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscription = StoreProvider.of<GlobalState>(context)
        .onChange
        .listen(_handlePageChange);
  }

  void _handlePageChange(GlobalState state) {
    if (state.calendarPageIndex != _pageController.page.round()) {
      _pageController.jumpToPage(state.calendarPageIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final headings = devnagariWeekDaysShort
        .asMap()
        .map((index, day) => MapEntry(
            index,
            _CalendarHeadingCell(
              day,
              isHoliday: index == 6,
            )))
        .values
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Table(
            defaultColumnWidth: FractionColumnWidth(1 / 7),
            children: <TableRow>[TableRow(children: headings)],
          ),
        ),
        Flexible(child: _tableBody()),
      ],
    );
  }

  Widget _tableBody() {
    return StoreConnector<GlobalState, SetPageCallback>(
      converter: (store) {
        return (int page) {
          store.dispatch(SetCalendarPageIndex(page));
        };
      },
      builder: (context, callback) {
        return PageView.builder(
          controller: _pageController,
          itemCount: maxPageIndex,
          itemBuilder: _tableBodyPage,
          onPageChanged: callback,
        );
      },
    );
  }

  Widget _tableBodyPage(context, index) {
    final bsDate = _bsDateFromPageIndex(index);
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
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class _CalendarHeadingCell extends StatelessWidget {
  final String day;
  final bool isHoliday;

  const _CalendarHeadingCell(this.day, {Key key, this.isHoliday})
      : assert(day != null),
        assert(isHoliday != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        this.day,
        textAlign: TextAlign.center,
        style: TextStyle(color: isHoliday ? Colors.red : Colors.grey[700]),
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  final BSDate date;

  const _CalendarDayCell({Key key, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final greg = date?.toGregorian();
    final _isToday = isToday(greg);
    final _isSaturday = isSaturday(greg);
    final _events = events(date);
    final isHoliday = _events != null ? _events['isHoliday'] == true : false;
    return Container(
      child: date != null
          ? FlatButton(
              child: Text(
                intoDevnagariNumeral(date.day),
                style: TextStyle(
                  color: _isToday
                      ? Colors.white
                      : _isSaturday || isHoliday ? Colors.red : null,
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DayDialog(date: date),
                );
              },
              shape: CircleBorder(),
              padding: EdgeInsets.all(0),
              color: _isToday
                  ? _isSaturday || isHoliday ? Colors.red : Colors.blue
                  : null,
            )
          : null,
      height: 50,
    );
  }
}
