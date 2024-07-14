import 'package:flutter/material.dart';

class TimeSelectorDropdown extends StatefulWidget {
  const TimeSelectorDropdown({super.key});

  @override
  _TimeSelectorDropdownState createState() => _TimeSelectorDropdownState();
}

class _TimeSelectorDropdownState extends State<TimeSelectorDropdown> {
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = timeIntervals.first;
  }

  List<String> get timeIntervals {
    List<String> intervals = [];
    for (int i = 0; i < 24; i++) {
      String startTime = _formatTime(i);
      String endTime = _formatTime(i + 1);
      intervals.add('$startTime - $endTime');
    }
    return intervals;
  }

  String _formatTime(int hour) {
    int formattedHour = hour % 12 == 0 ? 12 : hour % 12;
    String period = hour < 12 ? 'AM' : 'PM';
    return '${formattedHour.toString().padLeft(2, '0')}:00 $period';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedTime,
      onChanged: (String? newValue) {
        setState(() {
          selectedTime = newValue;
        });
      },
      items: timeIntervals.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.grey.shade400,
        size: MediaQuery.of(context).size.width*0.08,
      ), // Arrow icon on the right
      isExpanded: true, // Make the dropdown take full width
      underline: Container(), // Remove the underline
      style: TextStyle(
        fontSize: MediaQuery.of(context).size.width*0.041,
        color: Colors.grey,
      ),
      dropdownColor: Colors.white,
    );
  }
}