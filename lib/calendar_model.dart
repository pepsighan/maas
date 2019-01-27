import 'package:maas/calendar_body.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model which controls the calendar state.
class CalendarModel extends Model {
  /// The current page of the calendar.
  int _calendarPage = initialPage;

  int get calendarPage => _calendarPage;

  /// Set the calendar page.
  void setCalendarPage(int index) {
    _calendarPage = index;

    notifyListeners();
  }

  /// Increment the calendar page by 1.
  void incrementCalendarPage() {
    if (_calendarPage < maxPageIndex) {
      _calendarPage += 1;
      notifyListeners();
    }
  }

  /// Decrement the calendar page by 1.
  void decrementCalendarPage() {
    if (_calendarPage > 0) {
      _calendarPage -= 1;
      notifyListeners();
    }
  }
}
