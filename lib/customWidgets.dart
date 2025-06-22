import 'package:flutter/material.dart';
import 'package:medico/models/user.dart';
import 'package:medico/rdvScreen.dart';

// Particular functions
Color? getColor(Color? backgroundColor) {
  return backgroundColor == Colors.white ? Colors.black : Colors.white;
}

Color? getSubtitlesColor(Color? backgroundColor) {
  return backgroundColor == Colors.white ? Colors.grey[900] : Colors.grey[400];
}

DateTime? dateSelected;

// Custom DatePicker widget
class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime? _date;
  Future _selectDate(BuildContext context) async => showDatePicker(context: context,
      firstDate: DateTime(DateTime.now().year), lastDate: DateTime(DateTime.now().year+1), initialDate: DateTime.now()
  ).then((DateTime? selected) {
    if (selected != null && selected != _date) {
      setState(() {
        _date = selected;
        dateSelected = _date;
      });
    }
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(backgroundColor: background),
              child: Text(_date == null ? "..." : "${_date?.day}-${_date?.month}-${_date?.year}",
                style: TextStyle(color: background == Colors.white ? Colors.black : Colors.white),
              )),
        ],
      ),
    );
  }
}
