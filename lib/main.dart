import 'package:flutter/material.dart';
import 'package:maas/calendar_body.dart';
import 'package:maas/calendar_header.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              CalendarHeader(),
              CalendarBody(),
            ],
          ),
          SafeArea(child: this._appBar()),
        ],
      ),
    );
  }

  Widget _appBar() {
    final appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.language,
            color: Colors.white,
            semanticLabel: 'Language',
          ),
          tooltip: 'Language',
          itemBuilder: (context) {
            return _Language.all
                .map((lang) =>
                    PopupMenuItem(value: lang, child: Text(lang.toString())))
                .toList();
          },
        )
      ],
    );
    return Container(
      height: appBar.preferredSize.height,
      child: appBar,
    );
  }
}

/// All the languages supported within the App.
class _Language {
  final String _value;
  const _Language._internal(this._value);
  toString() => _value;

  static const Nepali = const _Language._internal('नेपाली');
  static const English = const _Language._internal('English');
  
  static const all = [_Language.Nepali, _Language.English];
}
