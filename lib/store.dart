class GlobalState {
  final int calendarPageIndex;

  GlobalState({this.calendarPageIndex});
}

GlobalState mainReducer(GlobalState state, dynamic action) {
  if (action is SetCalendarPageIndex) {
    return GlobalState(calendarPageIndex: action.pageIndex);
  }

  return state;
}

class SetCalendarPageIndex {
  final int pageIndex;

  SetCalendarPageIndex(this.pageIndex);
}
