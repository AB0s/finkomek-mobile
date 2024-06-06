import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MeetingTimeSelector extends StatefulWidget {
  final List<String> availableDates;
  final List<dynamic> availableMeetings;
  final ValueChanged<String> onDateSelected;
  final ValueChanged<int> onTimeSelected;

  const MeetingTimeSelector({
    Key? key,
    required this.availableDates,
    required this.availableMeetings,
    required this.onDateSelected,
    required this.onTimeSelected,
  }) : super(key: key);

  @override
  _MeetingTimeSelectorState createState() => _MeetingTimeSelectorState();
}

class _MeetingTimeSelectorState extends State<MeetingTimeSelector> {
  String selectedDate = '';
  int selectedTimeId = -1;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ru', null);
  }

  List<dynamic> getMeetingsForSelectedDate() {
    return widget.availableMeetings
        .where((meeting) => meeting['timeStart'].substring(0, 10) == selectedDate)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('d MMMM', 'ru');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Консультация уақытын таңдаңыз',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.availableDates.map((date) {
              final formattedDate = formatter.format(DateTime.parse(date));
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(
                    formattedDate,
                  ),
                  selected: selectedDate == date,
                  onSelected: (selected) {
                    setState(() {
                      selectedDate = selected ? date : '';
                      selectedTimeId = -1; // Reset selected time
                      widget.onDateSelected(selectedDate);
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        selectedDate.isEmpty
            ? const Text('Алдымен күнді таңдаңыз')
            : getMeetingsForSelectedDate().isEmpty
            ? const Text('Әзірге кездесулер жоқ')
            : Column(
          children: getMeetingsForSelectedDate().map((meeting) {
            String timeStart = DateTime.parse(meeting['timeStart']).toLocal().toString();
            String timeEnd = DateTime.parse(meeting['timeEnd']).toLocal().toString();
            return ListTile(
              title: Text(
                '${timeStart.substring(11, 16)} - ${timeEnd.substring(11, 16)}',
              ),
              leading: Radio<int>(
                value: meeting['Id'],
                groupValue: selectedTimeId,
                onChanged: (value) {
                  setState(() {
                    selectedTimeId = value!;
                    widget.onTimeSelected(selectedTimeId);
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
