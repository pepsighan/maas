/// Provides DateUtils to do basic maas related tasks.
class DateUtils {
  /// Convert to a calendar month by stripping date information other than year
  /// and month.
  static DateTime convertToCalendarMonth(DateTime date) {
    assert(date != null);

    final _date = date.toUtc();
    return DateTime.utc(_date.year, _date.month);
  }

  /// Increment the calendar month by 1.
  static DateTime incrementCalendarMonth(DateTime date) {
    assert(date != null);

    final _date = date.toUtc();
    return DateTime.utc(
      _date.month == 12 ? _date.year + 1 : _date.year,
      _date.month == 12 ? 1 : _date.month + 1,
    );
  }

  /// Decrement the calendar month by 1.
  static DateTime decrementCalendarMonth(DateTime date) {
    assert(date != null);

    final _date = date.toUtc();
    return DateTime.utc(
      _date.month == 1 ? _date.year - 1 : _date.year,
      _date.month == 1 ? 12 : _date.month - 1,
    );
  }
}
