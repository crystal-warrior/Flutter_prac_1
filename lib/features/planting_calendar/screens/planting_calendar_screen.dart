import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../cubit/planting_calendar_cubit.dart';
import 'package:intl/intl.dart';

class PlantingCalendarScreen extends StatelessWidget {
  const PlantingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь посадок'),
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) => PlantingCalendarCubit(),
        child: const _CalendarBody(),
      ),
    );
  }
}

class _CalendarBody extends StatefulWidget {
  const _CalendarBody();

  @override
  State<_CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<_CalendarBody> {
  late DateTime _selectedDay;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantingCalendarCubit, PlantingCalendarState>(
      builder: (context, state) {
        final event = state.getEventForDate(_selectedDay);
        _noteController.text = event?.note ?? '';

        return Column(
          children: [
            TableCalendar(
              locale: 'ru_RU',
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _selectedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(

                selectedDecoration: BoxDecoration(
                  color: Colors.lightGreen,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.lightGreen[200],
                  shape: BoxShape.circle,
                ),
              ),

              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) {
                  final hasEvent = state.hasEventOnDate(date);
                  final isToday = isSameDay(date, DateTime.now());
                  final isSelected = isSameDay(date, _selectedDay);

                  Color? bgColor;
                  if (isSelected) {
                    bgColor = Colors.lightGreen;
                  } else if (isToday) {
                    bgColor = Colors.lightGreen[200];
                  }

                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${date.day}', style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                          if (hasEvent)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'В этот день ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year} я...',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.lightGreen),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save, color: Colors.lightGreen),
                    onPressed: () {
                      final note = _noteController.text;
                      if (note.trim().isNotEmpty) {
                        context.read<PlantingCalendarCubit>().addEvent(_selectedDay, note);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Событие сохранено')),
                        );
                      }
                    },
                  ),
                  if (event != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<PlantingCalendarCubit>().removeEvent(_selectedDay);
                        _noteController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Событие удалено')),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}