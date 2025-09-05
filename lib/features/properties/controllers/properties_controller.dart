import '../../../core/models/property_model.dart';
import '../data/dto/property_dto.dart';
import '../data/properties_api.dart';
import '../utils/type_mapper.dart';

class PropertiesController {
  final _api = PropertiesApi();

  Future<List<PropertyItem>> fetchAll() async {
    final dtos = await _api.getAll();
    return dtos.map((d) {
      final modelApi = d.asModel();
      final modelUi = PropertyModel(
        title: modelApi.title,
        address: modelApi.address,
        bookings: modelApi.bookings,
        estimatedProfit: modelApi.estimatedProfit,
        type: TypeMapper.toPt(d.type),
      );
      return PropertyItem(d.id, modelUi);
    }).toList();
  }

  Future<PropertyItem> create({
    required String title,
    required String address,
    required String type,
    double estimatedProfit = 0,
    int bookings = 0,
  }) async {
    final typeApi = TypeMapper.toApi(type);
    final created = await _api.create(
      PropertyDto(
        id: '',
        title: title,
        address: address,
        bookings: bookings,
        estimatedProfit: estimatedProfit,
        type: typeApi.isEmpty ? null : typeApi,
      ),
    );

    final modelUi = PropertyModel(
      title: created.title,
      address: created.address,
      bookings: created.bookings,
      estimatedProfit: created.estimatedProfit,
      type: TypeMapper.toPt(created.type),
    );
    return PropertyItem(created.id, modelUi);
  }

  Future<PropertyItem> update(String id, PropertyModel model) async {
    final apiType = TypeMapper.toApi(model.type);

    final updated = await _api.update(
      id,
      PropertyDto(
        id: id,
        title: model.title,
        address: model.address,
        bookings: model.bookings,
        estimatedProfit: model.estimatedProfit,
        type: apiType.isEmpty ? null : apiType,
      ),
    );

    final modelUi = PropertyModel(
      title: updated.title,
      address: updated.address,
      bookings: updated.bookings,
      estimatedProfit: updated.estimatedProfit,
      type: TypeMapper.toPt(updated.type),
    );
    return PropertyItem(updated.id, modelUi);
  }

  Future<void> delete(String id) => _api.delete(id);

  Future<String> uploadCover(String id, String filePath) =>
      _api.uploadCover(id, filePath);
}
