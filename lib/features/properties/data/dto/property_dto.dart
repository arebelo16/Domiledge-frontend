import '../../../../core/models/property_model.dart';
import '../../utils/type_mapper.dart';

class PropertyDto {
  final String id;            // UUID
  final String title;
  final String address;
  final int bookings;
  final double estimatedProfit;
  final String? type;
  final String? coverUrl;

  PropertyDto({
    required this.id,
    required this.title,
    required this.address,
    required this.bookings,
    required this.estimatedProfit,
    required this.type,
    this.coverUrl,
  });

  factory PropertyDto.fromJson(Map<String, dynamic> j) => PropertyDto(
    id: (j['id'] ?? '').toString(),
    title: (j['title'] ?? '') as String,
    address: (j['address'] ?? '') as String,
    bookings: (j['bookings'] ?? 0) as int,
    estimatedProfit: (j['estimatedProfit'] ?? 0).toDouble(),
    type: (j['type'] ?? '') as String,
    coverUrl: j['coverUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'address': address,
    'bookings': bookings,
    'estimatedProfit': estimatedProfit,
    'type': type,
    if (coverUrl != null) 'coverUrl': coverUrl,
    if (type != null) 'type': type,
  };

  PropertyModel asModel() => PropertyModel(
    title: title,
    address: address,
    bookings: bookings,
    estimatedProfit: estimatedProfit,
    type: TypeMapper.toPt(type),
  );
}