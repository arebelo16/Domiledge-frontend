class PropertyModel {
  final String title;
  final String address;
  final int bookings;
  final double estimatedProfit;
  final String type;

  const PropertyModel({
    required this.title,
    required this.address,
    required this.bookings,
    required this.estimatedProfit,
    required this.type,
  });
}

class PropertyItem {
  final String id;
  final PropertyModel model;
  PropertyItem(this.id, this.model);
}
