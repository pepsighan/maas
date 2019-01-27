/// Provides DateUtils to do basic maas related tasks.
class DateUtils {
  static final startGregorianYear = 1943;
  static final startGregorianMonth = 4;
  static final startGregorianDay = 14;

  static final endGregorianYear = 2034;
  static final endGregorianMonth = 4;
  static final endGregorianDay = 13;

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

  /// Convert to a calendar day by stripping date information other than year,
  /// month and day.
  static DateTime convertToCalendarDay(DateTime date) {
    assert(date != null);

    final _date = date.toUtc();
    return DateTime.utc(_date.year, _date.month, _date.day);
  }

  /// Checks whether the given date is the current date (no time check).
  static bool isToday(DateTime date) {
    assert(date != null);

    return convertToCalendarDay(DateTime.now()) == convertToCalendarDay(date);
  }

  /// Whether the given date is a saturday.
  static bool isSaturday(DateTime date) {
    assert(date != null);

    return date.weekday == 6;
  }

  /// Whether the given date is in the valid Gregorian Range supported by maas.
  static bool gregorianInRange(DateTime date) {
    assert(date != null);
    final _date = date.toUtc();

    return ((_date.year == startGregorianYear &&
                _date.month == startGregorianMonth &&
                _date.day >= startGregorianDay) ||
            (_date.year == startGregorianYear &&
                _date.month > startGregorianMonth) ||
            _date.year > startGregorianYear) &&
        (_date.year < endGregorianYear ||
            (_date.year == endGregorianYear &&
                _date.month < endGregorianMonth) ||
            (_date.year == endGregorianYear &&
                _date.month == endGregorianMonth &&
                _date.day <= endGregorianDay));
  }

  /// The starting Date in the supported Gregorian Range.
  static DateTime gregorianStartDate() {
    return DateTime.utc(
      startGregorianYear,
      startGregorianMonth,
      startGregorianDay,
    );
  }

  /// The last Date in the supported Gregorian Range.
  static DateTime gregorianEndDate() {
    return DateTime.utc(
      endGregorianYear,
      endGregorianMonth,
      endGregorianDay,
    );
  }
}
