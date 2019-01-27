import 'package:maas/converter.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model which controls the calendar state.
class CalendarModel extends Model {
  /// The current date of the calendar without the day component normalized at
  /// day 1.
  DateTime _calendarMonth = _convertToCalendarMonth(DateTime.now());

  DateTime get calendarMonth => _calendarMonth;

  /// Set the calendar page.
  void setCalendarMonth(DateTime date) {
    final _date = _convertToCalendarMonth(date);

    if (_calendarMonth != _date) {
      _calendarMonth = _date;
      notifyListeners();
    }
  }

  /// Increment the calendar month by 1.
  void incrementCalendarMonth() {
    final newCalendarMonth = DateTime.utc(
      _calendarMonth.month == 12
          ? _calendarMonth.year + 1
          : _calendarMonth.year,
      _calendarMonth.month == 12 ? 1 : _calendarMonth.month + 1,
    );

    if (gregorianInRange(newCalendarMonth)) {
      _calendarMonth = newCalendarMonth;
      notifyListeners();
    }
  }

  /// Decrement the calendar page by 1.
  void decrementCalendarMonth() {
    final newCalendarMonth = DateTime.utc(
      _calendarMonth.month == 1 ? _calendarMonth.year - 1 : _calendarMonth.year,
      _calendarMonth.month == 1 ? 12 : _calendarMonth.month - 1,
    );

    if (gregorianInRange(newCalendarMonth)) {
      _calendarMonth = newCalendarMonth;
      notifyListeners();
    }
  }
}

/// Convert to a calendar month by stripping date information other than year
/// and month.
DateTime _convertToCalendarMonth(DateTime date) {
  assert(date != null);

  final _date = date.toUtc();
  return DateTime.utc(_date.year, _date.month);
}
