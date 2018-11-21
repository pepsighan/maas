import 'package:maas/data/saal.dart';
import 'package:maas/data/translations.dart';
import 'package:quiver/core.dart';

class BSDate {
  int year;
  int month;
  int day;

  BSDate([this.year = startSaal, this.month = 1, this.day = 1])
      : assert(year >= startSaal && year <= endSaal),
        assert(month >= 1 && month <= 12),
        assert(day >= 1 && day <= saal(year)[month - 1]);

  bool operator ==(other) =>
      other is BSDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  bool operator <(BSDate other) =>
      year < other.year ||
      (year == other.year && month < other.month) ||
      (year == other.year && month == other.month && day < other.day);

  Duration operator -(BSDate other) {
    if (this < other) {
      return -(_difference(other, this));
    } else {
      return _difference(this, other);
    }
  }

  static Duration _difference(BSDate lhs, BSDate rhs) {
    var marker = rhs.apply();
    int days = 0;
    while (true) {
      final daysInCurrentMonth = saal(marker.year)[marker.month - 1];

      if (lhs.year == rhs.year && lhs.month == rhs.month) {
        // If both the start and end dates are in the same month of the year.
        days = lhs.day - rhs.day;
        break;
      } else if (marker.year == rhs.year && marker.month == rhs.month) {
        // Add the remaining days of the first month.
        days = daysInCurrentMonth - marker.day;
      } else if (marker.year == lhs.year && marker.month == lhs.month) {
        // Add the remaining days of the last month.
        days += lhs.day;
        break;
      } else {
        // Add all the days of the inner months.
        days += daysInCurrentMonth;
      }

      if (marker.month == 12) {
        marker.month = 1;
        marker.year += 1;
      } else {
        marker.month += 1;
      }
    }
    return Duration(days: days);
  }

  int get hashCode => hash3(year, month, day);

  String toString() => 'BSDate { year: $year, month: $month, day: $day }';

  // Starts from 1943-April-14 AD
  // Ends on 2034-04-13 AD
  static BSDate fromGregorian(int year, int month, int day) {
    final date = DateTime.utc(year, month, day);
    if (!_gregorianInRange(date)) {
      throw DateNotInValidRange();
    }
    final startGregorianDate = DateTime.utc(
      startGregorianYear,
      startGregorianMonth,
      startGregorianDay,
    );
    var daysInBetween = date.difference(startGregorianDate).inDays;
    var bsYear = startSaal;
    var bsMonth = 1;
    var bsDay = 1;
    while (daysInBetween != 0) {
      final daysInCurrentMonth = saal(bsYear)[bsMonth - 1];
      if (daysInCurrentMonth <= daysInBetween) {
        if (bsMonth == 12) {
          bsYear += 1;
          bsMonth = 1;
        } else {
          bsMonth += 1;
        }
        daysInBetween -= daysInCurrentMonth;
      } else {
        bsDay += daysInBetween;
        daysInBetween = 0;
      }
    }
    return BSDate(bsYear, bsMonth, bsDay);
  }

  DateTime toGregorian() {
    return DateTime.utc(
      startGregorianYear,
      startGregorianMonth,
      startGregorianDay,
    ).add(this - BSDate());
  }

  String monthText() {
    return bsMonths[month - 1];
  }

  BSDate apply({int year, int month, int day}) {
    return BSDate(year ?? this.year, month ?? this.month, day ?? this.day);
  }
}

class DateNotInValidRange extends Error {}

const startGregorianYear = 1943;
const startGregorianMonth = 4;
const startGregorianDay = 14;

const endGregorianYear = 2034;
const endGregorianMonth = 4;
const endGregorianDay = 13;

bool _gregorianInRange(DateTime date) {
  return ((date.year == startGregorianYear &&
              date.month == startGregorianMonth &&
              date.day >= startGregorianDay) ||
          (date.year == startGregorianYear &&
              date.month > startGregorianMonth) ||
          date.year > startGregorianYear) &&
      (date.year < endGregorianYear ||
          (date.year == endGregorianYear && date.month < endGregorianMonth) ||
          (date.year == endGregorianYear &&
              date.month == endGregorianMonth &&
              date.day <= endGregorianDay));
}
