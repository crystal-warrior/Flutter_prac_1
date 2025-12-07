import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import '../cubit/planting_calendar_cubit.dart';

class PlantingCalendarScreen extends StatelessWidget {
  const PlantingCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Календарь посадок'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
  DateTime? _lastSelectedDay;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _lastSelectedDay = _selectedDay;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlantingCalendarCubit, PlantingCalendarState>(
      builder: (context, state) {
        final events = state.getEventsForDate(_selectedDay);
        final firstEvent = events?.isNotEmpty == true ? events!.first : null;
        
        // Обновляем текст контроллера только если:
        // 1. Выбрана другая дата
        // 2. Или событие изменилось (новое событие загружено)
        if (_lastSelectedDay != _selectedDay || (!_isEditing && firstEvent?.note != _noteController.text)) {
          _noteController.text = firstEvent?.note ?? '';
          _lastSelectedDay = _selectedDay;
          _isEditing = false;
        }

        return SafeArea(
          child: Column(
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
                  _isEditing = false;
                });
              },
              calendarStyle: CalendarStyle(

                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
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
                    bgColor = Theme.of(context).colorScheme.primary;
                  } else if (isToday) {
                    bgColor = Theme.of(context).colorScheme.primary.withOpacity(0.5);
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
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
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
                      onChanged: (_) {
                        _isEditing = true;
                      },
                      decoration: InputDecoration(
                        hintText: 'В этот день ${_selectedDay.day}.${_selectedDay.month}.${_selectedDay.year} я...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.save, color: Theme.of(context).colorScheme.primary),
                    onPressed: () async {
                      final note = _noteController.text;
                      if (note.trim().isNotEmpty) {
                        await context.read<PlantingCalendarCubit>().addEvent(_selectedDay, note);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Событие сохранено')),
                        );
                      }
                    },
                  ),
                  if (firstEvent != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        final eventsForDate = state.getEventsForDate(_selectedDay);
                        if (eventsForDate != null && eventsForDate.isNotEmpty) {
                          context.read<PlantingCalendarCubit>().removeEvent(_selectedDay, 0);
                          _noteController.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Событие удалено')),
                          );
                        }
                      },
                    ),
                ],
              ),
            ),
          ],
          ),
        );
      },
    );
  }
}