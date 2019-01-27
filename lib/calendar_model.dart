import 'package:maas/date_utils.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model which controls the calendar state.
class CalendarModel extends Model {
  /// The current date of the calendar without the day component normalized at
  /// day 1.
  DateTime _calendarMonth = DateUtils.convertToCalendarMonth(DateTime.now());

  DateTime get calendarMonth => _calendarMonth;

  /// Set the calendar page.
  void setCalendarMonth(DateTime date) {
    final _date = DateUtils.convertToCalendarMonth(date);

    if (_calendarMonth != _date) {
      _calendarMonth = _date;
      notifyListeners();
    }
  }

  /// Increment the calendar month by 1.
  void incrementCalendarMonth() {
    _setDateIfInRange(DateUtils.incrementCalendarMonth(_calendarMonth));
  }

  /// Decrement the calendar page by 1.
  void decrementCalendarMonth() {
    _setDateIfInRange(DateUtils.decrementCalendarMonth(_calendarMonth));
  }

  /// Checks the date if it is in the gregorian range.
  void _setDateIfInRange(DateTime date) {
    if (DateUtils.gregorianInRange(date)) {
      _calendarMonth = date;
      notifyListeners();
    }
  }
}
