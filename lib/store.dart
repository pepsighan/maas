import 'package:maas/calendar_body.dart';

class GlobalState {
  final int calendarPageIndex;

  GlobalState({this.calendarPageIndex});
}

GlobalState mainReducer(GlobalState state, dynamic action) {
  if (action is SetCalendarPageIndex) {
    return GlobalState(calendarPageIndex: action.pageIndex);
  } else if (action is SetCalendarPageIndexDelta) {
    var page = state.calendarPageIndex + action.pageIndexDelta;
    page = page < 0 ? 0 : page;
    page = page > maxPageIndex ? maxPageIndex : page;
    return GlobalState(
      calendarPageIndex: page,
    );
  }

  return state;
}

class SetCalendarPageIndex {
  final int pageIndex;

  SetCalendarPageIndex(this.pageIndex);
}

class SetCalendarPageIndexDelta {
  final int pageIndexDelta;

  SetCalendarPageIndexDelta(this.pageIndexDelta);
}
