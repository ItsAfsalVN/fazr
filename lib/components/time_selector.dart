import 'package:flutter/material.dart';

class TimeSelector extends StatefulWidget {
  final Function(TimeOfDay)? onStartTimeSelected;
  final Function(TimeOfDay)? onEndTimeSelected;
  const TimeSelector({
    super.key,
    this.onStartTimeSelected,
    this.onEndTimeSelected,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);

  int get12HourFormat(int hour) {
    if (hour == 0) return 12;
    if (hour > 12) return hour - 12;
    return hour;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            final TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: _startTime,
            );
            if (selectedTime != null) {
              setState(() {
                _startTime = selectedTime;
              });
              if (widget.onStartTimeSelected != null) {
                widget.onEndTimeSelected!(selectedTime);
              }
            }
          },
          child: Row(
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      get12HourFormat(
                        _startTime.hour,
                      ).toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      _startTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _startTime.format(context).split(' ').last,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Center(
          child: Container(
            height: 4,
            width: 10,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),

        InkWell(
          onTap: () async {
            final TimeOfDay? selectedTime = await showTimePicker(
              context: context,
              initialTime: _endTime,
            );
            if (selectedTime != null) {
              setState(() {
                _endTime = selectedTime;
              });
              if (widget.onEndTimeSelected != null) {
                widget.onEndTimeSelected!(selectedTime);
              }
            }
          },
          child: Row(
            children: [
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      get12HourFormat(_endTime.hour).toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text(
                      _endTime.minute.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary,
                  border: Border.all(color: colors.primary),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    _endTime.format(context).split(' ').last,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
