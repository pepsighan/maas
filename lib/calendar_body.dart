import 'package:flutter/material.dart';
import 'package:maas/calendar_model.dart';
import 'package:maas/bs_date.dart';
import 'package:maas/data/events/events.dart';
import 'package:maas/data/saal.dart';
import 'package:maas/data/translations.dart';
import 'package:maas/date_utils.dart';
import 'package:maas/day_dialog.dart';
import 'package:quiver/iterables.dart';
import 'package:scoped_model/scoped_model.dart';

/// The max pages allowed in the month-wise page view.
final _maxPageIndex = totalSaals() * 12;

/// Convert the page view index to BSDate.
BSDate _bsDateFromPageIndex(int index) {
  final year = (index ~/ 12) + startSaal;
  final month = index % 12 + 1;
  return BSDate(year, month);
}

/// Convert BSDate to page view index.
int _bsDateToPageIndex(BSDate date) {
  return ((date.year - startSaal) * 12) + date.month;
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

class _CalendarControls extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final headline = Theme.of(context).textTheme.headline;
    return Container(
      child: ScopedModelDescendant<CalendarModel>(
        builder: (context, child, model) {
          final bsDate = BSDate.fromGregorian(model.calendarMonth);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.chevron_left),
                iconSize: headline.fontSize,
                onPressed: model.decrementCalendarMonth,
              ),
              Text(
                '${bsDate.monthText()} - ${intoDevnagariNumeral(bsDate.year)}',
                style: headline,
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                iconSize: headline.fontSize,
                onPressed: model.incrementCalendarMonth,
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
  final PageController _pageController = PageController(
    initialPage: _bsDateToPageIndex(BSDate.fromGregorian(DateTime.now())),
  );

  CalendarModel _calendarModel;

  @override
  void initState() {
    super.initState();

    _calendarModel = ScopedModel.of<CalendarModel>(context);
    _calendarModel.addListener(_handlePageChange);
  }

  /// If there has been a page change in the state, then update the UI to show
  /// the new month.
  void _handlePageChange() {
    final controllerDate =
        _bsDateFromPageIndex(_pageController.page.round()).toGregorian();

    if (_calendarModel.calendarMonth != controllerDate) {
      final newPageIndex = _bsDateToPageIndex(
        BSDate.fromGregorian(_calendarModel.calendarMonth),
      );

      _pageController.jumpToPage(newPageIndex);
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
    return ScopedModelDescendant<CalendarModel>(
      builder: (context, child, model) {
        return PageView.builder(
          controller: _pageController,
          itemCount: _maxPageIndex,
          itemBuilder: _tableBodyPage,
          onPageChanged: (page) =>
              model.setCalendarMonth(_bsDateFromPageIndex(page).toGregorian()),
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
    _calendarModel.removeListener(_handlePageChange);
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
    final _isToday = greg != null ? DateUtils.isToday(greg) : false;
    final _isSaturday = greg != null ? DateUtils.isSaturday(greg) : false;
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
