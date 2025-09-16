import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/models/reservation_models.dart';
import '../../../core/services/reservation_service.dart';

class PropertyCalendar extends StatefulWidget {
  final String propertyKey;
  final ReservationsProvider? reservationsProvider;

  const PropertyCalendar({
    super.key,
    required this.propertyKey,
    this.reservationsProvider,
  });

  @override
  State<PropertyCalendar> createState() => _PropertyCalendarState();
}

class _PropertyCalendarState extends State<PropertyCalendar> {
  Map<DateTime, List<Reservation>> _eventsByDay = {};

  late ReservationsProvider _provider;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _provider = widget.reservationsProvider ?? MockReservationsProvider();

    _selectedDay = _toDate(_focusedDay);

    // initial load for the current month
    _loadMonth(_focusedDay);
  }

  @override
  void didUpdateWidget(covariant PropertyCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // reload when property or provider changes
    if (oldWidget.propertyKey != widget.propertyKey ||
        oldWidget.reservationsProvider != widget.reservationsProvider) {
      _provider = widget.reservationsProvider ?? _provider;

      _focusedDay = DateTime.now();
      _selectedDay = _toDate(_focusedDay);

      setState(() => _eventsByDay = {});
      _loadMonth(_focusedDay);
    }
  }

  /// Loads reservations for the month containing [anyDayInMonth]
  Future<void> _loadMonth(DateTime anyDayInMonth) async {
    final first = DateTime(anyDayInMonth.year, anyDayInMonth.month, 1);
    final next = DateTime(anyDayInMonth.year, anyDayInMonth.month + 1, 1);

    // NOTE: if provider becomes async later, just make fetch async and await it here.
    final list = _provider.fetch(widget.propertyKey, first, next);

    setState(() {
      _eventsByDay = _groupByDay(list);
    });
  }

  /// Groups reservations by day
  Map<DateTime, List<Reservation>> _groupByDay(List<Reservation> items) {
    final map = <DateTime, List<Reservation>>{};
    for (final r in items) {
      for (
        DateTime d = _toDate(r.checkIn);
        d.isBefore(_toDate(r.checkOut));
        d = d.add(const Duration(days: 1))
      ) {
        final key = _toDate(d);
        map.putIfAbsent(key, () => []).add(r);
      }
    }
    return map;
  }

  DateTime _toDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<Reservation> _eventsLoader(DateTime day) =>
      _eventsByDay[_toDate(day)] ?? const <Reservation>[];

  bool _isCheckIn(DateTime day, Reservation r) =>
      _toDate(day) == _toDate(r.checkIn);

  bool _isCheckOut(DateTime day, Reservation r) =>
      _toDate(day) == _toDate(r.checkOut.subtract(const Duration(days: 1)));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar<Reservation>(
          key: ValueKey(widget.propertyKey),
          // force internal reset per property
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          calendarFormat: CalendarFormat.month,
          startingDayOfWeek: StartingDayOfWeek.monday,
          eventLoader: _eventsLoader,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 16,
            ),
          ),
          calendarStyle: CalendarStyle(
            // keep as fallback; real selection visuals come from builders
            todayDecoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
            markersMaxCount: 4,
            outsideTextStyle: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodySmall?.color?.withOpacity(.35),
            ),
          ),
          selectedDayPredicate: (d) => isSameDay(d, _selectedDay),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          onPageChanged: (focused) {
            _focusedDay = focused;
            _loadMonth(focused);
          },
          calendarBuilders: CalendarBuilders<Reservation>(
            // cells
            defaultBuilder: (context, day, _) =>
                _dayCell(context, day, isSelected: false, isToday: false),
            selectedBuilder: (context, day, _) =>
                _dayCell(context, day, isSelected: true, isToday: false),
            todayBuilder: (context, day, _) =>
                _dayCell(context, day, isSelected: false, isToday: true),

            // markers
            markerBuilder: (context, day, reservations) =>
                _markers(context, day, reservations),
          ),
        ),

        const SizedBox(height: 12),
        _Legend(),

        const SizedBox(height: 12),
        _DayReservationsList(
          day: _selectedDay!,
          reservations: _eventsLoader(_selectedDay!),
        ),
      ],
    );
  }

  /// Day cell: keep the reservation band + a top badge for selected/today
  Widget _dayCell(
    BuildContext ctx,
    DateTime day, {
    required bool isSelected,
    required bool isToday,
  }) {
    final rs = _eventsLoader(day);

    // pick one reservation to tint the background
    final Reservation? main = rs.isEmpty
        ? null
        : rs.firstWhere(
            (r) => r.status == ReservationStatus.confirmed,
            orElse: () => rs.first,
          );

    final isIn = main != null && _isCheckIn(day, main);
    final isOut = main != null && _isCheckOut(day, main);

    final Color? bg = switch (main?.status) {
      ReservationStatus.cancelled => main!.color.withOpacity(.08),
      ReservationStatus.confirmed => main!.color.withOpacity(.14),
      ReservationStatus.pending => main!.color.withOpacity(.14),
      null => null,
    };

    final BoxDecoration? badge = isSelected
        ? const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle)
        : isToday
        ? BoxDecoration(
            color: Colors.blueAccent.withOpacity(.15),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blueAccent.withOpacity(.35),
              width: 1,
            ),
          )
        : null;

    return Stack(
      children: [
        if (bg != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.horizontal(
                  left: isIn ? const Radius.circular(10) : Radius.zero,
                  right: isOut ? const Radius.circular(10) : Radius.zero,
                ),
              ),
            ),
          ),
        Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: badge,
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(ctx).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _markers(
    BuildContext context,
    DateTime day,
    List<Reservation> reservations,
  ) {
    if (reservations.isEmpty) return const SizedBox.shrink();

    const maxDots = 3;
    final pills = reservations.take(maxDots).map((r) {
      final isIn = _isCheckIn(day, r);
      final isOut = _isCheckOut(day, r);
      return Tooltip(
        message:
            '${r.guest} • ${_fmt(r.checkIn)} → ${_fmt(r.checkOut)} (${_statusLabel(r.status)})',
        child: Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            color: r.status == ReservationStatus.cancelled
                ? r.color.withOpacity(.25)
                : r.color,
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: (isIn || isOut)
                  ? Colors.white
                  : Colors.black.withOpacity(.08),
            ),
          ),
        ),
      );
    }).toList();

    final extra = reservations.length - maxDots;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...pills,
          if (extra > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              margin: const EdgeInsets.only(left: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(.06),
              ),
              child: Text('+$extra', style: const TextStyle(fontSize: 10)),
            ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  String _statusLabel(ReservationStatus s) {
    switch (s) {
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.pending:
        return 'Pendente';
      case ReservationStatus.cancelled:
        return 'Cancelada';
    }
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        _LegendItem(color: Color(0xFF4CAF50), label: 'Confirmada'),
        _LegendItem(color: Color(0xFF2196F3), label: 'Pendente'),
        _LegendItem(color: Color(0xFFF44336), label: 'Cancelada'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _DayReservationsList extends StatelessWidget {
  final DateTime day;
  final List<Reservation> reservations;

  const _DayReservationsList({required this.day, required this.reservations});

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Sem reservas em ${_fmt(day)}',
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
        ),
      );
    }

    return Column(
      children: reservations.map((r) {
        final isCancelled = r.status == ReservationStatus.cancelled;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCancelled
                ? r.color.withOpacity(.06)
                : r.color.withOpacity(.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCancelled
                  ? r.color.withOpacity(.25)
                  : r.color.withOpacity(.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 32,
                decoration: BoxDecoration(
                  color: isCancelled ? r.color.withOpacity(.35) : r.color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.guest,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Check-in ${_fmt(r.checkIn)}  •  Check-out ${_fmt(r.checkOut)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isCancelled
                      ? Colors.red.withOpacity(.12)
                      : r.status == ReservationStatus.pending
                      ? Colors.orange.withOpacity(.12)
                      : Colors.green.withOpacity(.12),
                ),
                child: Text(
                  _statusText(r.status),
                  style: TextStyle(
                    fontSize: 12,
                    color: isCancelled
                        ? Colors.red
                        : r.status == ReservationStatus.pending
                        ? Colors.orange[800]
                        : Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _statusText(ReservationStatus s) {
    switch (s) {
      case ReservationStatus.confirmed:
        return 'Confirmada';
      case ReservationStatus.pending:
        return 'Pendente';
      case ReservationStatus.cancelled:
        return 'Cancelada';
    }
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
}
