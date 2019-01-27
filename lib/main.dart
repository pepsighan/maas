import 'package:flutter/material.dart';
import 'package:maas/calendar_body.dart';
import 'package:maas/calendar_model.dart';
import 'package:maas/date_jump.dart';
import 'package:maas/debug.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  // Read debug status.
  setupDebugStatus();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CalendarModel>(
      model: CalendarModel(),
      child: MaterialApp(
        title: 'Maas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'LohitNepali',
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this._appBar(),
      body: CalendarBody(),
    );
  }

  Widget _appBar() {
    final iconTheme = IconThemeData(color: Colors.grey[700]);

    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: iconTheme,
      elevation: 0,
      actions: <Widget>[
        ScopedModelDescendant<CalendarModel>(
          builder: (context, child, model) {
            return IconButton(
              icon: Icon(Icons.today),
              onPressed: () => model.setCalendarPage(initialPage),
              tooltip: 'आज',
            );
          },
        ),
        IconButton(
          icon: Icon(Icons.directions_run),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DateJumpDialog(),
            );
          },
          tooltip: 'अर्को मितिमा जाने',
        )
      ],
    );
  }
}
