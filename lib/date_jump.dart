import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:maas/bs_date.dart';
import 'package:maas/calendar_model.dart';
import 'package:maas/data/saal.dart';
import 'package:maas/data/translations.dart';
import 'package:maas/date_utils.dart';
import 'package:scoped_model/scoped_model.dart';

class DateJumpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'कुनै अर्को मितिमा सिधै जानको लागि',
                style: Theme.of(context).textTheme.title,
              ),
            ),
            _DateForm()
          ],
        ),
      ),
    );
  }
}

class _DateForm extends StatefulWidget {
  @override
  _DateFormState createState() => _DateFormState();
}

class _DateFormState extends State<_DateForm> {
  bool _isBSDate = true;
  int _year;
  int _month;
  int _day;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(children: <Widget>[
          Switch(
            value: _isBSDate,
            onChanged: (value) {
              this.setState(() {
                _isBSDate = value;
                _year = null;
                _month = null;
                _day = null;
              });
            },
          ),
          Text(_isBSDate ? 'विक्रम सम्वत' : 'ईसाई सम्वत')
        ]),
        Flexible(
          child: _isBSDate ? _bsDatePicker() : _gregorianDatePicker(),
        ),
        Container(
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerRight,
            child: ScopedModelDescendant<CalendarModel>(
              builder: (context, child, model) {
                return RaisedButton(
                  child: Text('जाऊ'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () => _isBSDate
                      ? model.setCalendarMonth(
                          BSDate(_year, _month, _day).toGregorian())
                      : model
                          .setCalendarMonth(DateTime.utc(_year, _month, _day)),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _bsDatePicker() {
    final inputs = <Widget>[
      DropdownButton(
        value: _year,
        items: List.generate(
          endSaal - startSaal + 1,
          (index) => DropdownMenuItem(
                value: startSaal + index,
                child: Text(intoDevnagariNumeral(startSaal + index)),
              ),
        ),
        onChanged: (value) {
          this.setState(() {
            _year = value;
            if (_month != null &&
                _day != null &&
                _day > saal(value)[_month - 1]) {
              _day = saal(value)[_month - 1];
            }
          });
        },
      ),
      DropdownButton(
        value: _month,
        items: List.generate(
          12,
          (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(devnagariMonths[index]),
              ),
        ),
        onChanged: (value) {
          this.setState(() {
            _month = value;

            if (_year != null &&
                _day != null &&
                _day > saal(_year)[value - 1]) {
              _day = saal(_year)[value - 1];
            }
          });
        },
      )
    ];

    if (_year != null && _month != null) {
      inputs.add(DropdownButton(
        value: _day,
        items: List.generate(
          saal(_year)[_month - 1],
          (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(intoDevnagariNumeral(index + 1)),
              ),
        ),
        onChanged: (value) {
          this.setState(() {
            _day = value;
          });
        },
      ));
    }

    return Row(
      children: inputs
          .map((inner) => Container(
                child: inner,
                margin: EdgeInsets.only(right: 10),
              ))
          .toList(),
    );
  }

  Widget _gregorianDatePicker() {
    return DateTimePickerFormField(
      format: DateFormat('MMMM d yyyy'),
      firstDate: DateUtils.gregorianStartDate(),
      lastDate: DateUtils.gregorianEndDate(),
      dateOnly: true,
      editable: false,
      onChanged: (date) {
        this.setState(() {
          _year = date.year;
          _month = date.month;
          _day = date.day;
        });
      },
    );
  }
}
