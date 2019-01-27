import 'package:maas/bs_date.dart';
import 'package:test/test.dart';

void main() {
  group('Should convert valid gregorian dates to Bikram Samvat', () {
    void matchDates(int year, int month, int day, BSDate bsDate) {
      test('$year-$month-$day', () {
        expect(BSDate.fromGregorian(DateTime.utc(year, month, day)), bsDate);
      });
    }

    matchDates(1943, 4, 14, BSDate(2000, 1, 1));
    matchDates(1943, 4, 15, BSDate(2000, 1, 2));
    matchDates(1943, 5, 1, BSDate(2000, 1, 18));
    matchDates(1944, 1, 1, BSDate(2000, 9, 17));
    matchDates(1994, 3, 4, BSDate(2050, 11, 20));
    matchDates(2033, 1, 1, BSDate(2089, 9, 17));
    matchDates(2034, 3, 1, BSDate(2090, 11, 17));
    matchDates(2034, 4, 12, BSDate(2090, 12, 29));
    matchDates(2034, 4, 13, BSDate(2090, 12, 30));
  });

  group('Should fail converting out of range dates', () {
    final outOfRange = throwsA(TypeMatcher<DateNotInValidRange>());

    void outOfRangeTests(year, month, day) {
      test('$year-$month-$day AD', () {
        expect(
          () => BSDate.fromGregorian(DateTime.utc(year, month, day)),
          outOfRange,
        );
      });
    }

    outOfRangeTests(1943, 4, 13);
    outOfRangeTests(1943, 3, 14);
    outOfRangeTests(1942, 4, 14);
    outOfRangeTests(2034, 4, 14);
    outOfRangeTests(2034, 5, 13);
    outOfRangeTests(2035, 4, 13);
  });

  group('Should convert valid Bikram Samvat dates to Gregorian', () {
    void matchDates(BSDate bsDate, DateTime gregDate) {
      test('${bsDate.year}-${bsDate.month}-${bsDate.day}', () {
        expect(bsDate.toGregorian(), gregDate);
      });
    }

    matchDates(BSDate(2000, 1, 1), DateTime.utc(1943, 4, 14));
    matchDates(BSDate(2000, 1, 2), DateTime.utc(1943, 4, 15));
    matchDates(BSDate(2000, 1, 18), DateTime.utc(1943, 5, 1));
    matchDates(BSDate(2000, 9, 17), DateTime.utc(1944, 1, 1));
    matchDates(BSDate(2050, 11, 20), DateTime.utc(1994, 3, 4));
    matchDates(BSDate(2089, 9, 17), DateTime.utc(2033, 1, 1));
    matchDates(BSDate(2090, 11, 17), DateTime.utc(2034, 3, 1));
    matchDates(BSDate(2090, 12, 29), DateTime.utc(2034, 4, 12));
    matchDates(BSDate(2090, 12, 30), DateTime.utc(2034, 4, 13));
  });
}
