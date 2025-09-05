import 'package:flutter/material.dart';

enum ReservationStatus { confirmed, pending, cancelled }

class Reservation {
  final String id;
  final String guest;
  final DateTime checkIn;
  final DateTime checkOut;
  final ReservationStatus status;
  final Color color;

  const Reservation({
    required this.id,
    required this.guest,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.color,
  });
}