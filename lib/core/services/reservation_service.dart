import 'package:flutter/material.dart';

import '../models/profits_model.dart';
import '../models/property_model.dart';
import '../models/reservation_models.dart';

/// THIS IS JUST A MOCK CLASS, TO BE DELETED
abstract class ReservationsProvider {
  List<Reservation> fetch(String propertyKey, DateTime start, DateTime end);
}

abstract class ProfitsProvider {
  List<ProfitPoint> fetchSeries(String propertyKey);
}

abstract class PropertiesProvider {
  List<PropertyModel> fetchList();
}

/// ----------  MOCK  ----------
class MockReservationsProvider implements ReservationsProvider {
  final Map<String, List<Reservation>> _seed;

  MockReservationsProvider({Map<String, List<Reservation>>? seed})
    : _seed = seed ?? _defaultSeed();

  @override
  List<Reservation> fetch(String propertyKey, DateTime start, DateTime end) {
    final all = _seed[propertyKey] ?? const <Reservation>[];
    return all.where((r) {
      final startsBeforeEnd = !r.checkIn.isAfter(end);
      final endsAfterStart = r.checkOut.isAfter(start);
      return startsBeforeEnd && endsAfterStart;
    }).toList();
  }

  static Map<String, List<Reservation>> _defaultSeed() {
    final now = DateTime.now();
    DateTime d(int addDays) =>
        DateTime(now.year, now.month, now.day).add(Duration(days: addDays));

    List<Reservation> apts() => [
      Reservation(
        id: 'A-1001',
        guest: 'Maria Silva',
        checkIn: d(-2),
        checkOut: d(3),
        status: ReservationStatus.confirmed,
        color: const Color(0xFF4CAF50),
      ),
      Reservation(
        id: 'A-1002',
        guest: 'João Costa',
        checkIn: d(5),
        checkOut: d(8),
        status: ReservationStatus.pending,
        color: const Color(0xFF2196F3),
      ),
      Reservation(
        id: 'A-1003',
        guest: 'Ana Ramos',
        checkIn: d(7),
        checkOut: d(12),
        status: ReservationStatus.confirmed,
        color: const Color(0xFFFF9800),
      ),
    ];

    List<Reservation> villas() => [
      Reservation(
        id: 'V-2001',
        guest: 'Família Neves',
        checkIn: d(1),
        checkOut: d(6),
        status: ReservationStatus.confirmed,
        color: const Color(0xFF7CB342),
      ),
      Reservation(
        id: 'V-2002',
        guest: 'Ricardo P.',
        checkIn: d(10),
        checkOut: d(11),
        status: ReservationStatus.cancelled,
        color: const Color(0xFFF44336),
      ),
      Reservation(
        id: 'V-2003',
        guest: 'Sofia & Tiago',
        checkIn: d(14),
        checkOut: d(19),
        status: ReservationStatus.pending,
        color: const Color(0xFF5C6BC0),
      ),
    ];

    List<Reservation> studios() => [
      Reservation(
        id: 'S-3001',
        guest: 'Eva Duarte',
        checkIn: d(-5),
        checkOut: d(-1),
        status: ReservationStatus.confirmed,
        color: const Color(0xFF26A69A),
      ),
      Reservation(
        id: 'S-3002',
        guest: 'Nuno Tavares',
        checkIn: d(9),
        checkOut: d(13),
        status: ReservationStatus.confirmed,
        color: const Color(0xFF8E24AA),
      ),
    ];

    return {
      //TODO title como key por agora, no futuro ID do backend
      'Casa Vela': apts(),
      'Propriedade 2': apts()
          .map((r) => r.copyWith(color: const Color(0xFF009688)))
          .toList(),
      'Propriedade 3': villas(),
      'Propriedade 4': studios(),
    };
  }
}

class MockProfitsProvider implements ProfitsProvider {
  @override
  List<ProfitPoint> fetchSeries(String propertyKey) {
    final now = DateTime.now();
    DateTime m(int back) => DateTime(now.year, now.month - (11 - back), 1);

    List<double> base;
    switch (propertyKey) {
      case 'Propriedade 2':
        base = [
          -3000,
          -1800,
          -900,
          -200,
          150,
          300,
          100,
          -50,
          200,
          350,
          500,
          650,
        ];
        break;
      case 'Propriedade 3':
        base = [
          -2500,
          -1200,
          -600,
          -100,
          250,
          450,
          300,
          150,
          300,
          450,
          700,
          900,
        ];
        break;
      case 'Propriedade 4':
        base = [-1000, -800, -400, -150, 50, 150, 120, 80, 140, 220, 260, 300];
        break;
      default:
        base = [
          -6000,
          -3000,
          -1000,
          -800,
          -900,
          -700,
          -850,
          -200,
          100,
          250,
          400,
          900,
        ];
    }

    return List.generate(12, (i) => ProfitPoint(m(i), base[i].toDouble()));
  }
}

/// ---------- Helpers ----------
extension on Reservation {
  Reservation copyWith({
    String? id,
    String? guest,
    DateTime? checkIn,
    DateTime? checkOut,
    ReservationStatus? status,
    Color? color,
  }) {
    return Reservation(
      id: id ?? this.id,
      guest: guest ?? this.guest,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      status: status ?? this.status,
      color: color ?? this.color,
    );
  }
}
