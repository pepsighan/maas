import 'package:maas/converter.dart';
import 'package:maas/data/events/2074.dart';
import 'package:maas/data/events/2075.dart';

Map<String, Object> events(BSDate date) {
  var saal;
  switch (date.year) {
    case 2074:
      saal = saal2074;
      break;
    case 2075:
      saal = saal2075;
      break;
  }
  if (saal != null) {
    return saal[date.month - 1][date.day];
  }
  return null;
}
