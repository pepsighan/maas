import 'package:flutter/material.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(
              Icons.language,
              color: Colors.grey,
            ),
            itemBuilder: (context) {
              return _allLanguages
                  .map((lang) =>
                      PopupMenuItem(value: lang, child: Text(lang.toString())))
                  .toList();
            },
          )
        ],
      ),
      body: CalendarHeader(),
    );
  }
}

/// All the languages supported within the App.
class _Language {
  final String _value;
  const _Language._internal(this._value);
  toString() => _value;

  static const Nepali = const _Language._internal('Nepali');
  static const English = const _Language._internal('English');
}

const _allLanguages = [_Language.Nepali, _Language.English];
