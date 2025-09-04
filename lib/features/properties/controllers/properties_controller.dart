import '../../../core/models/property_model.dart';
import '../data/dto/property_dto.dart';
import '../data/properties_api.dart';

class PropertiesController {
  final _api = PropertiesApi();

  Future<List<PropertyItem>> fetchAll() async {
    final dtos = await _api.getAll();
    return dtos.map((d) => PropertyItem(d.id, d.asModel())).toList();
  }

  Future<PropertyItem> create({
    required String title,
    required String address,
    required String type,
    double estimatedProfit = 0,
    int bookings = 0,
  }) async {
    final created = await _api.create(
      PropertyDto(
        id: '',
        title: title,
        address: address,
        bookings: bookings,
        estimatedProfit: estimatedProfit,
        type: type,
      ),
    );
    return PropertyItem(created.id, created.asModel());
  }

  Future<PropertyItem> update(String id, PropertyModel model) async {
    final updated = await _api.update(
      id,
      PropertyDto(
        id: id,
        title: model.title,
        address: model.address,
        bookings: model.bookings,
        estimatedProfit: model.estimatedProfit,
        type: model.type,
      ),
    );
    return PropertyItem(updated.id, updated.asModel());
  }

  Future<void> delete(String id) => _api.delete(id);

  Future<String> uploadCover(String id, String filePath) =>
      _api.uploadCover(id, filePath);
}
