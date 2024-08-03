import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/utilities/utils.dart';
import '../../../../core/constants/strings.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../core/widgets/user_scaffold.dart';
import '../../../../core/widgets/time_selectior_dropdown.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../providers/rb_collection_provider.dart';
import '../../../../features/schedule/data/models/rb_collection.dart';

class CollectionDatePage extends StatefulWidget {
  const CollectionDatePage({Key? key}) : super(key: key);

  @override
  State<CollectionDatePage> createState() => _CollectionDatePageState();
}

class _CollectionDatePageState extends State<CollectionDatePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedTime;
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RBCollectionProvider>(context, listen: false);
      if (provider.collection != null) {
        setState(() {
          _selectedDay = DateTime.tryParse(provider.collection!.date ?? '');
          _selectedTime = provider.collection!.time;
        });
      }
    });
    _events = {
      DateTime.utc(2024, 7, 15): ['Event 1'],
      DateTime.utc(2024, 7, 28): ['Event 2'],
    };
  }

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime firstDay = DateTime.now();// DateTime.now().subtract(const Duration(days: 365));
    DateTime lastDay = DateTime.now().add(const Duration(days: 365));
    final provider = Provider.of<RBCollectionProvider>(context);

    print('current selected time: ${_selectedTime}');

    return UserScaffold(
      onCalendarTodayButtonPressed: (){
        print('onCalendarTodayButtonPressed');
        setState(() {
          _focusedDay = DateTime.now();
        });
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pickup Date & Time',
            style: TextStyle(
              color: Colors.grey,
              fontSize: width * 0.04,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: height * 0.02),
          Container(
            height: height * 0.08,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.lightGreen.shade50,
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.04),
                  child: Container(
                    width: width * 0.09,
                    height: height * 0.04,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Utils.hexToColor(AppStrings.kRBPrimaryColor),
                          Utils.hexToColor(AppStrings.kRBSecondaryColor),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Icon(
                      Icons.access_time,
                      color: Colors.white,
                      size: MediaQuery.of(context).size.width * 0.06,
                    ),
                  ),
                ),
                SizedBox(width: width * 0.04),
                SizedBox(
                  width: width * 0.6,
                  child: TimeSelectorDropdown(
                    initialTime: _selectedTime,
                    onTimeSelected: (String time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: height * 0.04),
          Container(
            color: Colors.grey.shade300,
            width: double.infinity,
            height: 1,
          ),
          SizedBox(height: height * 0.03),
          TableCalendar(
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            enabledDayPredicate: (day) {
              return !day.isBefore(DateTime.now());
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Colors.green,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.green,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              weekdayStyle: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
              dowTextFormatter: (date, locale) {
                return DateFormat.E(locale).format(date).substring(0, 1);
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8ec53f), Color(0xFF099444)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              defaultTextStyle: const TextStyle(
                color: Colors.black,
              ),
              weekendTextStyle: const TextStyle(
                color: Colors.black,
              ),
              outsideTextStyle: const TextStyle(
                color: Colors.grey,
              ),
              disabledTextStyle: const TextStyle(
                color: Colors.grey,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
            ),
            eventLoader: _getEventsForDay,
          ),
          ..._getEventsForDay(_selectedDay ?? _focusedDay).map(
                (event) => ListTile(
              title: Text(event),
            ),
          ),
          SizedBox(height: height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width * 0.35,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.35,
                height: height * 0.06,
                child: CustomElevatedButton(
                  text: 'Done',
                  onPressed: () async {
                    if (_selectedDay == null) {
                      showCustomSnackbar(
                        context, 'Please select a date for collection',
                        backgroundColor: Colors.orange,
                      );
                    } else {
                      if (provider.collection != null) {
                        await provider.updateCollection(
                          date: _selectedDay?.toIso8601String(),
                          time: _selectedTime ?? '01:00AM - 05:00AM',
                        );
                        showCustomSnackbar(context, 'Collection updated', backgroundColor: Colors.green);
                      } else {
                        RBCollection collection = RBCollection(
                          date: _selectedDay?.toIso8601String(),
                          time: _selectedTime ?? '12:00AM - 01:00AM',
                        );
                        await provider.saveCollection(collection);
                        showCustomSnackbar(context, 'New collection created', backgroundColor: Colors.green);
                      }
                      Navigator.pop(context);
                    }
                  },
                  primaryButton: true,
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.05),
        ],
      ),
      isDateCollectionPage: true,
      showMenu: false,
      title: '',
    );
  }
}
