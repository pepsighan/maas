import 'package:maas/data/saal.dart';
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

  int get hashCode => hash3(year, month, day);

  String toString() => 'BSDate { year: $year, month: $month, day: $day }';

  // Starts from 1943-April-14
  // Ends on ....
  static BSDate fromGregorian(DateTime date) {
    if (!_gregorianInRange(date)) {
      throw DateNotInValidRange();
    }
    final startGregorianDate =
        DateTime(startGregorianYear, startGregorianMonth, startGregorianDay);
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
