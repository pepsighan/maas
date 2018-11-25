import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:maas/calendar_body.dart';
import 'package:maas/debug.dart';
import 'package:maas/store.dart';
import 'package:redux/redux.dart';

void main() {
  // Read debug status.
  setupDebugStatus();

  final store = Store<GlobalState>(
    mainReducer,
    initialState: GlobalState(
      calendarPageIndex: initialPage(),
    ),
  );

  runApp(MyApp(
    store: store,
  ));
}

class MyApp extends StatelessWidget {
  final Store<GlobalState> store;

  const MyApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<GlobalState>(
      store: store,
      child: MaterialApp(
        title: 'Maas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
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
        StoreConnector<GlobalState, VoidCallback>(
          converter: (store) {
            return () => store.dispatch(SetCalendarPageIndex(initialPage()));
          },
          builder: (context, callback) {
            return IconButton(
              icon: Icon(Icons.today),
              onPressed: callback,
              tooltip: 'आज',
            );
          },
        )
      ],
    );
  }
}
